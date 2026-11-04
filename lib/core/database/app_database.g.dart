// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfileRowsTable extends ProfileRows
    with TableInfo<$ProfileRowsTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experienceLevelMeta = const VerificationMeta(
    'experienceLevel',
  );
  @override
  late final GeneratedColumn<String> experienceLevel = GeneratedColumn<String>(
    'experience_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalsMeta = const VerificationMeta('goals');
  @override
  late final GeneratedColumn<String> goals = GeneratedColumn<String>(
    'goals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prioritiesMeta = const VerificationMeta(
    'priorities',
  );
  @override
  late final GeneratedColumn<String> priorities = GeneratedColumn<String>(
    'priorities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionMinutesMeta = const VerificationMeta(
    'sessionMinutes',
  );
  @override
  late final GeneratedColumn<int> sessionMinutes = GeneratedColumn<int>(
    'session_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trainingTimeMeta = const VerificationMeta(
    'trainingTime',
  );
  @override
  late final GeneratedColumn<String> trainingTime = GeneratedColumn<String>(
    'training_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietPatternMeta = const VerificationMeta(
    'dietPattern',
  );
  @override
  late final GeneratedColumn<String> dietPattern = GeneratedColumn<String>(
    'diet_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietRestrictionsMeta = const VerificationMeta(
    'dietRestrictions',
  );
  @override
  late final GeneratedColumn<String> dietRestrictions = GeneratedColumn<String>(
    'diet_restrictions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepPatternMeta = const VerificationMeta(
    'sleepPattern',
  );
  @override
  late final GeneratedColumn<String> sleepPattern = GeneratedColumn<String>(
    'sleep_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    age,
    heightCm,
    weightKg,
    experienceLevel,
    goals,
    priorities,
    equipment,
    sessionMinutes,
    trainingTime,
    dietPattern,
    dietRestrictions,
    sleepPattern,
    notificationsEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('experience_level')) {
      context.handle(
        _experienceLevelMeta,
        experienceLevel.isAcceptableOrUnknown(
          data['experience_level']!,
          _experienceLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_experienceLevelMeta);
    }
    if (data.containsKey('goals')) {
      context.handle(
        _goalsMeta,
        goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta),
      );
    } else if (isInserting) {
      context.missing(_goalsMeta);
    }
    if (data.containsKey('priorities')) {
      context.handle(
        _prioritiesMeta,
        priorities.isAcceptableOrUnknown(data['priorities']!, _prioritiesMeta),
      );
    } else if (isInserting) {
      context.missing(_prioritiesMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('session_minutes')) {
      context.handle(
        _sessionMinutesMeta,
        sessionMinutes.isAcceptableOrUnknown(
          data['session_minutes']!,
          _sessionMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionMinutesMeta);
    }
    if (data.containsKey('training_time')) {
      context.handle(
        _trainingTimeMeta,
        trainingTime.isAcceptableOrUnknown(
          data['training_time']!,
          _trainingTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trainingTimeMeta);
    }
    if (data.containsKey('diet_pattern')) {
      context.handle(
        _dietPatternMeta,
        dietPattern.isAcceptableOrUnknown(
          data['diet_pattern']!,
          _dietPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dietPatternMeta);
    }
    if (data.containsKey('diet_restrictions')) {
      context.handle(
        _dietRestrictionsMeta,
        dietRestrictions.isAcceptableOrUnknown(
          data['diet_restrictions']!,
          _dietRestrictionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dietRestrictionsMeta);
    }
    if (data.containsKey('sleep_pattern')) {
      context.handle(
        _sleepPatternMeta,
        sleepPattern.isAcceptableOrUnknown(
          data['sleep_pattern']!,
          _sleepPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sleepPatternMeta);
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationsEnabledMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      experienceLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience_level'],
      )!,
      goals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goals'],
      )!,
      priorities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priorities'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      sessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_minutes'],
      )!,
      trainingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}training_time'],
      )!,
      dietPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_pattern'],
      )!,
      dietRestrictions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_restrictions'],
      )!,
      sleepPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sleep_pattern'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfileRowsTable createAlias(String alias) {
    return $ProfileRowsTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final int age;
  final int heightCm;
  final double weightKg;
  final String experienceLevel;
  final String goals;
  final String priorities;
  final String equipment;
  final int sessionMinutes;
  final String trainingTime;
  final String dietPattern;
  final String dietRestrictions;
  final String sleepPattern;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProfileRow({
    required this.id,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.experienceLevel,
    required this.goals,
    required this.priorities,
    required this.equipment,
    required this.sessionMinutes,
    required this.trainingTime,
    required this.dietPattern,
    required this.dietRestrictions,
    required this.sleepPattern,
    required this.notificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['age'] = Variable<int>(age);
    map['height_cm'] = Variable<int>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['experience_level'] = Variable<String>(experienceLevel);
    map['goals'] = Variable<String>(goals);
    map['priorities'] = Variable<String>(priorities);
    map['equipment'] = Variable<String>(equipment);
    map['session_minutes'] = Variable<int>(sessionMinutes);
    map['training_time'] = Variable<String>(trainingTime);
    map['diet_pattern'] = Variable<String>(dietPattern);
    map['diet_restrictions'] = Variable<String>(dietRestrictions);
    map['sleep_pattern'] = Variable<String>(sleepPattern);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfileRowsCompanion toCompanion(bool nullToAbsent) {
    return ProfileRowsCompanion(
      id: Value(id),
      age: Value(age),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      experienceLevel: Value(experienceLevel),
      goals: Value(goals),
      priorities: Value(priorities),
      equipment: Value(equipment),
      sessionMinutes: Value(sessionMinutes),
      trainingTime: Value(trainingTime),
      dietPattern: Value(dietPattern),
      dietRestrictions: Value(dietRestrictions),
      sleepPattern: Value(sleepPattern),
      notificationsEnabled: Value(notificationsEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      age: serializer.fromJson<int>(json['age']),
      heightCm: serializer.fromJson<int>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      experienceLevel: serializer.fromJson<String>(json['experienceLevel']),
      goals: serializer.fromJson<String>(json['goals']),
      priorities: serializer.fromJson<String>(json['priorities']),
      equipment: serializer.fromJson<String>(json['equipment']),
      sessionMinutes: serializer.fromJson<int>(json['sessionMinutes']),
      trainingTime: serializer.fromJson<String>(json['trainingTime']),
      dietPattern: serializer.fromJson<String>(json['dietPattern']),
      dietRestrictions: serializer.fromJson<String>(json['dietRestrictions']),
      sleepPattern: serializer.fromJson<String>(json['sleepPattern']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'age': serializer.toJson<int>(age),
      'heightCm': serializer.toJson<int>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'experienceLevel': serializer.toJson<String>(experienceLevel),
      'goals': serializer.toJson<String>(goals),
      'priorities': serializer.toJson<String>(priorities),
      'equipment': serializer.toJson<String>(equipment),
      'sessionMinutes': serializer.toJson<int>(sessionMinutes),
      'trainingTime': serializer.toJson<String>(trainingTime),
      'dietPattern': serializer.toJson<String>(dietPattern),
      'dietRestrictions': serializer.toJson<String>(dietRestrictions),
      'sleepPattern': serializer.toJson<String>(sleepPattern),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    int? age,
    int? heightCm,
    double? weightKg,
    String? experienceLevel,
    String? goals,
    String? priorities,
    String? equipment,
    int? sessionMinutes,
    String? trainingTime,
    String? dietPattern,
    String? dietRestrictions,
    String? sleepPattern,
    bool? notificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    goals: goals ?? this.goals,
    priorities: priorities ?? this.priorities,
    equipment: equipment ?? this.equipment,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    trainingTime: trainingTime ?? this.trainingTime,
    dietPattern: dietPattern ?? this.dietPattern,
    dietRestrictions: dietRestrictions ?? this.dietRestrictions,
    sleepPattern: sleepPattern ?? this.sleepPattern,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRow copyWithCompanion(ProfileRowsCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      experienceLevel: data.experienceLevel.present
          ? data.experienceLevel.value
          : this.experienceLevel,
      goals: data.goals.present ? data.goals.value : this.goals,
      priorities: data.priorities.present
          ? data.priorities.value
          : this.priorities,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      sessionMinutes: data.sessionMinutes.present
          ? data.sessionMinutes.value
          : this.sessionMinutes,
      trainingTime: data.trainingTime.present
          ? data.trainingTime.value
          : this.trainingTime,
      dietPattern: data.dietPattern.present
          ? data.dietPattern.value
          : this.dietPattern,
      dietRestrictions: data.dietRestrictions.present
          ? data.dietRestrictions.value
          : this.dietRestrictions,
      sleepPattern: data.sleepPattern.present
          ? data.sleepPattern.value
          : this.sleepPattern,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('experienceLevel: $experienceLevel, ')
          ..write('goals: $goals, ')
          ..write('priorities: $priorities, ')
          ..write('equipment: $equipment, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('trainingTime: $trainingTime, ')
          ..write('dietPattern: $dietPattern, ')
          ..write('dietRestrictions: $dietRestrictions, ')
          ..write('sleepPattern: $sleepPattern, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    age,
    heightCm,
    weightKg,
    experienceLevel,
    goals,
    priorities,
    equipment,
    sessionMinutes,
    trainingTime,
    dietPattern,
    dietRestrictions,
    sleepPattern,
    notificationsEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.experienceLevel == this.experienceLevel &&
          other.goals == this.goals &&
          other.priorities == this.priorities &&
          other.equipment == this.equipment &&
          other.sessionMinutes == this.sessionMinutes &&
          other.trainingTime == this.trainingTime &&
          other.dietPattern == this.dietPattern &&
          other.dietRestrictions == this.dietRestrictions &&
          other.sleepPattern == this.sleepPattern &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProfileRowsCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<int> age;
  final Value<int> heightCm;
  final Value<double> weightKg;
  final Value<String> experienceLevel;
  final Value<String> goals;
  final Value<String> priorities;
  final Value<String> equipment;
  final Value<int> sessionMinutes;
  final Value<String> trainingTime;
  final Value<String> dietPattern;
  final Value<String> dietRestrictions;
  final Value<String> sleepPattern;
  final Value<bool> notificationsEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfileRowsCompanion({
    this.id = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.experienceLevel = const Value.absent(),
    this.goals = const Value.absent(),
    this.priorities = const Value.absent(),
    this.equipment = const Value.absent(),
    this.sessionMinutes = const Value.absent(),
    this.trainingTime = const Value.absent(),
    this.dietPattern = const Value.absent(),
    this.dietRestrictions = const Value.absent(),
    this.sleepPattern = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileRowsCompanion.insert({
    required String id,
    required int age,
    required int heightCm,
    required double weightKg,
    required String experienceLevel,
    required String goals,
    required String priorities,
    required String equipment,
    required int sessionMinutes,
    required String trainingTime,
    required String dietPattern,
    required String dietRestrictions,
    required String sleepPattern,
    required bool notificationsEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       age = Value(age),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       experienceLevel = Value(experienceLevel),
       goals = Value(goals),
       priorities = Value(priorities),
       equipment = Value(equipment),
       sessionMinutes = Value(sessionMinutes),
       trainingTime = Value(trainingTime),
       dietPattern = Value(dietPattern),
       dietRestrictions = Value(dietRestrictions),
       sleepPattern = Value(sleepPattern),
       notificationsEnabled = Value(notificationsEnabled),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<int>? age,
    Expression<int>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? experienceLevel,
    Expression<String>? goals,
    Expression<String>? priorities,
    Expression<String>? equipment,
    Expression<int>? sessionMinutes,
    Expression<String>? trainingTime,
    Expression<String>? dietPattern,
    Expression<String>? dietRestrictions,
    Expression<String>? sleepPattern,
    Expression<bool>? notificationsEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (experienceLevel != null) 'experience_level': experienceLevel,
      if (goals != null) 'goals': goals,
      if (priorities != null) 'priorities': priorities,
      if (equipment != null) 'equipment': equipment,
      if (sessionMinutes != null) 'session_minutes': sessionMinutes,
      if (trainingTime != null) 'training_time': trainingTime,
      if (dietPattern != null) 'diet_pattern': dietPattern,
      if (dietRestrictions != null) 'diet_restrictions': dietRestrictions,
      if (sleepPattern != null) 'sleep_pattern': sleepPattern,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileRowsCompanion copyWith({
    Value<String>? id,
    Value<int>? age,
    Value<int>? heightCm,
    Value<double>? weightKg,
    Value<String>? experienceLevel,
    Value<String>? goals,
    Value<String>? priorities,
    Value<String>? equipment,
    Value<int>? sessionMinutes,
    Value<String>? trainingTime,
    Value<String>? dietPattern,
    Value<String>? dietRestrictions,
    Value<String>? sleepPattern,
    Value<bool>? notificationsEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfileRowsCompanion(
      id: id ?? this.id,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      goals: goals ?? this.goals,
      priorities: priorities ?? this.priorities,
      equipment: equipment ?? this.equipment,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      trainingTime: trainingTime ?? this.trainingTime,
      dietPattern: dietPattern ?? this.dietPattern,
      dietRestrictions: dietRestrictions ?? this.dietRestrictions,
      sleepPattern: sleepPattern ?? this.sleepPattern,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (experienceLevel.present) {
      map['experience_level'] = Variable<String>(experienceLevel.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (priorities.present) {
      map['priorities'] = Variable<String>(priorities.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (sessionMinutes.present) {
      map['session_minutes'] = Variable<int>(sessionMinutes.value);
    }
    if (trainingTime.present) {
      map['training_time'] = Variable<String>(trainingTime.value);
    }
    if (dietPattern.present) {
      map['diet_pattern'] = Variable<String>(dietPattern.value);
    }
    if (dietRestrictions.present) {
      map['diet_restrictions'] = Variable<String>(dietRestrictions.value);
    }
    if (sleepPattern.present) {
      map['sleep_pattern'] = Variable<String>(sleepPattern.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRowsCompanion(')
          ..write('id: $id, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('experienceLevel: $experienceLevel, ')
          ..write('goals: $goals, ')
          ..write('priorities: $priorities, ')
          ..write('equipment: $equipment, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('trainingTime: $trainingTime, ')
          ..write('dietPattern: $dietPattern, ')
          ..write('dietRestrictions: $dietRestrictions, ')
          ..write('sleepPattern: $sleepPattern, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssessmentRowsTable extends AssessmentRows
    with TableInfo<$AssessmentRowsTable, AssessmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profile_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pushUpsMeta = const VerificationMeta(
    'pushUps',
  );
  @override
  late final GeneratedColumn<int> pushUps = GeneratedColumn<int>(
    'push_ups',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kneePushUpsMeta = const VerificationMeta(
    'kneePushUps',
  );
  @override
  late final GeneratedColumn<int> kneePushUps = GeneratedColumn<int>(
    'knee_push_ups',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plankSecondsMeta = const VerificationMeta(
    'plankSeconds',
  );
  @override
  late final GeneratedColumn<int> plankSeconds = GeneratedColumn<int>(
    'plank_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pullUpsMeta = const VerificationMeta(
    'pullUps',
  );
  @override
  late final GeneratedColumn<int> pullUps = GeneratedColumn<int>(
    'pull_ups',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _squatsMeta = const VerificationMeta('squats');
  @override
  late final GeneratedColumn<int> squats = GeneratedColumn<int>(
    'squats',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    pushUps,
    kneePushUps,
    plankSeconds,
    pullUps,
    squats,
    notes,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessment_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssessmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('push_ups')) {
      context.handle(
        _pushUpsMeta,
        pushUps.isAcceptableOrUnknown(data['push_ups']!, _pushUpsMeta),
      );
    }
    if (data.containsKey('knee_push_ups')) {
      context.handle(
        _kneePushUpsMeta,
        kneePushUps.isAcceptableOrUnknown(
          data['knee_push_ups']!,
          _kneePushUpsMeta,
        ),
      );
    }
    if (data.containsKey('plank_seconds')) {
      context.handle(
        _plankSecondsMeta,
        plankSeconds.isAcceptableOrUnknown(
          data['plank_seconds']!,
          _plankSecondsMeta,
        ),
      );
    }
    if (data.containsKey('pull_ups')) {
      context.handle(
        _pullUpsMeta,
        pullUps.isAcceptableOrUnknown(data['pull_ups']!, _pullUpsMeta),
      );
    }
    if (data.containsKey('squats')) {
      context.handle(
        _squatsMeta,
        squats.isAcceptableOrUnknown(data['squats']!, _squatsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      pushUps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}push_ups'],
      ),
      kneePushUps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knee_push_ups'],
      ),
      plankSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plank_seconds'],
      ),
      pullUps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pull_ups'],
      ),
      squats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}squats'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $AssessmentRowsTable createAlias(String alias) {
    return $AssessmentRowsTable(attachedDatabase, alias);
  }
}

class AssessmentRow extends DataClass implements Insertable<AssessmentRow> {
  final String id;
  final String profileId;
  final int? pushUps;
  final int? kneePushUps;
  final int? plankSeconds;
  final int? pullUps;
  final int? squats;
  final String? notes;
  final DateTime recordedAt;
  const AssessmentRow({
    required this.id,
    required this.profileId,
    this.pushUps,
    this.kneePushUps,
    this.plankSeconds,
    this.pullUps,
    this.squats,
    this.notes,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    if (!nullToAbsent || pushUps != null) {
      map['push_ups'] = Variable<int>(pushUps);
    }
    if (!nullToAbsent || kneePushUps != null) {
      map['knee_push_ups'] = Variable<int>(kneePushUps);
    }
    if (!nullToAbsent || plankSeconds != null) {
      map['plank_seconds'] = Variable<int>(plankSeconds);
    }
    if (!nullToAbsent || pullUps != null) {
      map['pull_ups'] = Variable<int>(pullUps);
    }
    if (!nullToAbsent || squats != null) {
      map['squats'] = Variable<int>(squats);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  AssessmentRowsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentRowsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      pushUps: pushUps == null && nullToAbsent
          ? const Value.absent()
          : Value(pushUps),
      kneePushUps: kneePushUps == null && nullToAbsent
          ? const Value.absent()
          : Value(kneePushUps),
      plankSeconds: plankSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(plankSeconds),
      pullUps: pullUps == null && nullToAbsent
          ? const Value.absent()
          : Value(pullUps),
      squats: squats == null && nullToAbsent
          ? const Value.absent()
          : Value(squats),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      recordedAt: Value(recordedAt),
    );
  }

  factory AssessmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      pushUps: serializer.fromJson<int?>(json['pushUps']),
      kneePushUps: serializer.fromJson<int?>(json['kneePushUps']),
      plankSeconds: serializer.fromJson<int?>(json['plankSeconds']),
      pullUps: serializer.fromJson<int?>(json['pullUps']),
      squats: serializer.fromJson<int?>(json['squats']),
      notes: serializer.fromJson<String?>(json['notes']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'pushUps': serializer.toJson<int?>(pushUps),
      'kneePushUps': serializer.toJson<int?>(kneePushUps),
      'plankSeconds': serializer.toJson<int?>(plankSeconds),
      'pullUps': serializer.toJson<int?>(pullUps),
      'squats': serializer.toJson<int?>(squats),
      'notes': serializer.toJson<String?>(notes),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  AssessmentRow copyWith({
    String? id,
    String? profileId,
    Value<int?> pushUps = const Value.absent(),
    Value<int?> kneePushUps = const Value.absent(),
    Value<int?> plankSeconds = const Value.absent(),
    Value<int?> pullUps = const Value.absent(),
    Value<int?> squats = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? recordedAt,
  }) => AssessmentRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    pushUps: pushUps.present ? pushUps.value : this.pushUps,
    kneePushUps: kneePushUps.present ? kneePushUps.value : this.kneePushUps,
    plankSeconds: plankSeconds.present ? plankSeconds.value : this.plankSeconds,
    pullUps: pullUps.present ? pullUps.value : this.pullUps,
    squats: squats.present ? squats.value : this.squats,
    notes: notes.present ? notes.value : this.notes,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  AssessmentRow copyWithCompanion(AssessmentRowsCompanion data) {
    return AssessmentRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      pushUps: data.pushUps.present ? data.pushUps.value : this.pushUps,
      kneePushUps: data.kneePushUps.present
          ? data.kneePushUps.value
          : this.kneePushUps,
      plankSeconds: data.plankSeconds.present
          ? data.plankSeconds.value
          : this.plankSeconds,
      pullUps: data.pullUps.present ? data.pullUps.value : this.pullUps,
      squats: data.squats.present ? data.squats.value : this.squats,
      notes: data.notes.present ? data.notes.value : this.notes,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('pushUps: $pushUps, ')
          ..write('kneePushUps: $kneePushUps, ')
          ..write('plankSeconds: $plankSeconds, ')
          ..write('pullUps: $pullUps, ')
          ..write('squats: $squats, ')
          ..write('notes: $notes, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    pushUps,
    kneePushUps,
    plankSeconds,
    pullUps,
    squats,
    notes,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.pushUps == this.pushUps &&
          other.kneePushUps == this.kneePushUps &&
          other.plankSeconds == this.plankSeconds &&
          other.pullUps == this.pullUps &&
          other.squats == this.squats &&
          other.notes == this.notes &&
          other.recordedAt == this.recordedAt);
}

class AssessmentRowsCompanion extends UpdateCompanion<AssessmentRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int?> pushUps;
  final Value<int?> kneePushUps;
  final Value<int?> plankSeconds;
  final Value<int?> pullUps;
  final Value<int?> squats;
  final Value<String?> notes;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const AssessmentRowsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.pushUps = const Value.absent(),
    this.kneePushUps = const Value.absent(),
    this.plankSeconds = const Value.absent(),
    this.pullUps = const Value.absent(),
    this.squats = const Value.absent(),
    this.notes = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssessmentRowsCompanion.insert({
    required String id,
    required String profileId,
    this.pushUps = const Value.absent(),
    this.kneePushUps = const Value.absent(),
    this.plankSeconds = const Value.absent(),
    this.pullUps = const Value.absent(),
    this.squats = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       recordedAt = Value(recordedAt);
  static Insertable<AssessmentRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? pushUps,
    Expression<int>? kneePushUps,
    Expression<int>? plankSeconds,
    Expression<int>? pullUps,
    Expression<int>? squats,
    Expression<String>? notes,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (pushUps != null) 'push_ups': pushUps,
      if (kneePushUps != null) 'knee_push_ups': kneePushUps,
      if (plankSeconds != null) 'plank_seconds': plankSeconds,
      if (pullUps != null) 'pull_ups': pullUps,
      if (squats != null) 'squats': squats,
      if (notes != null) 'notes': notes,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssessmentRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int?>? pushUps,
    Value<int?>? kneePushUps,
    Value<int?>? plankSeconds,
    Value<int?>? pullUps,
    Value<int?>? squats,
    Value<String?>? notes,
    Value<DateTime>? recordedAt,
    Value<int>? rowid,
  }) {
    return AssessmentRowsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      pushUps: pushUps ?? this.pushUps,
      kneePushUps: kneePushUps ?? this.kneePushUps,
      plankSeconds: plankSeconds ?? this.plankSeconds,
      pullUps: pullUps ?? this.pullUps,
      squats: squats ?? this.squats,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (pushUps.present) {
      map['push_ups'] = Variable<int>(pushUps.value);
    }
    if (kneePushUps.present) {
      map['knee_push_ups'] = Variable<int>(kneePushUps.value);
    }
    if (plankSeconds.present) {
      map['plank_seconds'] = Variable<int>(plankSeconds.value);
    }
    if (pullUps.present) {
      map['pull_ups'] = Variable<int>(pullUps.value);
    }
    if (squats.present) {
      map['squats'] = Variable<int>(squats.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentRowsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('pushUps: $pushUps, ')
          ..write('kneePushUps: $kneePushUps, ')
          ..write('plankSeconds: $plankSeconds, ')
          ..write('pullUps: $pullUps, ')
          ..write('squats: $squats, ')
          ..write('notes: $notes, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfileRowsTable profileRows = $ProfileRowsTable(this);
  late final $AssessmentRowsTable assessmentRows = $AssessmentRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profileRows,
    assessmentRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profile_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('assessment_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfileRowsTableCreateCompanionBuilder =
    ProfileRowsCompanion Function({
      required String id,
      required int age,
      required int heightCm,
      required double weightKg,
      required String experienceLevel,
      required String goals,
      required String priorities,
      required String equipment,
      required int sessionMinutes,
      required String trainingTime,
      required String dietPattern,
      required String dietRestrictions,
      required String sleepPattern,
      required bool notificationsEnabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProfileRowsTableUpdateCompanionBuilder =
    ProfileRowsCompanion Function({
      Value<String> id,
      Value<int> age,
      Value<int> heightCm,
      Value<double> weightKg,
      Value<String> experienceLevel,
      Value<String> goals,
      Value<String> priorities,
      Value<String> equipment,
      Value<int> sessionMinutes,
      Value<String> trainingTime,
      Value<String> dietPattern,
      Value<String> dietRestrictions,
      Value<String> sleepPattern,
      Value<bool> notificationsEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProfileRowsTableReferences
    extends BaseReferences<_$AppDatabase, $ProfileRowsTable, ProfileRow> {
  $$ProfileRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssessmentRowsTable, List<AssessmentRow>>
  _assessmentRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.assessmentRows,
    aliasName: 'profile_rows__id__assessment_rows__profile_id',
  );

  $$AssessmentRowsTableProcessedTableManager get assessmentRowsRefs {
    final manager = $$AssessmentRowsTableTableManager(
      $_db,
      $_db.assessmentRows,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assessmentRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfileRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileRowsTable> {
  $$ProfileRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priorities => $composableBuilder(
    column: $table.priorities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingTime => $composableBuilder(
    column: $table.trainingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietPattern => $composableBuilder(
    column: $table.dietPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietRestrictions => $composableBuilder(
    column: $table.dietRestrictions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sleepPattern => $composableBuilder(
    column: $table.sleepPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assessmentRowsRefs(
    Expression<bool> Function($$AssessmentRowsTableFilterComposer f) f,
  ) {
    final $$AssessmentRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessmentRows,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssessmentRowsTableFilterComposer(
            $db: $db,
            $table: $db.assessmentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfileRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileRowsTable> {
  $$ProfileRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priorities => $composableBuilder(
    column: $table.priorities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingTime => $composableBuilder(
    column: $table.trainingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietPattern => $composableBuilder(
    column: $table.dietPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietRestrictions => $composableBuilder(
    column: $table.dietRestrictions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sleepPattern => $composableBuilder(
    column: $table.sleepPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileRowsTable> {
  $$ProfileRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<String> get priorities => $composableBuilder(
    column: $table.priorities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trainingTime => $composableBuilder(
    column: $table.trainingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietPattern => $composableBuilder(
    column: $table.dietPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietRestrictions => $composableBuilder(
    column: $table.dietRestrictions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sleepPattern => $composableBuilder(
    column: $table.sleepPattern,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> assessmentRowsRefs<T extends Object>(
    Expression<T> Function($$AssessmentRowsTableAnnotationComposer a) f,
  ) {
    final $$AssessmentRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessmentRows,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssessmentRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.assessmentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfileRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileRowsTable,
          ProfileRow,
          $$ProfileRowsTableFilterComposer,
          $$ProfileRowsTableOrderingComposer,
          $$ProfileRowsTableAnnotationComposer,
          $$ProfileRowsTableCreateCompanionBuilder,
          $$ProfileRowsTableUpdateCompanionBuilder,
          (ProfileRow, $$ProfileRowsTableReferences),
          ProfileRow,
          PrefetchHooks Function({bool assessmentRowsRefs})
        > {
  $$ProfileRowsTableTableManager(_$AppDatabase db, $ProfileRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String> experienceLevel = const Value.absent(),
                Value<String> goals = const Value.absent(),
                Value<String> priorities = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<int> sessionMinutes = const Value.absent(),
                Value<String> trainingTime = const Value.absent(),
                Value<String> dietPattern = const Value.absent(),
                Value<String> dietRestrictions = const Value.absent(),
                Value<String> sleepPattern = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfileRowsCompanion(
                id: id,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                experienceLevel: experienceLevel,
                goals: goals,
                priorities: priorities,
                equipment: equipment,
                sessionMinutes: sessionMinutes,
                trainingTime: trainingTime,
                dietPattern: dietPattern,
                dietRestrictions: dietRestrictions,
                sleepPattern: sleepPattern,
                notificationsEnabled: notificationsEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int age,
                required int heightCm,
                required double weightKg,
                required String experienceLevel,
                required String goals,
                required String priorities,
                required String equipment,
                required int sessionMinutes,
                required String trainingTime,
                required String dietPattern,
                required String dietRestrictions,
                required String sleepPattern,
                required bool notificationsEnabled,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfileRowsCompanion.insert(
                id: id,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                experienceLevel: experienceLevel,
                goals: goals,
                priorities: priorities,
                equipment: equipment,
                sessionMinutes: sessionMinutes,
                trainingTime: trainingTime,
                dietPattern: dietPattern,
                dietRestrictions: dietRestrictions,
                sleepPattern: sleepPattern,
                notificationsEnabled: notificationsEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileRowsTable, ProfileRow>(table),
                  $$ProfileRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assessmentRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (assessmentRowsRefs) db.assessmentRows,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assessmentRowsRefs)
                    await $_getPrefetchedDataByColumns<
                      ProfileRow,
                      $ProfileRowsTable,
                      AssessmentRow,
                      $AssessmentRowsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ProfileRowsTableReferences
                          ._assessmentRowsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProfileRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).assessmentRowsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'profile_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProfileRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileRowsTable,
      ProfileRow,
      $$ProfileRowsTableFilterComposer,
      $$ProfileRowsTableOrderingComposer,
      $$ProfileRowsTableAnnotationComposer,
      $$ProfileRowsTableCreateCompanionBuilder,
      $$ProfileRowsTableUpdateCompanionBuilder,
      (ProfileRow, $$ProfileRowsTableReferences),
      ProfileRow,
      PrefetchHooks Function({bool assessmentRowsRefs})
    >;
typedef $$AssessmentRowsTableCreateCompanionBuilder =
    AssessmentRowsCompanion Function({
      required String id,
      required String profileId,
      Value<int?> pushUps,
      Value<int?> kneePushUps,
      Value<int?> plankSeconds,
      Value<int?> pullUps,
      Value<int?> squats,
      Value<String?> notes,
      required DateTime recordedAt,
      Value<int> rowid,
    });
typedef $$AssessmentRowsTableUpdateCompanionBuilder =
    AssessmentRowsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int?> pushUps,
      Value<int?> kneePushUps,
      Value<int?> plankSeconds,
      Value<int?> pullUps,
      Value<int?> squats,
      Value<String?> notes,
      Value<DateTime> recordedAt,
      Value<int> rowid,
    });

final class $$AssessmentRowsTableReferences
    extends BaseReferences<_$AppDatabase, $AssessmentRowsTable, AssessmentRow> {
  $$AssessmentRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfileRowsTable _profileIdTable(_$AppDatabase db) => db.profileRows
      .createAlias('assessment_rows__profile_id__profile_rows__id');

  $$ProfileRowsTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfileRowsTableTableManager(
      $_db,
      $_db.profileRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AssessmentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AssessmentRowsTable> {
  $$AssessmentRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pushUps => $composableBuilder(
    column: $table.pushUps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kneePushUps => $composableBuilder(
    column: $table.kneePushUps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plankSeconds => $composableBuilder(
    column: $table.plankSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pullUps => $composableBuilder(
    column: $table.pullUps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get squats => $composableBuilder(
    column: $table.squats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfileRowsTableFilterComposer get profileId {
    final $$ProfileRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profileRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileRowsTableFilterComposer(
            $db: $db,
            $table: $db.profileRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssessmentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssessmentRowsTable> {
  $$AssessmentRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pushUps => $composableBuilder(
    column: $table.pushUps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kneePushUps => $composableBuilder(
    column: $table.kneePushUps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plankSeconds => $composableBuilder(
    column: $table.plankSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pullUps => $composableBuilder(
    column: $table.pullUps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get squats => $composableBuilder(
    column: $table.squats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfileRowsTableOrderingComposer get profileId {
    final $$ProfileRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profileRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileRowsTableOrderingComposer(
            $db: $db,
            $table: $db.profileRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssessmentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssessmentRowsTable> {
  $$AssessmentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pushUps =>
      $composableBuilder(column: $table.pushUps, builder: (column) => column);

  GeneratedColumn<int> get kneePushUps => $composableBuilder(
    column: $table.kneePushUps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plankSeconds => $composableBuilder(
    column: $table.plankSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pullUps =>
      $composableBuilder(column: $table.pullUps, builder: (column) => column);

  GeneratedColumn<int> get squats =>
      $composableBuilder(column: $table.squats, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$ProfileRowsTableAnnotationComposer get profileId {
    final $$ProfileRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profileRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.profileRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssessmentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssessmentRowsTable,
          AssessmentRow,
          $$AssessmentRowsTableFilterComposer,
          $$AssessmentRowsTableOrderingComposer,
          $$AssessmentRowsTableAnnotationComposer,
          $$AssessmentRowsTableCreateCompanionBuilder,
          $$AssessmentRowsTableUpdateCompanionBuilder,
          (AssessmentRow, $$AssessmentRowsTableReferences),
          AssessmentRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$AssessmentRowsTableTableManager(
    _$AppDatabase db,
    $AssessmentRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssessmentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssessmentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssessmentRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int?> pushUps = const Value.absent(),
                Value<int?> kneePushUps = const Value.absent(),
                Value<int?> plankSeconds = const Value.absent(),
                Value<int?> pullUps = const Value.absent(),
                Value<int?> squats = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssessmentRowsCompanion(
                id: id,
                profileId: profileId,
                pushUps: pushUps,
                kneePushUps: kneePushUps,
                plankSeconds: plankSeconds,
                pullUps: pullUps,
                squats: squats,
                notes: notes,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                Value<int?> pushUps = const Value.absent(),
                Value<int?> kneePushUps = const Value.absent(),
                Value<int?> plankSeconds = const Value.absent(),
                Value<int?> pullUps = const Value.absent(),
                Value<int?> squats = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssessmentRowsCompanion.insert(
                id: id,
                profileId: profileId,
                pushUps: pushUps,
                kneePushUps: kneePushUps,
                plankSeconds: plankSeconds,
                pullUps: pullUps,
                squats: squats,
                notes: notes,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssessmentRowsTable, AssessmentRow>(table),
                  $$AssessmentRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$AssessmentRowsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$AssessmentRowsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$AssessmentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssessmentRowsTable,
      AssessmentRow,
      $$AssessmentRowsTableFilterComposer,
      $$AssessmentRowsTableOrderingComposer,
      $$AssessmentRowsTableAnnotationComposer,
      $$AssessmentRowsTableCreateCompanionBuilder,
      $$AssessmentRowsTableUpdateCompanionBuilder,
      (AssessmentRow, $$AssessmentRowsTableReferences),
      AssessmentRow,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfileRowsTableTableManager get profileRows =>
      $$ProfileRowsTableTableManager(_db, _db.profileRows);
  $$AssessmentRowsTableTableManager get assessmentRows =>
      $$AssessmentRowsTableTableManager(_db, _db.assessmentRows);
}
