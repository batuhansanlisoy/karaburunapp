import 'model.dart';
import 'service.dart';

class OrganizationRepository {
  final OrganizationService _service = OrganizationService();

  Future<List<Organization>> fetchOrganizations() {
    return _service.getOrganizations();
  }

  Future<List<Organization>> fetchRestaurants({int categoryId = 16}) {
    return _service.getOrganizations(categoryId: categoryId);
  }

  Future<List<Organization>> fetchCafes({int categoryId = 2}) {
    return _service.getOrganizations(categoryId: categoryId);
  }

  // Future<List<Organization>> fetchHotel({int categoryId = 3}) {
  //   return _service.getOrganizations(categoryId: categoryId);
  // }
}
