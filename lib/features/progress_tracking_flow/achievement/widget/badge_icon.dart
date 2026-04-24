import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Network badge [iconUrl] when valid HTTPS, else [fallbackAsset].
class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    super.key,
    required this.iconUrl,
    required this.fallbackAsset,
    this.size = 40,
  });

  final String? iconUrl;
  final String fallbackAsset;
  final double size;

  static bool _isHttpUrl(String? url) {
    if (url == null) return false;
    final t = url.trim();
    return t.startsWith('https://') || t.startsWith('http://');
  }

  @override
  Widget build(BuildContext context) {
    final url = iconUrl?.trim();
    if (_isHttpUrl(url)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              SvgPicture.asset(fallbackAsset, height: size, width: size),
        ),
      );
    }
    return SvgPicture.asset(fallbackAsset, height: size, width: size);
  }
}
