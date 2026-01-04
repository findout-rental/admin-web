import '../entities/booking.dart';
import '../entities/pagination.dart';

abstract class BookingRepository {
  Future<({List<Booking> bookings, Pagination pagination})> getAllBookings({
    String? search,
    String? status,
    DateTime? checkInFrom,
    DateTime? checkInTo,
    String? sort,
    int page,
    int perPage,
  });

  Future<Map<String, dynamic>> getBookingDetail(int bookingId);
}

