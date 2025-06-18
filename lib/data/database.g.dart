// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ParticipantsTable extends Participants
    with TableInfo<$ParticipantsTable, Participant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticipantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Role, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Role>($ParticipantsTable.$converterrole);
  @override
  List<GeneratedColumn> get $columns => [id, firstName, lastName, email, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'participants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Participant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Participant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Participant(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      firstName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}first_name'],
          )!,
      lastName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_name'],
          )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      role: $ParticipantsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
    );
  }

  @override
  $ParticipantsTable createAlias(String alias) {
    return $ParticipantsTable(attachedDatabase, alias);
  }

  static TypeConverter<Role, String> $converterrole = const RoleConverter();
}

class Participant extends DataClass implements Insertable<Participant> {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final Role role;
  const Participant({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    {
      map['role'] = Variable<String>(
        $ParticipantsTable.$converterrole.toSql(role),
      );
    }
    return map;
  }

  ParticipantsCompanion toCompanion(bool nullToAbsent) {
    return ParticipantsCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      role: Value(role),
    );
  }

  factory Participant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Participant(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      role: serializer.fromJson<Role>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'role': serializer.toJson<Role>(role),
    };
  }

  Participant copyWith({
    int? id,
    String? firstName,
    String? lastName,
    Value<String?> email = const Value.absent(),
    Role? role,
  }) => Participant(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email.present ? email.value : this.email,
    role: role ?? this.role,
  );
  Participant copyWithCompanion(ParticipantsCompanion data) {
    return Participant(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Participant(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, firstName, lastName, email, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Participant &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.role == this.role);
}

class ParticipantsCompanion extends UpdateCompanion<Participant> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<Role> role;
  const ParticipantsCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
  });
  ParticipantsCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    required Role role,
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       role = Value(role);
  static Insertable<Participant> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
    });
  }

  ParticipantsCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? email,
    Value<Role>? role,
  }) {
    return ParticipantsCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $ParticipantsTable.$converterrole.toSql(role.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantsCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

class $RoundsTable extends Rounds with TableInfo<$RoundsTable, Round> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, number, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Round> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Round map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Round(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      number:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}number'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $RoundsTable createAlias(String alias) {
    return $RoundsTable(attachedDatabase, alias);
  }
}

