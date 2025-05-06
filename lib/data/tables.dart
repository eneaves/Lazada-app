// lib/data/tables.dart

import 'package:drift/drift.dart';

/// Roles permitidos en la competencia.
enum Role { head, heel }

/// Conversor entre `Role` y `String` para Drift.
class RoleConverter extends TypeConverter<Role, String> {
  const RoleConverter();

  @override
  Role fromSql(String fromDb) {
    return Role.values.firstWhere((e) => e.name == fromDb);
  }

  @override
  String toSql(Role value) {
    return value.name;
  }
}

/// Tabla de participantes.
class Participants extends Table {
  IntColumn    get id        => integer().autoIncrement()();
  TextColumn   get firstName => text().withLength(min: 1, max: 50)();
  TextColumn   get lastName  => text().withLength(min: 1, max: 50)();
  TextColumn   get email     => text().nullable()();
  TextColumn   get role      => text().map(const RoleConverter())();
}

/// Tabla de rondas.
class Rounds extends Table {
  IntColumn      get id        => integer().autoIncrement()();
  IntColumn      get number    => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tabla de emparejamientos por ronda.
class Pairings extends Table {
  IntColumn get id                => integer().autoIncrement()();
  IntColumn get roundId           => integer().customConstraint('REFERENCES rounds(id)')();
  IntColumn get participantHeadId => integer().customConstraint('REFERENCES participants(id)')();
  IntColumn get participantHeelId => integer().customConstraint('REFERENCES participants(id)')();
  IntColumn get timeSeconds       => integer().withDefault(const Constant(0))();
}