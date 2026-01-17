class PhoneUtils {
  /// Normalizes Syrian phone numbers to +963 format
  /// Accepts: 0991877688, +963991877688, 00963991877688, 963991877688
  /// Returns: +963991877688
  static String normalizeSyrianPhone(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(' ', '').replaceAll('-', '').trim();
    
    // Remove leading zeros
    String normalized = cleaned.replaceFirst(RegExp(r'^0+'), '');
    
    // If it starts with 963, add +
    if (normalized.startsWith('963')) {
      return '+$normalized';
    }
    
    // If it starts with 9 (Syrian mobile number without country code)
    if (normalized.startsWith('9') && normalized.length == 9) {
      return '+963$normalized';
    }
    
    // If it already has +, return as is
    if (normalized.startsWith('+')) {
      return normalized;
    }
    
    // Default: assume it's a local number starting with 0, remove 0 and add +963
    if (normalized.startsWith('0')) {
      normalized = normalized.substring(1);
    }
    
    if (normalized.startsWith('9') && normalized.length == 9) {
      return '+963$normalized';
    }
    
    // If we can't normalize, return original (validation should catch invalid numbers)
    return phoneNumber;
  }
}
