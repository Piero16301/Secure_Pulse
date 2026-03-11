import '../../domain/entities/security_item.dart';

extension SecurityItemToMap on SecurityItem {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'severity': severity,
    };
  }
}

extension MapToSecurityItem on Map<String, dynamic> {
  SecurityItem toEntity() {
    return SecurityItem(
      id: this['id'] as String? ?? '',
      title: this['title'] as String? ?? '',
      description: this['description'] as String? ?? '',
      status: ItemStatus.values.firstWhere(
        (e) => e.name == this['status'],
        orElse: () => ItemStatus.pending,
      ),
      severity: this['severity'] as String? ?? '',
    );
  }
}
