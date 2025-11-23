import 'model.dart';
import 'service.dart';

class OrganizationRepository {
  final OrganizationService _service = OrganizationService();

  Future<List<Organization>> fetchOrganizations() {
    return _service.getOrganizations();
  }
}
