/// Pilates API §12 — certification object on trainer resources.
class TrainerCertification {
  const TrainerCertification({
    required this.name,
    this.issuer,
    this.certificateNumber,
    this.validUntil,
  });

  final String name;
  final String? issuer;
  final String? certificateNumber;
  final String? validUntil;

  factory TrainerCertification.fromJson(Map<String, dynamic> json) {
    return TrainerCertification(
      name: '${json['name'] ?? ''}',
      issuer: json['issuer'] as String?,
      certificateNumber:
          json['certificate_number'] as String? ??
          json['certificateNumber'] as String?,
      validUntil:
          json['valid_until'] as String? ?? json['validUntil'] as String?,
    );
  }
}
