import '../../domain/entities/booking.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/remote/booking_remote_datasource.dart';
import '../models/booking_model.dart';
import '../models/pagination_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource remoteDatasource;

  BookingRepositoryImpl(this.remoteDatasource);

  @override
  Future<({List<Booking> bookings, Pagination pagination})> getAllBookings({
    String? search,
    String? status,
    DateTime? checkInFrom,
    DateTime? checkInTo,
    String? sort,
    int page = 1,
    int perPage = 25,
  }) async {
    try {
      final response = await remoteDatasource.getAllBookings(
        search: search,
        status: status,
        checkInFrom: checkInFrom,
        checkInTo: checkInTo,
        sort: sort,
        page: page,
        perPage: perPage,
      );

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final bookingsList = data['bookings'] as List<dynamic>? ?? [];
      final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

      final bookings = bookingsList
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final pagination = PaginationModel.fromJson(paginationData);

      return (bookings: bookings, pagination: pagination);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    try {
      return await remoteDatasource.getBookingDetail(bookingId);
    } catch (e) {
      rethrow;
    }
  }
}

