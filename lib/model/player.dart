const String tablePlayers = 'players';

class PlayerFields {
  static final List<String> values = [
    /// Add all fields
    id, isParticipant, classification, name, time
  ];

  static const String id = '_id';
  static const String isParticipant = 'isParticipant';
  static const String classification = 'classification';
  static const String name = 'name';
  static const String time = 'time';
}

class Player {
  final int? id;
  final bool isParticipant;
  final int classification;
  final String name;
  final DateTime createdTime;

  const Player({
    this.id,
    required this.isParticipant,
    required this.classification,
    required this.name,
    required this.createdTime,
  });

  Player copy({
    int? id,
    bool? isParticipant,
    int? classification,
    String? name,
    DateTime? createdTime,
  }) =>
      Player(
        id: id ?? this.id,
        isParticipant: isParticipant ?? this.isParticipant,
        classification: classification ?? this.classification,
        name: name ?? this.name,
        createdTime: createdTime ?? this.createdTime,
      );

  static Player fromJson(Map<String, Object?> json) => Player(
    id: json[PlayerFields.id] as int?,
    isParticipant: json[PlayerFields.isParticipant] == 1,
    classification: json[PlayerFields.classification] as int,
    name: json[PlayerFields.name] as String,
    createdTime: DateTime.parse(json[PlayerFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    PlayerFields.id: id,
    PlayerFields.name: name,
    PlayerFields.isParticipant: isParticipant ? 1 : 0,
    PlayerFields.classification: classification,
    PlayerFields.time: createdTime.toIso8601String(),
  };
}
