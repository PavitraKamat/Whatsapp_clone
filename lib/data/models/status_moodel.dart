class Status {
  int? id;
  String type;
  String? textContent;
  String? color;
  String? imageContentPath;
  String timestamp;

  Status({
    this.id,
    required this.type,
    this.textContent,
    this.color,
    this.imageContentPath,
    required this.timestamp,
  });

  // Convert Status object to Map (for SQLite storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'textContent': textContent,
      'color': color,
      'imageContentPath': imageContentPath,
      'timestamp': timestamp,
    };
  }

  // Convert Map to Status object (for retrieval)
  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'],
      type: map['type'],
      textContent: map['textContent'],
      color: map['color'],
      imageContentPath: map['imageContentPath'],
      timestamp: map['timestamp'],
    );
  }
}
