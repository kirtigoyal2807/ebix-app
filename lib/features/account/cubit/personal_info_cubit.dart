import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';


class PersonalInfoCubit extends Cubit<PersonalInfoState>{
  PersonalInfoCubit():super(PersonalInfoState());



  void updateEmergencyContactRelationship(String val) =>
      emit(state.copyWith(emergencyContactRelationship: val));

  void updateIdType(String val) => emit(state.copyWith(idType: val));

}