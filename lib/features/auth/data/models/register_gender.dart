/// Maps to API `gender`: male | female | other
enum RegisterGender { male, female, other }

extension RegisterGenderApi on RegisterGender {
  String get apiValue => name;
}
