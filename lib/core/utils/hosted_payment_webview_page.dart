import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Popped from [HostedPaymentWebViewPage] when the user leaves the PSP flow.
enum HostedPaymentWebViewOutcome {
  /// `success: true` in JSON body, success query param, server message match, or JS channel.
  success,

  /// User closed the WebView before a success signal.
  cancelled,
}

/// Result of [HostedPaymentWebViewPage] — includes optional PSP / gateway payload
/// for receipt merge and for H5 pages that call [PilatesPayment] `postMessage`.
class HostedPaymentWebViewResult {
  const HostedPaymentWebViewResult({
    required this.outcome,
    this.gatewayPayload,
  });

  final HostedPaymentWebViewOutcome outcome;

  /// JSON return body, flattened query params on success URLs, or data from the
  /// `PilatesPayment` JavaScript channel (see [HostedPaymentWebViewPage]).
  final Map<String, dynamic>? gatewayPayload;
}

/// Hosted PayTabs (or similar) checkout in a full-screen [WebViewWidget].
///
/// When the return URL renders **raw JSON** (e.g.
/// `{"success":true,"message":"PayTabs callback processed successfully","data":null}`),
/// this reads the DOM with retries (Android often finishes [onPageFinished] before
/// [innerText]/[textContent] is populated) and pops with success so the app can
/// refresh checkout and open the receipt.
///
/// **Android back:** [PopScope] maps the system back button to a **cancelled** result
/// so callers do not fall through to opening the same URL in an external browser
/// (which would show the same raw JSON again).
///
/// **H5 → Flutter:** host or inject a page that calls:
/// `PilatesPayment.postMessage(JSON.stringify({ "tran_ref": "…", … }))`
class HostedPaymentWebViewPage extends StatefulWidget {
  const HostedPaymentWebViewPage({
    super.key,
    required this.initialUrl,
  });

  final String initialUrl;

  @override
  State<HostedPaymentWebViewPage> createState() =>
      _HostedPaymentWebViewPageState();
}

class _HostedPaymentWebViewPageState extends State<HostedPaymentWebViewPage> {
  late final WebViewController _controller;
  var _loading = true;
  var _popped = false;

  /// Delays after [onPageFinished] to re-read DOM — Android WebView often reports
  /// an empty body on the first finish for `application/json` responses.
  static const List<Duration> _jsonRetryDelays = <Duration>[
    Duration.zero,
    Duration(milliseconds: 120),
    Duration(milliseconds: 350),
    Duration(milliseconds: 700),
    Duration(milliseconds: 1400),
    Duration(milliseconds: 2600),
  ];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PilatesPayment',
        onMessageReceived: (JavaScriptMessage message) {
          _onJsPaymentMessage(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: _handlePageFinished,
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  void _onJsPaymentMessage(String raw) {
    if (_popped || !mounted) return;
    final map = <String, dynamic>{'source': 'js_channel'};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        map.addAll(Map<String, dynamic>.from(decoded as Map));
      } else {
        map['message'] = raw;
      }
    } catch (_) {
      map['message'] = raw;
    }
    _popResult(
      HostedPaymentWebViewResult(
        outcome: HostedPaymentWebViewOutcome.success,
        gatewayPayload: map,
      ),
    );
  }

  void _popResult(HostedPaymentWebViewResult result) {
    if (_popped || !mounted) return;
    _popped = true;
    Navigator.of(context).pop(result);
  }

  Future<void> _handlePageFinished(String url) async {
    if (!mounted || _popped) return;
    setState(() => _loading = false);

    final uri = Uri.tryParse(url);
    if (uri != null) {
      final q = uri.queryParameters;
      final okQuery = q['success'] == 'true' ||
          q['payment_status'] == 'success' ||
          q['status'] == 'success';
      if (okQuery) {
        final payload = <String, dynamic>{'source': 'return_url_query'};
        payload.addAll(q);
        _popResult(
          HostedPaymentWebViewResult(
            outcome: HostedPaymentWebViewOutcome.success,
            gatewayPayload: payload,
          ),
        );
        return;
      }
    }

    unawaited(_pollDomForPayTabsJson());
  }