class Round extends DataClass implements Insertable<Round> {
  final int id;
  final int number;
  final DateTime createdAt;
  const Round({
    required this.id,
    required this.number,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoundsCompanion toCompanion(bool nullToAbsent) {
    return RoundsCompanion(
      id: Value(id),
      number: Value(number),
      createdAt: Value(createdAt),
    );
  }

  factory Round.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Round(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Round copyWith({int? id, int? number, DateTime? createdAt}) => Round(
    id: id ?? this.id,
    number: number ?? this.number,
    createdAt: createdAt ?? this.createdAt,
  );
  Round copyWithCompanion(RoundsCompanion data) {
    return Round(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Round(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Round &&
          other.id == this.id &&
          other.number == this.number &&
          other.createdAt == this.createdAt);
}

class RoundsCompanion extends UpdateCompanion<Round> {
  final Value<int> id;
  final Value<int> number;
  final Value<DateTime> createdAt;
  const RoundsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RoundsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    this.createdAt = const Value.absent(),
  }) : number = Value(number);
  static Insertable<Round> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RoundsCompanion copyWith({
    Value<int>? id,
    Value<int>? number,
    Value<DateTime>? createdAt,
  }) {
    return RoundsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PairingsTable extends Pairings with TableInfo<$PairingsTable, Pairing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PairingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roundIdMeta = const VerificationMeta(
    'roundId',
  );
  @override
  late final GeneratedColumn<int> roundId = GeneratedColumn<int>(
    'round_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rounds (id)',
    ),
  );
  static const VerificationMeta _participantHeadIdMeta = const VerificationMeta(
    'participantHeadId',
  );
  @override
  late final GeneratedColumn<int> participantHeadId = GeneratedColumn<int>(
    'participant_head_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES participants (id)',
    ),
  );
  static const VerificationMeta _participantHeelIdMeta = const VerificationMeta(
    'participantHeelId',
  );
  @override
  late final GeneratedColumn<int> participantHeelId = GeneratedColumn<int>(
    'participant_heel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES participants (id)',
    ),
  );
  static const VerificationMeta _timeSecondsMeta = const VerificationMeta(
    'timeSeconds',
  );
  @override
  late final GeneratedColumn<int> timeSeconds = GeneratedColumn<int>(
    'time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _shotNumberMeta = const VerificationMeta(
    'shotNumber',
  );
  @override
  late final GeneratedColumn<int> shotNumber = GeneratedColumn<int>(
    'shot_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEliminatedMeta = const VerificationMeta(
    'isEliminated',
  );
  @override
  late final GeneratedColumn<bool> isEliminated = GeneratedColumn<bool>(
    'is_eliminated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_eliminated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _eliminatedInRoundIdMeta =
      const VerificationMeta('eliminatedInRoundId');
  @override
  late final GeneratedColumn<int> eliminatedInRoundId = GeneratedColumn<int>(
    'eliminated_in_round_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roundId,
    participantHeadId,
    participantHeelId,
    timeSeconds,
    shotNumber,
    isEliminated,
    eliminatedInRoundId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pairings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pairing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('round_id')) {
      context.handle(
        _roundIdMeta,
        roundId.isAcceptableOrUnknown(data['round_id']!, _roundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roundIdMeta);
    }
    if (data.containsKey('participant_head_id')) {
      context.handle(
        _participantHeadIdMeta,
        participantHeadId.isAcceptableOrUnknown(
          data['participant_head_id']!,
          _participantHeadIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participantHeadIdMeta);
    }
    if (data.containsKey('participant_heel_id')) {
      context.handle(
        _participantHeelIdMeta,
        participantHeelId.isAcceptableOrUnknown(
          data['participant_heel_id']!,
          _participantHeelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participantHeelIdMeta);
    }
    if (data.containsKey('time_seconds')) {
      context.handle(
        _timeSecondsMeta,
        timeSeconds.isAcceptableOrUnknown(
          data['time_seconds']!,
          _timeSecondsMeta,
        ),
      );
    }
    if (data.containsKey('shot_number')) {
      context.handle(
        _shotNumberMeta,
        shotNumber.isAcceptableOrUnknown(data['shot_number']!, _shotNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_shotNumberMeta);
    }
    if (data.containsKey('is_eliminated')) {
      context.handle(
        _isEliminatedMeta,
        isEliminated.isAcceptableOrUnknown(
          data['is_eliminated']!,
          _isEliminatedMeta,
        ),
      );
    }
    if (data.containsKey('eliminated_in_round_id')) {
      context.handle(
        _eliminatedInRoundIdMeta,
        eliminatedInRoundId.isAcceptableOrUnknown(
          data['eliminated_in_round_id']!,
          _eliminatedInRoundIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pairing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pairing(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      roundId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}round_id'],
          )!,
      participantHeadId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}participant_head_id'],
          )!,
      participantHeelId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}participant_heel_id'],
          )!,
      timeSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}time_seconds'],
          )!,
      shotNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}shot_number'],
          )!,
      isEliminated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_eliminated'],
          )!,
      eliminatedInRoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eliminated_in_round_id'],
      ),
    );
  }

  @override
  $PairingsTable createAlias(String alias) {
    return $PairingsTable(attachedDatabase, alias);
  }
}

