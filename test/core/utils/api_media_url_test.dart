import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/utils/api_media_url.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';

void main() {
  test('resolveApiMediaUrl leaves absolute https unchanged', () {
    expect(
      resolveApiMediaUrl('https://cdn.example.com/x.jpg'),
      'https://cdn.example.com/x.jpg',
    );
  });

  test('resolveApiMediaUrl joins root-relative path to API origin', () {
    expect(
      resolveApiMediaUrl('/storage/trainer.jpg'),
      'https://dev.thepilates.sa/storage/trainer.jpg',
    );
  });

  test('TrainerResource.fromJson resolves relative avatar_url', () {
    final t = TrainerResource.fromJson({
      'id': '1',
      'displayName': 'T',
      'specialties': <dynamic>[],
      'certifications': <dynamic>[],
      'branches': <dynamic>[],
      'avatar_url': '/uploads/a.png',
    });
    expect(t.avatarUrl, 'https://dev.thepilates.sa/uploads/a.png');
  });

  test('TrainerResource.fromJson maps API imageUrl to avatarUrl', () {
    final t = TrainerResource.fromJson({
      'id': 'f70efb0a-421f-4550-8b00-fed859519047',
      'displayName': 'Sara Al-Otaibi',
      'specialties': <dynamic>[],
      'certifications': <dynamic>[],
      'branches': <dynamic>[],
      'imageUrl': 'https://i.pravatar.cc/300?img=47',
    });
    expect(t.avatarUrl, 'https://i.pravatar.cc/300?img=47');
  });

  test('TrainerResource.fromJson parses ratingBreakdown', () {
    final t = TrainerResource.fromJson({
      'id': '1',
      'displayName': 'T',
      'specialties': <dynamic>[],
      'certifications': <dynamic>[],
      'branches': <dynamic>[],
      'ratingBreakdown': [10, 5, 2, 1, 0],
    });
    expect(t.ratingBreakdown, [10, 5, 2, 1, 0]);
  });

  test('TrainerResource.fromJson parses stats and teaching styles', () {
    final t = TrainerResource.fromJson({
      'id': '1',
      'displayName': 'T',
      'specialties': <dynamic>[],
      'certifications': <dynamic>[],
      'branches': <dynamic>[],
      'total_classes_taught': 350,
      'return_rate': 0.92,
      'teaching_styles': ['Dynamic', 'Motivating'],
    });
    expect(t.totalClassesTaught, 350);
    expect(t.returnRatePercent, 92);
    expect(t.teachingStyles, ['Dynamic', 'Motivating']);
  });
}
