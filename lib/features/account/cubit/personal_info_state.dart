import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PersonalInfoState extends Equatable {
  final String emergencyContactName;
  final String? emergencyContactRelationship;
  final String emergencyContactPhone;
  final String? idType;
  final String idNumber;

  const PersonalInfoState({
    this.emergencyContactName = '',
    this.emergencyContactRelationship,
    this.emergencyContactPhone = '',
    this.idType,
    this.idNumber = '',
  });


  PersonalInfoState copyWith({
    String? emergencyContactName,
    String? emergencyContactRelationship,
    String? emergencyContactPhone,
    String? idType,
    String? idNumber,
  }){
    return PersonalInfoState(
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelationship: emergencyContactRelationship ?? this.emergencyContactRelationship,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    emergencyContactName,
    emergencyContactRelationship,
    emergencyContactPhone,
    idType,
    idNumber,
  ];
}
