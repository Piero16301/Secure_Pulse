enum ItemStatus { pending, resolved }

class SecurityItem {
  final String id;
  final String title;
  final String description;
  final ItemStatus status;
  final String severity;

  SecurityItem({
    required this.id,
    required this.title,
    required this.description,
    this.status = ItemStatus.pending,
    this.severity = 'Normal',
  });

  SecurityItem copyWith({
    String? title,
    String? description,
    ItemStatus? status,
    String? severity,
  }) {
    return SecurityItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      severity: severity ?? this.severity,
    );
  }
}