class Pairing extends DataClass implements Insertable<Pairing> {
  final int id;
  final int roundId;
  final int participantHeadId;
  final int participantHeelId;
  final int timeSeconds;
  final int shotNumber;
  final bool isEliminated;
  final int? eliminatedInRoundId;
  const Pairing({
    required this.id,
    required this.roundId,
    required this.participantHeadId,
    required this.participantHeelId,
    required this.timeSeconds,
    required this.shotNumber,
    required this.isEliminated,
    this.eliminatedInRoundId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['round_id'] = Variable<int>(roundId);
    map['participant_head_id'] = Variable<int>(participantHeadId);
    map['participant_heel_id'] = Variable<int>(participantHeelId);
    map['time_seconds'] = Variable<int>(timeSeconds);
    map['shot_number'] = Variable<int>(shotNumber);
    map['is_eliminated'] = Variable<bool>(isEliminated);
    if (!nullToAbsent || eliminatedInRoundId != null) {
      map['eliminated_in_round_id'] = Variable<int>(eliminatedInRoundId);
    }
    return map;
  }

  PairingsCompanion toCompanion(bool nullToAbsent) {
    return PairingsCompanion(
      id: Value(id),
      roundId: Value(roundId),
      participantHeadId: Value(participantHeadId),
      participantHeelId: Value(participantHeelId),
      timeSeconds: Value(timeSeconds),
      shotNumber: Value(shotNumber),
      isEliminated: Value(isEliminated),
      eliminatedInRoundId:
          eliminatedInRoundId == null && nullToAbsent
              ? const Value.absent()
              : Value(eliminatedInRoundId),
    );
  }

  factory Pairing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pairing(
      id: serializer.fromJson<int>(json['id']),
      roundId: serializer.fromJson<int>(json['roundId']),
      participantHeadId: serializer.fromJson<int>(json['participantHeadId']),
      participantHeelId: serializer.fromJson<int>(json['participantHeelId']),
      timeSeconds: serializer.fromJson<int>(json['timeSeconds']),
      shotNumber: serializer.fromJson<int>(json['shotNumber']),
      isEliminated: serializer.fromJson<bool>(json['isEliminated']),
      eliminatedInRoundId: serializer.fromJson<int?>(
        json['eliminatedInRoundId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roundId': serializer.toJson<int>(roundId),
      'participantHeadId': serializer.toJson<int>(participantHeadId),
      'participantHeelId': serializer.toJson<int>(participantHeelId),
      'timeSeconds': serializer.toJson<int>(timeSeconds),
      'shotNumber': serializer.toJson<int>(shotNumber),
      'isEliminated': serializer.toJson<bool>(isEliminated),
      'eliminatedInRoundId': serializer.toJson<int?>(eliminatedInRoundId),
    };
  }

  Pairing copyWith({
    int? id,
    int? roundId,
    int? participantHeadId,
    int? participantHeelId,
    int? timeSeconds,
    int? shotNumber,
    bool? isEliminated,
    Value<int?> eliminatedInRoundId = const Value.absent(),
  }) => Pairing(
    id: id ?? this.id,
    roundId: roundId ?? this.roundId,
    participantHeadId: participantHeadId ?? this.participantHeadId,
    participantHeelId: participantHeelId ?? this.participantHeelId,
    timeSeconds: timeSeconds ?? this.timeSeconds,
    shotNumber: shotNumber ?? this.shotNumber,
    isEliminated: isEliminated ?? this.isEliminated,
    eliminatedInRoundId:
        eliminatedInRoundId.present
            ? eliminatedInRoundId.value
            : this.eliminatedInRoundId,
  );
  Pairing copyWithCompanion(PairingsCompanion data) {
    return Pairing(
      id: data.id.present ? data.id.value : this.id,
      roundId: data.roundId.present ? data.roundId.value : this.roundId,
      participantHeadId:
          data.participantHeadId.present
              ? data.participantHeadId.value
              : this.participantHeadId,
      participantHeelId:
          data.participantHeelId.present
              ? data.participantHeelId.value
              : this.participantHeelId,
      timeSeconds:
          data.timeSeconds.present ? data.timeSeconds.value : this.timeSeconds,
      shotNumber:
          data.shotNumber.present ? data.shotNumber.value : this.shotNumber,
      isEliminated:
          data.isEliminated.present
              ? data.isEliminated.value
              : this.isEliminated,
      eliminatedInRoundId:
          data.eliminatedInRoundId.present
              ? data.eliminatedInRoundId.value
              : this.eliminatedInRoundId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pairing(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('participantHeadId: $participantHeadId, ')
          ..write('participantHeelId: $participantHeelId, ')
          ..write('timeSeconds: $timeSeconds, ')
          ..write('shotNumber: $shotNumber, ')
          ..write('isEliminated: $isEliminated, ')
          ..write('eliminatedInRoundId: $eliminatedInRoundId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roundId,
    participantHeadId,
    participantHeelId,
    timeSeconds,
    shotNumber,
    isEliminated,
    eliminatedInRoundId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pairing &&
          other.id == this.id &&
          other.roundId == this.roundId &&
          other.participantHeadId == this.participantHeadId &&
          other.participantHeelId == this.participantHeelId &&
          other.timeSeconds == this.timeSeconds &&
          other.shotNumber == this.shotNumber &&
          other.isEliminated == this.isEliminated &&
          other.eliminatedInRoundId == this.eliminatedInRoundId);
}

class PairingsCompanion extends UpdateCompanion<Pairing> {
  final Value<int> id;
  final Value<int> roundId;
  final Value<int> participantHeadId;
  final Value<int> participantHeelId;
  final Value<int> timeSeconds;
  final Value<int> shotNumber;
  final Value<bool> isEliminated;
  final Value<int?> eliminatedInRoundId;
  const PairingsCompanion({
    this.id = const Value.absent(),
    this.roundId = const Value.absent(),
    this.participantHeadId = const Value.absent(),
    this.participantHeelId = const Value.absent(),
    this.timeSeconds = const Value.absent(),
    this.shotNumber = const Value.absent(),
    this.isEliminated = const Value.absent(),
    this.eliminatedInRoundId = const Value.absent(),
  });
  PairingsCompanion.insert({
    this.id = const Value.absent(),
    required int roundId,
    required int participantHeadId,
    required int participantHeelId,
    this.timeSeconds = const Value.absent(),
    required int shotNumber,
    this.isEliminated = const Value.absent(),
    this.eliminatedInRoundId = const Value.absent(),
  }) : roundId = Value(roundId),
       participantHeadId = Value(participantHeadId),
       participantHeelId = Value(participantHeelId),
       shotNumber = Value(shotNumber);
  static Insertable<Pairing> custom({
    Expression<int>? id,
    Expression<int>? roundId,
    Expression<int>? participantHeadId,
    Expression<int>? participantHeelId,
    Expression<int>? timeSeconds,
    Expression<int>? shotNumber,
    Expression<bool>? isEliminated,
    Expression<int>? eliminatedInRoundId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roundId != null) 'round_id': roundId,
      if (participantHeadId != null) 'participant_head_id': participantHeadId,
      if (participantHeelId != null) 'participant_heel_id': participantHeelId,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (shotNumber != null) 'shot_number': shotNumber,
      if (isEliminated != null) 'is_eliminated': isEliminated,
      if (eliminatedInRoundId != null)
        'eliminated_in_round_id': eliminatedInRoundId,
    });
  }

  PairingsCompanion copyWith({
    Value<int>? id,
    Value<int>? roundId,
    Value<int>? participantHeadId,
    Value<int>? participantHeelId,
    Value<int>? timeSeconds,
    Value<int>? shotNumber,
    Value<bool>? isEliminated,
    Value<int?>? eliminatedInRoundId,
  }) {
    return PairingsCompanion(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      participantHeadId: participantHeadId ?? this.participantHeadId,
      participantHeelId: participantHeelId ?? this.participantHeelId,
      timeSeconds: timeSeconds ?? this.timeSeconds,
      shotNumber: shotNumber ?? this.shotNumber,
      isEliminated: isEliminated ?? this.isEliminated,
      eliminatedInRoundId: eliminatedInRoundId ?? this.eliminatedInRoundId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roundId.present) {
      map['round_id'] = Variable<int>(roundId.value);
    }
    if (participantHeadId.present) {
      map['participant_head_id'] = Variable<int>(participantHeadId.value);
    }
    if (participantHeelId.present) {
      map['participant_heel_id'] = Variable<int>(participantHeelId.value);
    }
    if (timeSeconds.present) {
      map['time_seconds'] = Variable<int>(timeSeconds.value);
    }
    if (shotNumber.present) {
      map['shot_number'] = Variable<int>(shotNumber.value);
    }
    if (isEliminated.present) {
      map['is_eliminated'] = Variable<bool>(isEliminated.value);
    }
    if (eliminatedInRoundId.present) {
      map['eliminated_in_round_id'] = Variable<int>(eliminatedInRoundId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PairingsCompanion(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('participantHeadId: $participantHeadId, ')
          ..write('participantHeelId: $participantHeelId, ')
          ..write('timeSeconds: $timeSeconds, ')
          ..write('shotNumber: $shotNumber, ')
          ..write('isEliminated: $isEliminated, ')
          ..write('eliminatedInRoundId: $eliminatedInRoundId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ParticipantsTable participants = $ParticipantsTable(this);
  late final $RoundsTable rounds = $RoundsTable(this);
  late final $PairingsTable pairings = $PairingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    participants,
    rounds,
    pairings,
  ];
}

typedef $$ParticipantsTableCreateCompanionBuilder =
    ParticipantsCompanion Function({
      Value<int> id,
      required String firstName,
      required String lastName,
      Value<String?> email,
      required Role role,
    });
typedef $$ParticipantsTableUpdateCompanionBuilder =
    ParticipantsCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> email,
      Value<Role> role,
    });

final class $$ParticipantsTableReferences
    extends BaseReferences<_$AppDatabase, $ParticipantsTable, Participant> {
  $$ParticipantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PairingsTable, List<Pairing>> _headRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pairings,
    aliasName: $_aliasNameGenerator(
      db.participants.id,
      db.pairings.participantHeadId,
    ),
  );

  $$PairingsTableProcessedTableManager get headRefs {
    final manager = $$PairingsTableTableManager(
      $_db,
      $_db.pairings,
    ).filter((f) => f.participantHeadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_headRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PairingsTable, List<Pairing>> _heelRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pairings,
    aliasName: $_aliasNameGenerator(
      db.participants.id,
      db.pairings.participantHeelId,
    ),
  );

  $$PairingsTableProcessedTableManager get heelRefs {
    final manager = $$PairingsTableTableManager(
      $_db,
      $_db.pairings,
    ).filter((f) => f.participantHeelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_heelRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ParticipantsTableFilterComposer
    extends Composer<_$AppDatabase, $ParticipantsTable> {
  $$ParticipantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Role, Role, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> headRefs(
    Expression<bool> Function($$PairingsTableFilterComposer f) f,
  ) {
    final $$PairingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairings,
      getReferencedColumn: (t) => t.participantHeadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairingsTableFilterComposer(
            $db: $db,
            $table: $db.pairings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> heelRefs(
    Expression<bool> Function($$PairingsTableFilterComposer f) f,
  ) {
    final $$PairingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairings,
      getReferencedColumn: (t) => t.participantHeelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairingsTableFilterComposer(
            $db: $db,
            $table: $db.pairings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParticipantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParticipantsTable> {
  $$ParticipantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParticipantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParticipantsTable> {
  $$ParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Role, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  Expression<T> headRefs<T extends Object>(
    Expression<T> Function($$PairingsTableAnnotationComposer a) f,
  ) {
    final $$PairingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairings,
      getReferencedColumn: (t) => t.participantHeadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairingsTableAnnotationComposer(
            $db: $db,
            $table: $db.pairings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> heelRefs<T extends Object>(
    Expression<T> Function($$PairingsTableAnnotationComposer a) f,
  ) {
    final $$PairingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairings,
      getReferencedColumn: (t) => t.participantHeelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairingsTableAnnotationComposer(
            $db: $db,
            $table: $db.pairings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParticipantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParticipantsTable,
          Participant,
          $$ParticipantsTableFilterComposer,
          $$ParticipantsTableOrderingComposer,
          $$ParticipantsTableAnnotationComposer,
          $$ParticipantsTableCreateCompanionBuilder,
          $$ParticipantsTableUpdateCompanionBuilder,
          (Participant, $$ParticipantsTableReferences),
          Participant,
          PrefetchHooks Function({bool headRefs, bool heelRefs})
        > {
  $$ParticipantsTableTableManager(_$AppDatabase db, $ParticipantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ParticipantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ParticipantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ParticipantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<Role> role = const Value.absent(),
              }) => ParticipantsCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                role: role,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String lastName,
                Value<String?> email = const Value.absent(),
                required Role role,
              }) => ParticipantsCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                role: role,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ParticipantsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({headRefs = false, heelRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (headRefs) db.pairings,
                if (heelRefs) db.pairings,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (headRefs)
                    await $_getPrefetchedData<
                      Participant,
                      $ParticipantsTable,
                      Pairing
                    >(
                      currentTable: table,
                      referencedTable: $$ParticipantsTableReferences
                          ._headRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ParticipantsTableReferences(
                                db,
                                table,
                                p0,
                              ).headRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.participantHeadId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (heelRefs)
                    await $_getPrefetchedData<
                      Participant,
                      $ParticipantsTable,
                      Pairing
                    >(
                      currentTable: table,
                      referencedTable: $$ParticipantsTableReferences
                          ._heelRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ParticipantsTableReferences(
                                db,
                                table,
                                p0,
                              ).heelRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.participantHeelId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ParticipantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParticipantsTable,
      Participant,
      $$ParticipantsTableFilterComposer,
      $$ParticipantsTableOrderingComposer,
      $$ParticipantsTableAnnotationComposer,
      $$ParticipantsTableCreateCompanionBuilder,
      $$ParticipantsTableUpdateCompanionBuilder,
      (Participant, $$ParticipantsTableReferences),
      Participant,
      PrefetchHooks Function({bool headRefs, bool heelRefs})
    >;
typedef $$RoundsTableCreateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      required int number,
      Value<DateTime> createdAt,
    });
typedef $$RoundsTableUpdateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      Value<int> number,
      Value<DateTime> createdAt,
    });

final class $$RoundsTableReferences
    extends BaseReferences<_$AppDatabase, $RoundsTable, Round> {
  $$RoundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PairingsTable, List<Pairing>> _pairingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pairings,
    aliasName: $_aliasNameGenerator(db.rounds.id, db.pairings.roundId),
  );

  $$PairingsTableProcessedTableManager get pairingsRefs {
    final manager = $$PairingsTableTableManager(
      $_db,
      $_db.pairings,
    ).filter((f) => f.roundId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pairingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoundsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pairingsRefs(
    Expression<bool> Function($$PairingsTableFilterComposer f) f,
  ) {
    final $$PairingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairings,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairingsTableFilterComposer(
            $db: $db,
            $table: $db.pairings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> pairingsRefs<T extends Object>(
    Expression<T> Function($$PairingsTableAnnotationComposer a) f,
  ) {
    final $$PairingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairings,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairingsTableAnnotationComposer(
            $db: $db,
            $table: $db.pairings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundsTable,
          Round,
          $$RoundsTableFilterComposer,
          $$RoundsTableOrderingComposer,
          $$RoundsTableAnnotationComposer,
          $$RoundsTableCreateCompanionBuilder,
          $$RoundsTableUpdateCompanionBuilder,
          (Round, $$RoundsTableReferences),
          Round,
          PrefetchHooks Function({bool pairingsRefs})
        > {
  $$RoundsTableTableManager(_$AppDatabase db, $RoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) =>
                  RoundsCompanion(id: id, number: number, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int number,
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoundsCompanion.insert(
                id: id,
                number: number,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RoundsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({pairingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pairingsRefs) db.pairings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pairingsRefs)
                    await $_getPrefetchedData<Round, $RoundsTable, Pairing>(
                      currentTable: table,
                      referencedTable: $$RoundsTableReferences
                          ._pairingsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$RoundsTableReferences(
                                db,
                                table,
                                p0,
                              ).pairingsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.roundId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundsTable,
      Round,
      $$RoundsTableFilterComposer,
      $$RoundsTableOrderingComposer,
      $$RoundsTableAnnotationComposer,
      $$RoundsTableCreateCompanionBuilder,
      $$RoundsTableUpdateCompanionBuilder,
      (Round, $$RoundsTableReferences),
      Round,
      PrefetchHooks Function({bool pairingsRefs})
    >;
typedef $$PairingsTableCreateCompanionBuilder =
    PairingsCompanion Function({
      Value<int> id,
      required int roundId,
      required int participantHeadId,
      required int participantHeelId,
      Value<int> timeSeconds,
      required int shotNumber,
      Value<bool> isEliminated,
      Value<int?> eliminatedInRoundId,
    });
typedef $$PairingsTableUpdateCompanionBuilder =
    PairingsCompanion Function({
      Value<int> id,
      Value<int> roundId,
      Value<int> participantHeadId,
      Value<int> participantHeelId,
      Value<int> timeSeconds,
      Value<int> shotNumber,
      Value<bool> isEliminated,
      Value<int?> eliminatedInRoundId,
    });

final class $$PairingsTableReferences
    extends BaseReferences<_$AppDatabase, $PairingsTable, Pairing> {
  $$PairingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoundsTable _roundIdTable(_$AppDatabase db) => db.rounds.createAlias(
    $_aliasNameGenerator(db.pairings.roundId, db.rounds.id),
  );

  $$RoundsTableProcessedTableManager get roundId {
    final $_column = $_itemColumn<int>('round_id')!;

    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ParticipantsTable _participantHeadIdTable(_$AppDatabase db) =>
      db.participants.createAlias(
        $_aliasNameGenerator(db.pairings.participantHeadId, db.participants.id),
      );

  $$ParticipantsTableProcessedTableManager get participantHeadId {
    final $_column = $_itemColumn<int>('participant_head_id')!;

    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_participantHeadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ParticipantsTable _participantHeelIdTable(_$AppDatabase db) =>
      db.participants.createAlias(
        $_aliasNameGenerator(db.pairings.participantHeelId, db.participants.id),
      );

  $$ParticipantsTableProcessedTableManager get participantHeelId {
    final $_column = $_itemColumn<int>('participant_heel_id')!;

    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_participantHeelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PairingsTableFilterComposer
    extends Composer<_$AppDatabase, $PairingsTable> {
  $$PairingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSeconds => $composableBuilder(
    column: $table.timeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shotNumber => $composableBuilder(
    column: $table.shotNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEliminated => $composableBuilder(
    column: $table.isEliminated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eliminatedInRoundId => $composableBuilder(
    column: $table.eliminatedInRoundId,
    builder: (column) => ColumnFilters(column),
  );

  $$RoundsTableFilterComposer get roundId {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableFilterComposer get participantHeadId {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantHeadId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableFilterComposer get participantHeelId {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantHeelId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PairingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PairingsTable> {
  $$PairingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSeconds => $composableBuilder(
    column: $table.timeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shotNumber => $composableBuilder(
    column: $table.shotNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEliminated => $composableBuilder(
    column: $table.isEliminated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eliminatedInRoundId => $composableBuilder(
    column: $table.eliminatedInRoundId,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoundsTableOrderingComposer get roundId {
    final $$RoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableOrderingComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableOrderingComposer get participantHeadId {
    final $$ParticipantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantHeadId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableOrderingComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableOrderingComposer get participantHeelId {
    final $$ParticipantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantHeelId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableOrderingComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PairingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PairingsTable> {
  $$PairingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timeSeconds => $composableBuilder(
    column: $table.timeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shotNumber => $composableBuilder(
    column: $table.shotNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEliminated => $composableBuilder(
    column: $table.isEliminated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eliminatedInRoundId => $composableBuilder(
    column: $table.eliminatedInRoundId,
    builder: (column) => column,
  );

  $$RoundsTableAnnotationComposer get roundId {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableAnnotationComposer get participantHeadId {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantHeadId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableAnnotationComposer get participantHeelId {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantHeelId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PairingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PairingsTable,
          Pairing,
          $$PairingsTableFilterComposer,
          $$PairingsTableOrderingComposer,
          $$PairingsTableAnnotationComposer,
          $$PairingsTableCreateCompanionBuilder,
          $$PairingsTableUpdateCompanionBuilder,
          (Pairing, $$PairingsTableReferences),
          Pairing,
          PrefetchHooks Function({
            bool roundId,
            bool participantHeadId,
            bool participantHeelId,
          })
        > {
  $$PairingsTableTableManager(_$AppDatabase db, $PairingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PairingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PairingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PairingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roundId = const Value.absent(),
                Value<int> participantHeadId = const Value.absent(),
                Value<int> participantHeelId = const Value.absent(),
                Value<int> timeSeconds = const Value.absent(),
                Value<int> shotNumber = const Value.absent(),
                Value<bool> isEliminated = const Value.absent(),
                Value<int?> eliminatedInRoundId = const Value.absent(),
              }) => PairingsCompanion(
                id: id,
                roundId: roundId,
                participantHeadId: participantHeadId,
                participantHeelId: participantHeelId,
                timeSeconds: timeSeconds,
                shotNumber: shotNumber,
                isEliminated: isEliminated,
                eliminatedInRoundId: eliminatedInRoundId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roundId,
                required int participantHeadId,
                required int participantHeelId,
                Value<int> timeSeconds = const Value.absent(),
                required int shotNumber,
                Value<bool> isEliminated = const Value.absent(),
                Value<int?> eliminatedInRoundId = const Value.absent(),
              }) => PairingsCompanion.insert(
                id: id,
                roundId: roundId,
                participantHeadId: participantHeadId,
                participantHeelId: participantHeelId,
                timeSeconds: timeSeconds,
                shotNumber: shotNumber,
                isEliminated: isEliminated,
                eliminatedInRoundId: eliminatedInRoundId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PairingsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            roundId = false,
            participantHeadId = false,
            participantHeelId = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (roundId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.roundId,
                            referencedTable: $$PairingsTableReferences
                                ._roundIdTable(db),
                            referencedColumn:
                                $$PairingsTableReferences._roundIdTable(db).id,
                          )
                          as T;
                }
                if (participantHeadId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.participantHeadId,
                            referencedTable: $$PairingsTableReferences
                                ._participantHeadIdTable(db),
                            referencedColumn:
                                $$PairingsTableReferences
                                    ._participantHeadIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (participantHeelId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.participantHeelId,
                            referencedTable: $$PairingsTableReferences
                                ._participantHeelIdTable(db),
                            referencedColumn:
                                $$PairingsTableReferences
                                    ._participantHeelIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PairingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PairingsTable,
      Pairing,
      $$PairingsTableFilterComposer,
      $$PairingsTableOrderingComposer,
      $$PairingsTableAnnotationComposer,
      $$PairingsTableCreateCompanionBuilder,
      $$PairingsTableUpdateCompanionBuilder,
      (Pairing, $$PairingsTableReferences),
      Pairing,
      PrefetchHooks Function({
        bool roundId,
        bool participantHeadId,
        bool participantHeelId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ParticipantsTableTableManager get participants =>
      $$ParticipantsTableTableManager(_db, _db.participants);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db, _db.rounds);
  $$PairingsTableTableManager get pairings =>
      $$PairingsTableTableManager(_db, _db.pairings);
}
