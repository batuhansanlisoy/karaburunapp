import '../models/organization_category_model.dart';
import '../services/organization_category_service.dart';

class OrganizationCategoryRepository {
  final OrganizationCategoryService _service = OrganizationCategoryService();

  static List<OrganizationCategoryModel>? _cachedOrganizationCategories;

  Future<List<OrganizationCategoryModel>> fetchOrganizationCategory()  async{

    if (_cachedOrganizationCategories != null && _cachedOrganizationCategories!.isNotEmpty) {
      return _cachedOrganizationCategories!;
    }

    try {
      final orgCategories = await _service.getOrganizationCategory();
      _cachedOrganizationCategories = orgCategories;
      return _cachedOrganizationCategories!;
    } catch (e) {
      rethrow;
    }
  }
}
