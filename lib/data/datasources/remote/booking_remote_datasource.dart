import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class BookingRemoteDatasource {
  Future<Map<String, dynamic>> getAllBookings({
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

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final ApiClient apiClient;

  BookingRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getAllBookings({
    String? search,
    String? status,
    DateTime? checkInFrom,
    DateTime? checkInTo,
    String? sort,
    int page = 1,
    int perPage = 25,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null && status.isNotEmpty && status != 'all') {
      queryParams['status'] = status;
    }
    if (checkInFrom != null) {
      queryParams['check_in_from'] = checkInFrom.toIso8601String();
    }
    if (checkInTo != null) {
      queryParams['check_in_to'] = checkInTo.toIso8601String();
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await apiClient.get(
      ApiConstants.allBookings,
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    final response = await apiClient.get('${ApiConstants.allBookings}/$bookingId');
    return response.data as Map<String, dynamic>;
  }
}

