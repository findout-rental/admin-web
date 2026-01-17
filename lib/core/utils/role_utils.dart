import 'package:get/get.dart';

class RoleUtils {
  static String getRoleTranslation(String role) {
    if (role == 'tenant') {
      return 'tenant_role'.tr;
    } else if (role == 'owner') {
      return 'owner_role'.tr;
    }
    return role.toUpperCase();
  }
}
