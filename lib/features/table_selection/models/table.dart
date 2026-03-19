enum TableStatus {
  reserved,
  available,
  selected,
}

class RestaurantTable {
  final String id;
  final String name;
  final int floor;
  final TableStatus status;
  final double x;
  final double y;

  const RestaurantTable({
    required this.id,
    required this.name,
    required this.floor,
    required this.status,
    required this.x,
    required this.y,
  });

  RestaurantTable copyWith({
    String? id,
    String? name,
    int? floor,
    TableStatus? status,
    double? x,
    double? y,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      name: name ?? this.name,
      floor: floor ?? this.floor,
      status: status ?? this.status,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
} 