extension StringValidationExtensions on String? {

  bool hasMatch(String? s, String p) {
    return (s == null) ? false : RegExp(p).hasMatch(s);
  }

  bool get isEmail {
    if (this == null) return false;
    return hasMatch(this, r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  }

  bool get isPhone {
    if (this == null) return false;
    return hasMatch(this, r'^\+?[\d\s-]{10,15}$');
  }

  bool get isNumeric {
    if (this == null) return false;
    return hasMatch(this, r'^[0-9]+$');
  }

  bool get isUrl {
    if (this == null) return false;
    return hasMatch(this, r'^(http|https|ftp):\/\/[^\s/$.?#].[^\s]*$');
  }

  bool get isNotNullOrEmpty {
    return this != null && this!.isNotEmpty;
  }

  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  bool hasMinLength(int minLength) {
    if (this == null) return false;
    return this!.length >= minLength;
  }

  bool hasMaxLength(int maxLength) {
    if (this == null) return false;
    return this!.length <= maxLength;
  }

  bool get isStrongPassword {
    if (this == null) return false;
    return hasMatch(this, r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  }

}