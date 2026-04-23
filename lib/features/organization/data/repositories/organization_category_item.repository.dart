import '../models/organization_category_item_model.dart';
import '../services/organization_category_item_service.dart';

class OrganizationCategoryItemRepository {
  final OrganizationCategoryItemService _service = OrganizationCategoryItemService();

  static List<OrganizationCategoryItemModel>? _cachedItems;

  Future<List<OrganizationCategoryItemModel>> fetchOrganizationCategoryItem() async {
    if (_cachedItems != null && _cachedItems!.isNotEmpty) {
      return _cachedItems!;
    }

    try {
      final items = await _service.getOrganizationCategoryItem();
      _cachedItems = items;
      return _cachedItems!;
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() {
    _cachedItems = null;
  }
}