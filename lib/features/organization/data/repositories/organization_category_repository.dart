import '../models/organization_category_model.dart';
import '../services/organization_category_service.dart';

class OrganizationCategoryRepository {
  final OrganizationCategoryService _service = OrganizationCategoryService();

  Future<List<OrganizationCategoryModel>> fetchOrganizationCategory() {
    return _service.getOrganizationCategory();
  }
}
