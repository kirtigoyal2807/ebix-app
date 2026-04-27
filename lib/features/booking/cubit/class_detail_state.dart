import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';

enum ClassDetailLoadStatus { initial, loading, loaded, error }

class ClassDetailState extends Equatable {
  const ClassDetailState({
    this.status = ClassDetailLoadStatus.initial,
    this.slot,
    this.errorMessage,
  });

  final ClassDetailLoadStatus status;

  /// Fully-resolved slot data after the event-detail API call.
  final ClassSlotViewModel? slot;

  final String? errorMessage;

  bool get isLoading => status == ClassDetailLoadStatus.loading;
  bool get isLoaded => status == ClassDetailLoadStatus.loaded;
  bool get hasError => status == ClassDetailLoadStatus.error;

  static const Object _unset = Object();

  ClassDetailState copyWith({
    ClassDetailLoadStatus? status,
    ClassSlotViewModel? slot,
    Object? errorMessage = _unset,
  }) {
    return ClassDetailState(
      status: status ?? this.status,
      slot: slot ?? this.slot,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, slot, errorMessage];
}
