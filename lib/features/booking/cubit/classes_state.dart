import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';

enum ClassesLoadStatus { initial, loading, loaded, error }

class ClassesState extends Equatable {
  const ClassesState({
    this.status = ClassesLoadStatus.initial,
    this.allClasses = const [],
    this.errorMessage,
  });

  final ClassesLoadStatus status;

  /// Raw data from GET /classes — class types each with upcomingEvents.
  final List<GymClassResource> allClasses;

  final String? errorMessage;

  bool get isLoading => status == ClassesLoadStatus.loading;
  bool get hasError => status == ClassesLoadStatus.error;
  bool get isLoaded => status == ClassesLoadStatus.loaded;

  /// Flatten all classes × upcomingEvents into individual slot view models.
  List<ClassSlotViewModel> get allSlots {
    final slots = <ClassSlotViewModel>[];
    for (final cls in allClasses) {
      for (final event in cls.upcomingEvents) {
        slots.add(ClassSlotViewModel.fromClassAndEvent(cls, event));
      }
    }
    return slots;
  }

  static const Object _unset = Object();

  ClassesState copyWith({
    ClassesLoadStatus? status,
    List<GymClassResource>? allClasses,
    Object? errorMessage = _unset,
  }) {
    return ClassesState(
      status: status ?? this.status,
      allClasses: allClasses ?? this.allClasses,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, allClasses, errorMessage];
}
