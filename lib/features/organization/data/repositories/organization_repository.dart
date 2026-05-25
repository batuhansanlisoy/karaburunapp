import '../models/organization_model.dart';
import '../services/organization_service.dart';

class OrganizationRepository {
  final OrganizationService _service = OrganizationService();

  Future<OrganizationModel?> singleOrganization(int orgId) {
    return _service.getSingle(orgId);
  }

  Future<List<OrganizationModel>> fetchOrganizations({ 
      int? categoryId,
      bool? highlight,
      bool? isActive,
      bool? subCategoryInfo,
      List<int>? ids,
  }) {
      return _service.getOrganizations(
        categoryId: categoryId,
        highlight: highlight,
        isActive: isActive,
        subCategoryInfo: subCategoryInfo,
        ids: ids,
      );
    }
}
