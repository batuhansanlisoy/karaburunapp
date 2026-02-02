import '../models/organization_model.dart';
import '../services/organization_service.dart';

class OrganizationRepository {
  final OrganizationService _service = OrganizationService();

  Future<List<OrganizationModel>> fetchOrganizations({ int? categoryId}) {
    return _service.getOrganizations(categoryId: categoryId);
  }
}
