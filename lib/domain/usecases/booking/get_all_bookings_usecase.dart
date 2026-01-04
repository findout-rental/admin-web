import '../../entities/booking.dart';
import '../../entities/pagination.dart';
import '../../repositories/booking_repository.dart';

class GetAllBookingsUsecase {
  final BookingRepository repository;

  GetAllBookingsUsecase(this.repository);

  Future<({List<Booking> bookings, Pagination pagination})> execute({
    String? search,
    String? status,
    DateTime? checkInFrom,
    DateTime? checkInTo,
    String? sort,
    int page = 1,
    int perPage = 25,
  }) async {
    return await repository.getAllBookings(
      search: search,
      status: status,
      checkInFrom: checkInFrom,
      checkInTo: checkInTo,
      sort: sort,
      page: page,
      perPage: perPage,
    );
  }
}

