import '../../repositories/booking_repository.dart';

class GetBookingDetailUsecase {
  final BookingRepository repository;

  GetBookingDetailUsecase(this.repository);

  Future<Map<String, dynamic>> execute(int bookingId) async {
    return await repository.getBookingDetail(bookingId);
  }
}