  /// Reads `document.body` / `<pre>` / `documentElement` text and parses PayTabs-style JSON.
  Future<void> _pollDomForPayTabsJson() async {
    for (final delay in _jsonRetryDelays) {
      if (!mounted || _popped) return;
      if (delay > Duration.zero) {
        await Future<void>.delayed(delay);
      }
      if (!mounted || _popped) return;

      try {
        final raw = await _controller.runJavaScriptReturningResult(
          _extractJsonFromDomJs,
        );
        final text = _javaScriptResultToString(raw);
        if (_tryPopFromJsonText(text)) return;
      } catch (_) {
        // Ignore transient JS errors while DOM settles.
      }
    }
  }

  /// Minified script: gather text from body, all `<pre>`, and root; extract `{…}`.
  static const String _extractJsonFromDomJs = r'''(function(){
try{
function t(el){if(!el)return'';return String(el.innerText||el.textContent||'').trim();}
var parts=[];
parts.push(t(document.body));
var pres=document.getElementsByTagName('pre');
for(var i=0;i<pres.length;i++){parts.push(t(pres[i]));}
parts.push(t(document.documentElement));
for(var j=0;j<parts.length;j++){
var s=parts[j];
if(!s)continue;
var a=s.indexOf('{');
var z=s.lastIndexOf('}');
if(a>=0&&z>a){var sub=s.substring(a,z+1);if(sub.length>2)return sub;}
}
return '';
}catch(e){return '';}
})()''';

  bool _tryPopFromJsonText(String text) {
    if (text.isEmpty) return false;
    final trimmed = text.trim();
    var jsonSlice = trimmed;
    if (!trimmed.startsWith('{')) {
      final a = trimmed.indexOf('{');
      final z = trimmed.lastIndexOf('}');
      if (a < 0 || z <= a) return false;
      jsonSlice = trimmed.substring(a, z + 1);
    }

    try {
      final decoded = jsonDecode(jsonSlice);
      if (decoded is! Map) return false;
      final m = Map<String, dynamic>.from(decoded as Map);
      final success = m['success'];
      final message = m['message']?.toString().toLowerCase() ?? '';
      final ok = success == true ||
          success == 1 ||
          success == 'true' ||
          success == '1' ||
          m['status']?.toString().toLowerCase() == 'success' ||
          (message.contains('paytabs') && message.contains('success'));
      if (ok && mounted) {
        final payload = <String, dynamic>{
          'source': 'return_page_json',
          ...m,
        };
        _popResult(
          HostedPaymentWebViewResult(
            outcome: HostedPaymentWebViewOutcome.success,
            gatewayPayload: payload,
          ),
        );
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  static String _javaScriptResultToString(Object? raw) {
    if (raw == null) return '';
    if (raw is String) {
      var s = raw.trim();
      if (s.length >= 2 &&
          ((s.startsWith('"') && s.endsWith('"')) ||
              (s.startsWith("'") && s.endsWith("'")))) {
        s = s.substring(1, s.length - 1);
      }
      // Unescape common JS string escapes from the WebView bridge.
      s = s.replaceAll(r'\"', '"');
      return s.trim();
    }
    return raw.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (_popped) return;
        if (didPop) return;
        _popResult(
          const HostedPaymentWebViewResult(
            outcome: HostedPaymentWebViewOutcome.cancelled,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _popResult(
                  const HostedPaymentWebViewResult(
                    outcome: HostedPaymentWebViewOutcome.cancelled,
                  ),
                ),
          ),
          title: const Text('Payment'),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            WebViewWidget(controller: _controller),
            if (_loading) const LinearProgressIndicator(minHeight: 3),
          ],
        ),
      ),
    );
  }
}
