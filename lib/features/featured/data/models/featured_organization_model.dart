import 'package:karaburun/features/organization/data/models/organization_model.dart';

class FeaturedOrganizationModel {
  final int id;
  final int organizationId;
  final bool active;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final OrganizationModel organization;

  FeaturedOrganizationModel({
    required this.id,
    required this.organizationId,
    required this.active,
    required this.createdAt,
    this.updatedAt,
    required this.organization,
  });

  factory FeaturedOrganizationModel.fromJson(Map<String, dynamic> json) {
    return FeaturedOrganizationModel(
      id: json['id'],
      organizationId: json['organization_id'],
      active: json['active'] == 1 || json['active'] == true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      organization: OrganizationModel.fromJson(json['organization']) 
    );
  }
}