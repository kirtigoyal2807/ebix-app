import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/utils/branch_location_utils.dart';

void main() {
  group('BranchLocationUtils', () {
    test('sortNearestFirst orders by distance when coords exist', () {
      const near = Branch(
        id: 1,
        title: 'Near',
        city: 'Riyadh',
        distance: '',
        typeLabel: 'Studio',
        lat: 24.7136,
        lng: 46.6753,
      );
      const far = Branch(
        id: 2,
        title: 'Far',
        city: 'Riyadh',
        distance: '',
        typeLabel: 'Studio',
        lat: 24.8,
        lng: 46.8,
      );

      final sorted = BranchLocationUtils.sortNearestFirst(
        [far, near],
        userLat: 24.7136,
        userLng: 46.6753,
      );

      expect(sorted.first.id, 1);
    });

    test('distanceLabel uses API distance when position unknown', () {
      const branch = Branch(
        id: 1,
        title: 'A',
        city: 'Riyadh',
        distance: '3 km',
        typeLabel: 'Studio',
      );

      expect(
        BranchLocationUtils.distanceLabel(branch, userLat: null, userLng: null),
        '3 km',
      );
    });
  });
}
