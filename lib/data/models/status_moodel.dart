import 'dart:typed_data';

class Status {
  int? id;
  String type;
  String? textContent;
  String? color;
  Uint8List? imageContent;
  String timestamp;

  Status({
    this.id,
    required this.type,
    this.textContent,
    this.color,
    this.imageContent,
    required this.timestamp,
  });

  // Convert Status object to Map (for SQLite storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'textContent': textContent,
      'color': color,
      'imageContent': imageContent,
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
      imageContent: map['imageContent'],
      timestamp: map['timestamp'],
    );
  }
}
