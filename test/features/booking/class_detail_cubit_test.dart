import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_cubit.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_state.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';

import 'fake_classes_repository.dart';

GymClassResource _sampleClassWithEvents() {
  return GymClassResource(
    id: 'class-1',
    name: 'Core Flow',
    allowSinglePurchase: true,
    allowPackageBooking: true,
    isActive: true,
    upcomingEvents: [
      UpcomingEvent(
        id: 'evt-early',
        startAt: DateTime.utc(2026, 5, 10, 8),
        endAt: DateTime.utc(2026, 5, 10, 9),
        status: 'scheduled',
        branchName: 'North',
        trainerName: 'Alex',
        slotsLeft: 3,
      ),
      UpcomingEvent(
        id: 'evt-late',
        startAt: DateTime.utc(2026, 5, 12, 8),
        endAt: DateTime.utc(2026, 5, 12, 9),
        status: 'scheduled',
        branchName: 'South',
        trainerName: 'Blake',
        slotsLeft: 1,
      ),
    ],
  );
}

void main() {
  late FakeClassesRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeClassesRepository();
  });

  test('loadClassDetail passes trimmed class id to repository', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(_sampleClassWithEvents());
    final cubit = ClassDetailCubit(
      fakeRepo,
      '  class-1  ',
    );
    await cubit.loadClassDetail();
    expect(fakeRepo.lastClassDetailId, 'class-1');
    await cubit.close();
  });

  test('loadClassDetail success maps earliest event when no preference', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(_sampleClassWithEvents());
    final cubit = ClassDetailCubit(fakeRepo, 'class-1');
    await cubit.loadClassDetail();
    expect(cubit.state.status, ClassDetailLoadStatus.loaded);
    expect(cubit.state.slot?.calendarEventId, 'evt-early');
    expect(cubit.state.slot?.trainerName, 'Alex');
    expect(fakeRepo.getClassDetailCalls, 1);
    await cubit.close();
  });

  test('loadClassDetail prefers matching calendar event id', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(_sampleClassWithEvents());
    final cubit = ClassDetailCubit(
      fakeRepo,
      'class-1',
      preferredCalendarEventId: 'evt-late',
    );
    await cubit.loadClassDetail();
    expect(cubit.state.slot?.calendarEventId, 'evt-late');
    expect(cubit.state.slot?.trainerName, 'Blake');
    await cubit.close();
  });

  test('loadClassDetail uses preloaded slot event id as preference', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(_sampleClassWithEvents());
    final preload = ClassSlotViewModel(
      classId: 'class-1',
      calendarEventId: 'evt-late',
      name: 'Placeholder',
      allowPackageBooking: true,
      allowSinglePurchase: true,
      trainerName: 'X',
      branchName: 'Y',
      startAt: DateTime.utc(2026, 1, 1),
      endAt: DateTime.utc(2026, 1, 1, 1),
    );
    final cubit = ClassDetailCubit(
      fakeRepo,
      'class-1',
      preloadedSlot: preload,
    );
    await cubit.loadClassDetail();
    expect(cubit.state.slot?.calendarEventId, 'evt-late');
    await cubit.close();
  });

  test('loadClassDetail explicit preference wins over preloaded slot', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(_sampleClassWithEvents());
    final preload = ClassSlotViewModel(
      classId: 'class-1',
      calendarEventId: 'evt-late',
      name: 'Placeholder',
      allowPackageBooking: true,
      allowSinglePurchase: true,
      trainerName: 'X',
      branchName: 'Y',
      startAt: DateTime.utc(2026, 1, 1),
      endAt: DateTime.utc(2026, 1, 1, 1),
    );
    final cubit = ClassDetailCubit(
      fakeRepo,
      'class-1',
      preloadedSlot: preload,
      preferredCalendarEventId: 'evt-early',
    );
    await cubit.loadClassDetail();
    expect(cubit.state.slot?.calendarEventId, 'evt-early');
    await cubit.close();
  });

  test('loadClassDetail with no upcoming events clears bookable slot', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(
      GymClassResource(
        id: 'class-empty',
        name: 'Empty',
        allowSinglePurchase: true,
        allowPackageBooking: true,
        isActive: true,
        upcomingEvents: const [],
      ),
    );
    final cubit = ClassDetailCubit(fakeRepo, 'class-empty');
    await cubit.loadClassDetail();
    expect(cubit.state.slot?.hasBookableSlot, isFalse);
    expect(cubit.state.slot?.calendarEventId, '');
    await cubit.close();
  });

  test('loadClassDetail ignores unknown preferred id and uses earliest event', () async {
    fakeRepo.getClassDetailResult = ApiSuccess(_sampleClassWithEvents());
    final cubit = ClassDetailCubit(
      fakeRepo,
      'class-1',
      preferredCalendarEventId: 'no-such-event',
    );
    await cubit.loadClassDetail();
    expect(cubit.state.slot?.calendarEventId, 'evt-early');
    await cubit.close();
  });

  test('loadClassDetail failure without preload is error', () async {
    fakeRepo.getClassDetailResult = ApiFailure<GymClassResource>(
      NetworkException(type: NetworkFailureType.unknown, message: 'network'),
    );
    final cubit = ClassDetailCubit(fakeRepo, 'class-1');
    await cubit.loadClassDetail();
    expect(cubit.state.status, ClassDetailLoadStatus.error);
    expect(cubit.state.slot, isNull);
    expect(cubit.state.errorMessage, 'network');
    await cubit.close();
  });

  test('loadClassDetail failure with preload keeps loaded skeleton', () async {
    fakeRepo.getClassDetailResult = ApiFailure<GymClassResource>(
      NetworkException(type: NetworkFailureType.unknown, message: 'network'),
    );
    final preload = ClassSlotViewModel(
      classId: 'class-1',
      calendarEventId: 'evt-x',
      name: 'Placeholder',
      allowPackageBooking: true,
      allowSinglePurchase: true,
      trainerName: 'X',
      branchName: 'Y',
      startAt: DateTime.utc(2026, 1, 1),
      endAt: DateTime.utc(2026, 1, 1, 1),
    );
    final cubit = ClassDetailCubit(
      fakeRepo,
      'class-1',
      preloadedSlot: preload,
    );
    await cubit.loadClassDetail();
    expect(cubit.state.status, ClassDetailLoadStatus.loaded);
    expect(cubit.state.slot?.name, 'Placeholder');
    expect(cubit.state.errorMessage, 'network');
    await cubit.close();
  });
}
