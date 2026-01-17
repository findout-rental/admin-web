class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? mobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    
    final cleaned = value.replaceAll(' ', '').replaceAll('-', '').trim();
    
    // Syrian phone number validation
    // Accepts: +963991877688, 0991877688, 00963991877688, 963991877688, 991877688
    // Syrian mobile numbers: must have 9 digits starting with 9 after the prefix
    // Patterns (all end with 991877688 = 9 digits starting with 9):
    // 1. +963991877688 - 13 chars: +963 + 991877688 (9 digits)
    // 2. 00963991877688 - 14 chars: 00963 + 991877688 (9 digits)
    // 3. 963991877688 - 12 chars: 963 + 991877688 (9 digits)
    // 4. 0991877688 - 10 chars: 0 + 991877688 (9 digits) - LOCAL FORMAT
    // 5. 991877688 - 9 chars: just 991877688 (9 digits)
    
    // Match any of these patterns - all end with 9 followed by 8 more digits
    final syrianRegex = RegExp(
      r'^(\+9639\d{8}|009639\d{8}|9639\d{8}|09\d{8}|9\d{8})$'
    );
    
    if (!syrianRegex.hasMatch(cleaned)) {
      return 'Please enter a valid Syrian mobile number';
    }
    
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? minLength(String? value, int minLength) {
    if (value == null || value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Must be at most $maxLength characters';
    }
    return null;
  }
}

