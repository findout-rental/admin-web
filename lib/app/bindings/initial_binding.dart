import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/dashboard_remote_datasource.dart';
import '../../data/datasources/remote/registration_remote_datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/apartment_remote_datasource.dart';
import '../../data/datasources/remote/booking_remote_datasource.dart';
import '../../data/datasources/remote/profile_remote_datasource.dart';
import '../../data/datasources/remote/location_remote_datasource.dart';
import '../../data/datasources/remote/notification_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/repositories/registration_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/apartment_repository_impl.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/registration_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/apartment_repository.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/dashboard/get_statistics_usecase.dart';
import '../../domain/usecases/registration/get_pending_registrations_usecase.dart';
import '../../domain/usecases/registration/approve_registration_usecase.dart';
import '../../domain/usecases/registration/reject_registration_usecase.dart';
import '../../domain/usecases/user/get_all_users_usecase.dart';
import '../../domain/usecases/user/get_user_detail_usecase.dart';
import '../../domain/usecases/user/delete_user_usecase.dart';
import '../../domain/usecases/user/deposit_money_usecase.dart';
import '../../domain/usecases/user/withdraw_money_usecase.dart';
import '../../domain/usecases/user/get_transaction_history_usecase.dart';
import '../../domain/usecases/apartment/get_all_apartments_usecase.dart';
import '../../domain/usecases/apartment/get_apartment_detail_usecase.dart';
import '../../domain/usecases/booking/get_all_bookings_usecase.dart';
import '../../domain/usecases/booking/get_booking_detail_usecase.dart';
import '../../domain/usecases/profile/get_profile_usecase.dart';
import '../../domain/usecases/profile/update_profile_usecase.dart';
import '../../domain/usecases/profile/upload_photo_usecase.dart';
import '../../domain/usecases/profile/update_language_usecase.dart';
import '../../domain/usecases/location/get_governorates_usecase.dart';
import '../../domain/usecases/location/get_cities_by_governorate_usecase.dart';
import '../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../domain/usecases/notification/mark_notification_read_usecase.dart';
import '../../domain/usecases/notification/mark_all_read_usecase.dart';
import '../../domain/usecases/notification/get_unread_count_usecase.dart';
import '../../presentation/controllers/auth/auth_controller.dart';
import '../../presentation/controllers/auth/login_controller.dart';
import '../../presentation/controllers/notification/notification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.lazyPut(() => ApiClient(), fenix: true);
    
    // Data Sources
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(),
      fenix: true,
    );
    
    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
        localDatasource: Get.find<AuthLocalDatasource>(),
      ),
      fenix: true,
    );
    
    // Dashboard Data Sources
    Get.lazyPut<DashboardRemoteDatasource>(
      () => DashboardRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Dashboard Repositories
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(Get.find<DashboardRemoteDatasource>()),
      fenix: true,
    );
    
    // Dashboard Use Cases
    Get.lazyPut(
      () => GetStatisticsUsecase(Get.find<DashboardRepository>()),
      fenix: true,
    );
    
    // Registration Data Sources
    Get.lazyPut<RegistrationRemoteDatasource>(
      () => RegistrationRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Registration Repositories
    Get.lazyPut<RegistrationRepository>(
      () => RegistrationRepositoryImpl(Get.find<RegistrationRemoteDatasource>()),
      fenix: true,
    );
    
    // Registration Use Cases
    Get.lazyPut(
      () => GetPendingRegistrationsUsecase(Get.find<RegistrationRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ApproveRegistrationUsecase(Get.find<RegistrationRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => RejectRegistrationUsecase(Get.find<RegistrationRepository>()),
      fenix: true,
    );
    
    // User Data Sources
    Get.lazyPut<UserRemoteDatasource>(
      () => UserRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // User Repositories
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<UserRemoteDatasource>()),
      fenix: true,
    );
    
    // User Use Cases
    Get.lazyPut(
      () => GetAllUsersUsecase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetUserDetailUsecase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DeleteUserUsecase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DepositMoneyUsecase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => WithdrawMoneyUsecase(Get.find<UserRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetTransactionHistoryUsecase(Get.find<UserRepository>()),
      fenix: true,
    );
    
    // Apartment Data Sources
    Get.lazyPut<ApartmentRemoteDatasource>(
      () => ApartmentRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Apartment Repositories
    Get.lazyPut<ApartmentRepository>(
      () => ApartmentRepositoryImpl(Get.find<ApartmentRemoteDatasource>()),
      fenix: true,
    );
    
    // Apartment Use Cases
    Get.lazyPut(
      () => GetAllApartmentsUsecase(Get.find<ApartmentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetApartmentDetailUsecase(Get.find<ApartmentRepository>()),
      fenix: true,
    );
    
    // Booking Data Sources
    Get.lazyPut<BookingRemoteDatasource>(
      () => BookingRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Booking Repositories
    Get.lazyPut<BookingRepository>(
      () => BookingRepositoryImpl(Get.find<BookingRemoteDatasource>()),
      fenix: true,
    );
    
    // Booking Use Cases
    Get.lazyPut(
      () => GetAllBookingsUsecase(Get.find<BookingRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetBookingDetailUsecase(Get.find<BookingRepository>()),
      fenix: true,
    );
    
    // Profile Data Sources
    Get.lazyPut<ProfileRemoteDatasource>(
      () => ProfileRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Profile Repositories
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileRemoteDatasource>()),
      fenix: true,
    );
    
    // Profile Use Cases
    Get.lazyPut(
      () => GetProfileUsecase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UpdateProfileUsecase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UploadPhotoUsecase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UpdateLanguageUsecase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    
    // Location Data Sources
    Get.lazyPut<LocationRemoteDatasource>(
      () => LocationRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Location Repositories
    Get.lazyPut<LocationRepository>(
      () => LocationRepositoryImpl(Get.find<LocationRemoteDatasource>()),
      fenix: true,
    );
    
    // Location Use Cases
    Get.lazyPut(
      () => GetGovernoratesUsecase(Get.find<LocationRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCitiesByGovernorateUsecase(Get.find<LocationRepository>()),
      fenix: true,
    );
    
    // Notification Data Sources
    Get.lazyPut<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Notification Repositories
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(Get.find<NotificationRemoteDatasource>()),
      fenix: true,
    );
    
    // Notification Use Cases
    Get.lazyPut(
      () => GetNotificationsUsecase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => MarkNotificationReadUsecase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => MarkAllReadUsecase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetUnreadCountUsecase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    
    // Controllers
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(
      () => NotificationController(
        getNotificationsUsecase: Get.find<GetNotificationsUsecase>(),
        markNotificationReadUsecase: Get.find<MarkNotificationReadUsecase>(),
        markAllReadUsecase: Get.find<MarkAllReadUsecase>(),
        getUnreadCountUsecase: Get.find<GetUnreadCountUsecase>(),
      ),
      fenix: true,
    );
  }
}

