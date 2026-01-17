import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../notification/notification_controller.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  final GetStorage storage = GetStorage();

  AuthController(this.authRepository);

  final _isAuthenticated = false.obs;
  final _currentUser = Rxn<User>();

  bool get isAuthenticated => _isAuthenticated.value;
  User? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    // Only check auth status if we're not on the login page
    // This prevents unnecessary API calls during login
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = storage.read<String>(StorageKeys.token);
    // Only make API call if we have a token but don't have a current user yet
    // This prevents unnecessary calls after login (we already have the user)
    if (token != null && authRepository.isAuthenticated() && _currentUser.value == null) {
      try {
        final user = await authRepository.getCurrentUser();
        _currentUser.value = user;
        _isAuthenticated.value = true;
      } catch (e) {
        // If token is invalid, clear it but don't navigate (let the page handle it)
        _currentUser.value = null;
        _isAuthenticated.value = false;
        storage.remove(StorageKeys.token);
        storage.remove(StorageKeys.user);
      }
    } else if (token != null && _currentUser.value != null) {
      // We have both token and user, just mark as authenticated
      _isAuthenticated.value = true;
    }
  }

  Future<bool> login(String mobileNumber, String password) async {
    try {
      final user = await authRepository.login(mobileNumber, password);
      _currentUser.value = user;
      _isAuthenticated.value = true;
      
      // Register FCM token after successful login
      _registerFCMTokenAfterLogin();
      
      // Initialize notification controller if available
      _initializeNotificationController();
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _registerFCMTokenAfterLogin() async {
    try {
      // Wait a bit for Firebase to initialize if needed
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get notification controller if it exists
      try {
        final notificationController = Get.find<NotificationController>();
        // Trigger FCM token registration
        notificationController.registerFCMToken();
      } catch (e) {
        // Notification controller not initialized yet, it will register in onInit
      }
    } catch (e) {
      // Silently fail - FCM token registration is optional
    }
  }

  void _initializeNotificationController() {
    try {
      // Ensure NotificationController is initialized
      Get.find<NotificationController>();
    } catch (e) {
      // Controller will be lazy-loaded when needed
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
    } catch (e) {
      // Log error but continue logout
    } finally {
      _currentUser.value = null;
      _isAuthenticated.value = false;
      storage.remove(StorageKeys.token);
      storage.remove(StorageKeys.user);
      Get.offAllNamed('/login');
    }
  }
}

