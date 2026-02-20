import '../models/featured_organization_model.dart';
import '../services/featured_organization_service.dart';

class FeaturedOrganizationRepository {
  final FeaturedOrganizationService _service = FeaturedOrganizationService();

  Future<List<FeaturedOrganizationModel>> fetchFeaturedOrgs({ int? organizationId, bool orgInfo = false }) {
    return _service.getFeaturedOrgs(organizationId: organizationId, orgInfo: orgInfo);
  }
}