final class InputValidators {
  InputValidators._();

  // Practical email pattern for client-side validation.
  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static bool isValidEmail(String value) {
    return _emailRegex.hasMatch(value.trim());
  }
}
