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
  TextColumn   get lastName  => text().withLength(min: 0, max: 50)();
  TextColumn   get email     => text().nullable()();
  TextColumn   get role      => text().map(const RoleConverter())();
}

/// Tabla de rondas.
class Rounds extends Table {
  IntColumn      get id        => integer().autoIncrement()();
  IntColumn      get number    => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tabla de emparejamientos por ronda y tiro.
class Pairings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get roundId =>
      integer().references(Rounds, #id)(); 

  @ReferenceName('headRefs')
  IntColumn get participantHeadId =>
      integer().references(Participants, #id)(); 

  @ReferenceName('heelRefs')
  IntColumn get participantHeelId =>
      integer().references(Participants, #id)(); 

  IntColumn get timeSeconds => integer().withDefault(const Constant(0))();
  IntColumn get shotNumber => integer()();

  // Nuevos campos para control de eliminación
  BoolColumn get isEliminated =>
      boolean().withDefault(const Constant(false))();

  IntColumn get eliminatedInRoundId => integer().nullable()();
}
