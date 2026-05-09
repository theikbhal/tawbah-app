class AppUser {
  final int? id;
  final String name;
  final String role; // Wife, Son, Daughter, etc.
  final DateTime startDate;

  AppUser({
    this.id,
    required this.name,
    required this.role,
    required this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate: DateTime.parse(map['startDate']),
    );
  }
}

class ZikirLog {
  final int? id;
  final int userId;
  final DateTime date;
  final int count;

  ZikirLog({
    this.id,
    required this.userId,
    required this.date,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'count': count,
    };
  }

  factory ZikirLog.fromMap(Map<String, dynamic> map) {
    return ZikirLog(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      count: map['count'],
    );
  }
}

class DailyNote {
  final int? id;
  final int userId;
  final DateTime date;
  final String content;

  DailyNote({
    this.id,
    required this.userId,
    required this.date,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String().split('T')[0],
      'content': content,
    };
  }

  factory DailyNote.fromMap(Map<String, dynamic> map) {
    return DailyNote(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      content: map['content'],
    );
  }
}
