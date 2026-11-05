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

class $WorkoutSessionRowsTable extends WorkoutSessionRows
    with TableInfo<$WorkoutSessionRowsTable, WorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateNameMeta = const VerificationMeta(
    'templateName',
  );
  @override
  late final GeneratedColumn<String> templateName = GeneratedColumn<String>(
    'template_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perceivedEffortMeta = const VerificationMeta(
    'perceivedEffort',
  );
  @override
  late final GeneratedColumn<int> perceivedEffort = GeneratedColumn<int>(
    'perceived_effort',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _restEndsAtMeta = const VerificationMeta(
    'restEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> restEndsAt = GeneratedColumn<DateTime>(
    'rest_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restRemainingSecondsMeta =
      const VerificationMeta('restRemainingSeconds');
  @override
  late final GeneratedColumn<int> restRemainingSeconds = GeneratedColumn<int>(
    'rest_remaining_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastActivityAtMeta = const VerificationMeta(
    'lastActivityAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastActivityAt =
      GeneratedColumn<DateTime>(
        'last_activity_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    templateName,
    mode,
    status,
    startedAt,
    endedAt,
    plannedMinutes,
    perceivedEffort,
    isPaused,
    restEndsAt,
    restRemainingSeconds,
    lastActivityAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_session_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('template_name')) {
      context.handle(
        _templateNameMeta,
        templateName.isAcceptableOrUnknown(
          data['template_name']!,
          _templateNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateNameMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinutesMeta);
    }
    if (data.containsKey('perceived_effort')) {
      context.handle(
        _perceivedEffortMeta,
        perceivedEffort.isAcceptableOrUnknown(
          data['perceived_effort']!,
          _perceivedEffortMeta,
        ),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('rest_ends_at')) {
      context.handle(
        _restEndsAtMeta,
        restEndsAt.isAcceptableOrUnknown(
          data['rest_ends_at']!,
          _restEndsAtMeta,
        ),
      );
    }
    if (data.containsKey('rest_remaining_seconds')) {
      context.handle(
        _restRemainingSecondsMeta,
        restRemainingSeconds.isAcceptableOrUnknown(
          data['rest_remaining_seconds']!,
          _restRemainingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
        _lastActivityAtMeta,
        lastActivityAt.isAcceptableOrUnknown(
          data['last_activity_at']!,
          _lastActivityAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastActivityAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      templateName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_name'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      plannedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minutes'],
      )!,
      perceivedEffort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perceived_effort'],
      ),
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      restEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rest_ends_at'],
      ),
      restRemainingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_remaining_seconds'],
      ),
      lastActivityAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_activity_at'],
      )!,
    );
  }

  @override
  $WorkoutSessionRowsTable createAlias(String alias) {
    return $WorkoutSessionRowsTable(attachedDatabase, alias);
  }
}

class WorkoutSessionRow extends DataClass
    implements Insertable<WorkoutSessionRow> {
  final String id;
  final String templateId;
  final String templateName;
  final String mode;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int plannedMinutes;
  final int? perceivedEffort;
  final bool isPaused;
  final DateTime? restEndsAt;
  final int? restRemainingSeconds;
  final DateTime lastActivityAt;
  const WorkoutSessionRow({
    required this.id,
    required this.templateId,
    required this.templateName,
    required this.mode,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.plannedMinutes,
    this.perceivedEffort,
    required this.isPaused,
    this.restEndsAt,
    this.restRemainingSeconds,
    required this.lastActivityAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['template_name'] = Variable<String>(templateName);
    map['mode'] = Variable<String>(mode);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['planned_minutes'] = Variable<int>(plannedMinutes);
    if (!nullToAbsent || perceivedEffort != null) {
      map['perceived_effort'] = Variable<int>(perceivedEffort);
    }
    map['is_paused'] = Variable<bool>(isPaused);
    if (!nullToAbsent || restEndsAt != null) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt);
    }
    if (!nullToAbsent || restRemainingSeconds != null) {
      map['rest_remaining_seconds'] = Variable<int>(restRemainingSeconds);
    }
    map['last_activity_at'] = Variable<DateTime>(lastActivityAt);
    return map;
  }

  WorkoutSessionRowsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionRowsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      templateName: Value(templateName),
      mode: Value(mode),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      plannedMinutes: Value(plannedMinutes),
      perceivedEffort: perceivedEffort == null && nullToAbsent
          ? const Value.absent()
          : Value(perceivedEffort),
      isPaused: Value(isPaused),
      restEndsAt: restEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restEndsAt),
      restRemainingSeconds: restRemainingSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restRemainingSeconds),
      lastActivityAt: Value(lastActivityAt),
    );
  }

  factory WorkoutSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionRow(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      templateName: serializer.fromJson<String>(json['templateName']),
      mode: serializer.fromJson<String>(json['mode']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      plannedMinutes: serializer.fromJson<int>(json['plannedMinutes']),
      perceivedEffort: serializer.fromJson<int?>(json['perceivedEffort']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      restEndsAt: serializer.fromJson<DateTime?>(json['restEndsAt']),
      restRemainingSeconds: serializer.fromJson<int?>(
        json['restRemainingSeconds'],
      ),
      lastActivityAt: serializer.fromJson<DateTime>(json['lastActivityAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'templateName': serializer.toJson<String>(templateName),
      'mode': serializer.toJson<String>(mode),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'plannedMinutes': serializer.toJson<int>(plannedMinutes),
      'perceivedEffort': serializer.toJson<int?>(perceivedEffort),
      'isPaused': serializer.toJson<bool>(isPaused),
      'restEndsAt': serializer.toJson<DateTime?>(restEndsAt),
      'restRemainingSeconds': serializer.toJson<int?>(restRemainingSeconds),
      'lastActivityAt': serializer.toJson<DateTime>(lastActivityAt),
    };
  }

  WorkoutSessionRow copyWith({
    String? id,
    String? templateId,
    String? templateName,
    String? mode,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? plannedMinutes,
    Value<int?> perceivedEffort = const Value.absent(),
    bool? isPaused,
    Value<DateTime?> restEndsAt = const Value.absent(),
    Value<int?> restRemainingSeconds = const Value.absent(),
    DateTime? lastActivityAt,
  }) => WorkoutSessionRow(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    templateName: templateName ?? this.templateName,
    mode: mode ?? this.mode,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    plannedMinutes: plannedMinutes ?? this.plannedMinutes,
    perceivedEffort: perceivedEffort.present
        ? perceivedEffort.value
        : this.perceivedEffort,
    isPaused: isPaused ?? this.isPaused,
    restEndsAt: restEndsAt.present ? restEndsAt.value : this.restEndsAt,
    restRemainingSeconds: restRemainingSeconds.present
        ? restRemainingSeconds.value
        : this.restRemainingSeconds,
    lastActivityAt: lastActivityAt ?? this.lastActivityAt,
  );
  WorkoutSessionRow copyWithCompanion(WorkoutSessionRowsCompanion data) {
    return WorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      templateName: data.templateName.present
          ? data.templateName.value
          : this.templateName,
      mode: data.mode.present ? data.mode.value : this.mode,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedMinutes: data.plannedMinutes.present
          ? data.plannedMinutes.value
          : this.plannedMinutes,
      perceivedEffort: data.perceivedEffort.present
          ? data.perceivedEffort.value
          : this.perceivedEffort,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      restEndsAt: data.restEndsAt.present
          ? data.restEndsAt.value
          : this.restEndsAt,
      restRemainingSeconds: data.restRemainingSeconds.present
          ? data.restRemainingSeconds.value
          : this.restRemainingSeconds,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('templateName: $templateName, ')
          ..write('mode: $mode, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('perceivedEffort: $perceivedEffort, ')
          ..write('isPaused: $isPaused, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('restRemainingSeconds: $restRemainingSeconds, ')
          ..write('lastActivityAt: $lastActivityAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    templateName,
    mode,
    status,
    startedAt,
    endedAt,
    plannedMinutes,
    perceivedEffort,
    isPaused,
    restEndsAt,
    restRemainingSeconds,
    lastActivityAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionRow &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.templateName == this.templateName &&
          other.mode == this.mode &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedMinutes == this.plannedMinutes &&
          other.perceivedEffort == this.perceivedEffort &&
          other.isPaused == this.isPaused &&
          other.restEndsAt == this.restEndsAt &&
          other.restRemainingSeconds == this.restRemainingSeconds &&
          other.lastActivityAt == this.lastActivityAt);
}

class WorkoutSessionRowsCompanion extends UpdateCompanion<WorkoutSessionRow> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> templateName;
  final Value<String> mode;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> plannedMinutes;
  final Value<int?> perceivedEffort;
  final Value<bool> isPaused;
  final Value<DateTime?> restEndsAt;
  final Value<int?> restRemainingSeconds;
  final Value<DateTime> lastActivityAt;
  final Value<int> rowid;
  const WorkoutSessionRowsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateName = const Value.absent(),
    this.mode = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.perceivedEffort = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.restRemainingSeconds = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionRowsCompanion.insert({
    required String id,
    required String templateId,
    required String templateName,
    required String mode,
    required String status,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required int plannedMinutes,
    this.perceivedEffort = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.restRemainingSeconds = const Value.absent(),
    required DateTime lastActivityAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       templateName = Value(templateName),
       mode = Value(mode),
       status = Value(status),
       startedAt = Value(startedAt),
       plannedMinutes = Value(plannedMinutes),
       lastActivityAt = Value(lastActivityAt);
  static Insertable<WorkoutSessionRow> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? templateName,
    Expression<String>? mode,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedMinutes,
    Expression<int>? perceivedEffort,
    Expression<bool>? isPaused,
    Expression<DateTime>? restEndsAt,
    Expression<int>? restRemainingSeconds,
    Expression<DateTime>? lastActivityAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (templateName != null) 'template_name': templateName,
      if (mode != null) 'mode': mode,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (perceivedEffort != null) 'perceived_effort': perceivedEffort,
      if (isPaused != null) 'is_paused': isPaused,
      if (restEndsAt != null) 'rest_ends_at': restEndsAt,
      if (restRemainingSeconds != null)
        'rest_remaining_seconds': restRemainingSeconds,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<String>? templateName,
    Value<String>? mode,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? plannedMinutes,
    Value<int?>? perceivedEffort,
    Value<bool>? isPaused,
    Value<DateTime?>? restEndsAt,
    Value<int?>? restRemainingSeconds,
    Value<DateTime>? lastActivityAt,
    Value<int>? rowid,
  }) {
    return WorkoutSessionRowsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      perceivedEffort: perceivedEffort ?? this.perceivedEffort,
      isPaused: isPaused ?? this.isPaused,
      restEndsAt: restEndsAt ?? this.restEndsAt,
      restRemainingSeconds: restRemainingSeconds ?? this.restRemainingSeconds,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (templateName.present) {
      map['template_name'] = Variable<String>(templateName.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (perceivedEffort.present) {
      map['perceived_effort'] = Variable<int>(perceivedEffort.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (restEndsAt.present) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt.value);
    }
    if (restRemainingSeconds.present) {
      map['rest_remaining_seconds'] = Variable<int>(restRemainingSeconds.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRowsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('templateName: $templateName, ')
          ..write('mode: $mode, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('perceivedEffort: $perceivedEffort, ')
          ..write('isPaused: $isPaused, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('restRemainingSeconds: $restRemainingSeconds, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionExerciseRowsTable extends WorkoutSessionExerciseRows
    with
        TableInfo<$WorkoutSessionExerciseRowsTable, WorkoutSessionExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionExerciseRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_session_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedSetsMeta = const VerificationMeta(
    'plannedSets',
  );
  @override
  late final GeneratedColumn<int> plannedSets = GeneratedColumn<int>(
    'planned_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSecondsMeta = const VerificationMeta(
    'targetSeconds',
  );
  @override
  late final GeneratedColumn<int> targetSeconds = GeneratedColumn<int>(
    'target_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    orderIndex,
    plannedSets,
    targetReps,
    targetSeconds,
    restSeconds,
    skipped,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_session_exercise_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('planned_sets')) {
      context.handle(
        _plannedSetsMeta,
        plannedSets.isAcceptableOrUnknown(
          data['planned_sets']!,
          _plannedSetsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSetsMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    if (data.containsKey('target_seconds')) {
      context.handle(
        _targetSecondsMeta,
        targetSeconds.isAcceptableOrUnknown(
          data['target_seconds']!,
          _targetSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionExerciseRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      plannedSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_sets'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      ),
      targetSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_seconds'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $WorkoutSessionExerciseRowsTable createAlias(String alias) {
    return $WorkoutSessionExerciseRowsTable(attachedDatabase, alias);
  }
}

class WorkoutSessionExerciseRow extends DataClass
    implements Insertable<WorkoutSessionExerciseRow> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int orderIndex;
  final int plannedSets;
  final int? targetReps;
  final int? targetSeconds;
  final int restSeconds;
  final bool skipped;
  final DateTime? completedAt;
  const WorkoutSessionExerciseRow({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
    required this.plannedSets,
    this.targetReps,
    this.targetSeconds,
    required this.restSeconds,
    required this.skipped,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['planned_sets'] = Variable<int>(plannedSets);
    if (!nullToAbsent || targetReps != null) {
      map['target_reps'] = Variable<int>(targetReps);
    }
    if (!nullToAbsent || targetSeconds != null) {
      map['target_seconds'] = Variable<int>(targetSeconds);
    }
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['skipped'] = Variable<bool>(skipped);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutSessionExerciseRowsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionExerciseRowsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      plannedSets: Value(plannedSets),
      targetReps: targetReps == null && nullToAbsent
          ? const Value.absent()
          : Value(targetReps),
      targetSeconds: targetSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSeconds),
      restSeconds: Value(restSeconds),
      skipped: Value(skipped),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory WorkoutSessionExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      plannedSets: serializer.fromJson<int>(json['plannedSets']),
      targetReps: serializer.fromJson<int?>(json['targetReps']),
      targetSeconds: serializer.fromJson<int?>(json['targetSeconds']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'plannedSets': serializer.toJson<int>(plannedSets),
      'targetReps': serializer.toJson<int?>(targetReps),
      'targetSeconds': serializer.toJson<int?>(targetSeconds),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'skipped': serializer.toJson<bool>(skipped),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  WorkoutSessionExerciseRow copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? orderIndex,
    int? plannedSets,
    Value<int?> targetReps = const Value.absent(),
    Value<int?> targetSeconds = const Value.absent(),
    int? restSeconds,
    bool? skipped,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSessionExerciseRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    plannedSets: plannedSets ?? this.plannedSets,
    targetReps: targetReps.present ? targetReps.value : this.targetReps,
    targetSeconds: targetSeconds.present
        ? targetSeconds.value
        : this.targetSeconds,
    restSeconds: restSeconds ?? this.restSeconds,
    skipped: skipped ?? this.skipped,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  WorkoutSessionExerciseRow copyWithCompanion(
    WorkoutSessionExerciseRowsCompanion data,
  ) {
    return WorkoutSessionExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      plannedSets: data.plannedSets.present
          ? data.plannedSets.value
          : this.plannedSets,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      targetSeconds: data.targetSeconds.present
          ? data.targetSeconds.value
          : this.targetSeconds,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionExerciseRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('plannedSets: $plannedSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('skipped: $skipped, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    orderIndex,
    plannedSets,
    targetReps,
    targetSeconds,
    restSeconds,
    skipped,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionExerciseRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.plannedSets == this.plannedSets &&
          other.targetReps == this.targetReps &&
          other.targetSeconds == this.targetSeconds &&
          other.restSeconds == this.restSeconds &&
          other.skipped == this.skipped &&
          other.completedAt == this.completedAt);
}

class WorkoutSessionExerciseRowsCompanion
    extends UpdateCompanion<WorkoutSessionExerciseRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> plannedSets;
  final Value<int?> targetReps;
  final Value<int?> targetSeconds;
  final Value<int> restSeconds;
  final Value<bool> skipped;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const WorkoutSessionExerciseRowsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.plannedSets = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.skipped = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionExerciseRowsCompanion.insert({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int orderIndex,
    required int plannedSets,
    this.targetReps = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    required int restSeconds,
    this.skipped = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex),
       plannedSets = Value(plannedSets),
       restSeconds = Value(restSeconds);
  static Insertable<WorkoutSessionExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? plannedSets,
    Expression<int>? targetReps,
    Expression<int>? targetSeconds,
    Expression<int>? restSeconds,
    Expression<bool>? skipped,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (plannedSets != null) 'planned_sets': plannedSets,
      if (targetReps != null) 'target_reps': targetReps,
      if (targetSeconds != null) 'target_seconds': targetSeconds,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (skipped != null) 'skipped': skipped,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionExerciseRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? orderIndex,
    Value<int>? plannedSets,
    Value<int?>? targetReps,
    Value<int?>? targetSeconds,
    Value<int>? restSeconds,
    Value<bool>? skipped,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSessionExerciseRowsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      plannedSets: plannedSets ?? this.plannedSets,
      targetReps: targetReps ?? this.targetReps,
      targetSeconds: targetSeconds ?? this.targetSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      skipped: skipped ?? this.skipped,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (plannedSets.present) {
      map['planned_sets'] = Variable<int>(plannedSets.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (targetSeconds.present) {
      map['target_seconds'] = Variable<int>(targetSeconds.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionExerciseRowsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('plannedSets: $plannedSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('skipped: $skipped, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetRowsTable extends WorkoutSetRows
    with TableInfo<$WorkoutSetRowsTable, WorkoutSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_session_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<String> sessionExerciseId =
      GeneratedColumn<String>(
        'session_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_session_exercise_rows (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualRepsMeta = const VerificationMeta(
    'actualReps',
  );
  @override
  late final GeneratedColumn<int> actualReps = GeneratedColumn<int>(
    'actual_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSecondsMeta = const VerificationMeta(
    'targetSeconds',
  );
  @override
  late final GeneratedColumn<int> targetSeconds = GeneratedColumn<int>(
    'target_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualSecondsMeta = const VerificationMeta(
    'actualSeconds',
  );
  @override
  late final GeneratedColumn<int> actualSeconds = GeneratedColumn<int>(
    'actual_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsTakenMeta = const VerificationMeta(
    'restSecondsTaken',
  );
  @override
  late final GeneratedColumn<int> restSecondsTaken = GeneratedColumn<int>(
    'rest_seconds_taken',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    sessionExerciseId,
    exerciseId,
    setIndex,
    targetReps,
    actualReps,
    targetSeconds,
    actualSeconds,
    restSecondsTaken,
    skipped,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    if (data.containsKey('actual_reps')) {
      context.handle(
        _actualRepsMeta,
        actualReps.isAcceptableOrUnknown(data['actual_reps']!, _actualRepsMeta),
      );
    }
    if (data.containsKey('target_seconds')) {
      context.handle(
        _targetSecondsMeta,
        targetSeconds.isAcceptableOrUnknown(
          data['target_seconds']!,
          _targetSecondsMeta,
        ),
      );
    }
    if (data.containsKey('actual_seconds')) {
      context.handle(
        _actualSecondsMeta,
        actualSeconds.isAcceptableOrUnknown(
          data['actual_seconds']!,
          _actualSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds_taken')) {
      context.handle(
        _restSecondsTakenMeta,
        restSecondsTaken.isAcceptableOrUnknown(
          data['rest_seconds_taken']!,
          _restSecondsTakenMeta,
        ),
      );
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      ),
      actualReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_reps'],
      ),
      targetSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_seconds'],
      ),
      actualSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_seconds'],
      ),
      restSecondsTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds_taken'],
      ),
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $WorkoutSetRowsTable createAlias(String alias) {
    return $WorkoutSetRowsTable(attachedDatabase, alias);
  }
}

class WorkoutSetRow extends DataClass implements Insertable<WorkoutSetRow> {
  final String id;
  final String sessionId;
  final String sessionExerciseId;
  final String exerciseId;
  final int setIndex;
  final int? targetReps;
  final int? actualReps;
  final int? targetSeconds;
  final int? actualSeconds;
  final int? restSecondsTaken;
  final bool skipped;
  final DateTime completedAt;
  const WorkoutSetRow({
    required this.id,
    required this.sessionId,
    required this.sessionExerciseId,
    required this.exerciseId,
    required this.setIndex,
    this.targetReps,
    this.actualReps,
    this.targetSeconds,
    this.actualSeconds,
    this.restSecondsTaken,
    required this.skipped,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['session_exercise_id'] = Variable<String>(sessionExerciseId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_index'] = Variable<int>(setIndex);
    if (!nullToAbsent || targetReps != null) {
      map['target_reps'] = Variable<int>(targetReps);
    }
    if (!nullToAbsent || actualReps != null) {
      map['actual_reps'] = Variable<int>(actualReps);
    }
    if (!nullToAbsent || targetSeconds != null) {
      map['target_seconds'] = Variable<int>(targetSeconds);
    }
    if (!nullToAbsent || actualSeconds != null) {
      map['actual_seconds'] = Variable<int>(actualSeconds);
    }
    if (!nullToAbsent || restSecondsTaken != null) {
      map['rest_seconds_taken'] = Variable<int>(restSecondsTaken);
    }
    map['skipped'] = Variable<bool>(skipped);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  WorkoutSetRowsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetRowsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      sessionExerciseId: Value(sessionExerciseId),
      exerciseId: Value(exerciseId),
      setIndex: Value(setIndex),
      targetReps: targetReps == null && nullToAbsent
          ? const Value.absent()
          : Value(targetReps),
      actualReps: actualReps == null && nullToAbsent
          ? const Value.absent()
          : Value(actualReps),
      targetSeconds: targetSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSeconds),
      actualSeconds: actualSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(actualSeconds),
      restSecondsTaken: restSecondsTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(restSecondsTaken),
      skipped: Value(skipped),
      completedAt: Value(completedAt),
    );
  }

  factory WorkoutSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sessionExerciseId: serializer.fromJson<String>(json['sessionExerciseId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      targetReps: serializer.fromJson<int?>(json['targetReps']),
      actualReps: serializer.fromJson<int?>(json['actualReps']),
      targetSeconds: serializer.fromJson<int?>(json['targetSeconds']),
      actualSeconds: serializer.fromJson<int?>(json['actualSeconds']),
      restSecondsTaken: serializer.fromJson<int?>(json['restSecondsTaken']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'sessionExerciseId': serializer.toJson<String>(sessionExerciseId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setIndex': serializer.toJson<int>(setIndex),
      'targetReps': serializer.toJson<int?>(targetReps),
      'actualReps': serializer.toJson<int?>(actualReps),
      'targetSeconds': serializer.toJson<int?>(targetSeconds),
      'actualSeconds': serializer.toJson<int?>(actualSeconds),
      'restSecondsTaken': serializer.toJson<int?>(restSecondsTaken),
      'skipped': serializer.toJson<bool>(skipped),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  WorkoutSetRow copyWith({
    String? id,
    String? sessionId,
    String? sessionExerciseId,
    String? exerciseId,
    int? setIndex,
    Value<int?> targetReps = const Value.absent(),
    Value<int?> actualReps = const Value.absent(),
    Value<int?> targetSeconds = const Value.absent(),
    Value<int?> actualSeconds = const Value.absent(),
    Value<int?> restSecondsTaken = const Value.absent(),
    bool? skipped,
    DateTime? completedAt,
  }) => WorkoutSetRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    exerciseId: exerciseId ?? this.exerciseId,
    setIndex: setIndex ?? this.setIndex,
    targetReps: targetReps.present ? targetReps.value : this.targetReps,
    actualReps: actualReps.present ? actualReps.value : this.actualReps,
    targetSeconds: targetSeconds.present
        ? targetSeconds.value
        : this.targetSeconds,
    actualSeconds: actualSeconds.present
        ? actualSeconds.value
        : this.actualSeconds,
    restSecondsTaken: restSecondsTaken.present
        ? restSecondsTaken.value
        : this.restSecondsTaken,
    skipped: skipped ?? this.skipped,
    completedAt: completedAt ?? this.completedAt,
  );
  WorkoutSetRow copyWithCompanion(WorkoutSetRowsCompanion data) {
    return WorkoutSetRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      actualReps: data.actualReps.present
          ? data.actualReps.value
          : this.actualReps,
      targetSeconds: data.targetSeconds.present
          ? data.targetSeconds.value
          : this.targetSeconds,
      actualSeconds: data.actualSeconds.present
          ? data.actualSeconds.value
          : this.actualSeconds,
      restSecondsTaken: data.restSecondsTaken.present
          ? data.restSecondsTaken.value
          : this.restSecondsTaken,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('targetReps: $targetReps, ')
          ..write('actualReps: $actualReps, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('actualSeconds: $actualSeconds, ')
          ..write('restSecondsTaken: $restSecondsTaken, ')
          ..write('skipped: $skipped, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    sessionExerciseId,
    exerciseId,
    setIndex,
    targetReps,
    actualReps,
    targetSeconds,
    actualSeconds,
    restSecondsTaken,
    skipped,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.exerciseId == this.exerciseId &&
          other.setIndex == this.setIndex &&
          other.targetReps == this.targetReps &&
          other.actualReps == this.actualReps &&
          other.targetSeconds == this.targetSeconds &&
          other.actualSeconds == this.actualSeconds &&
          other.restSecondsTaken == this.restSecondsTaken &&
          other.skipped == this.skipped &&
          other.completedAt == this.completedAt);
}

class WorkoutSetRowsCompanion extends UpdateCompanion<WorkoutSetRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> sessionExerciseId;
  final Value<String> exerciseId;
  final Value<int> setIndex;
  final Value<int?> targetReps;
  final Value<int?> actualReps;
  final Value<int?> targetSeconds;
  final Value<int?> actualSeconds;
  final Value<int?> restSecondsTaken;
  final Value<bool> skipped;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const WorkoutSetRowsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.actualReps = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.actualSeconds = const Value.absent(),
    this.restSecondsTaken = const Value.absent(),
    this.skipped = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetRowsCompanion.insert({
    required String id,
    required String sessionId,
    required String sessionExerciseId,
    required String exerciseId,
    required int setIndex,
    this.targetReps = const Value.absent(),
    this.actualReps = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.actualSeconds = const Value.absent(),
    this.restSecondsTaken = const Value.absent(),
    this.skipped = const Value.absent(),
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       sessionExerciseId = Value(sessionExerciseId),
       exerciseId = Value(exerciseId),
       setIndex = Value(setIndex),
       completedAt = Value(completedAt);
  static Insertable<WorkoutSetRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? sessionExerciseId,
    Expression<String>? exerciseId,
    Expression<int>? setIndex,
    Expression<int>? targetReps,
    Expression<int>? actualReps,
    Expression<int>? targetSeconds,
    Expression<int>? actualSeconds,
    Expression<int>? restSecondsTaken,
    Expression<bool>? skipped,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setIndex != null) 'set_index': setIndex,
      if (targetReps != null) 'target_reps': targetReps,
      if (actualReps != null) 'actual_reps': actualReps,
      if (targetSeconds != null) 'target_seconds': targetSeconds,
      if (actualSeconds != null) 'actual_seconds': actualSeconds,
      if (restSecondsTaken != null) 'rest_seconds_taken': restSecondsTaken,
      if (skipped != null) 'skipped': skipped,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? sessionExerciseId,
    Value<String>? exerciseId,
    Value<int>? setIndex,
    Value<int?>? targetReps,
    Value<int?>? actualReps,
    Value<int?>? targetSeconds,
    Value<int?>? actualSeconds,
    Value<int?>? restSecondsTaken,
    Value<bool>? skipped,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetRowsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      exerciseId: exerciseId ?? this.exerciseId,
      setIndex: setIndex ?? this.setIndex,
      targetReps: targetReps ?? this.targetReps,
      actualReps: actualReps ?? this.actualReps,
      targetSeconds: targetSeconds ?? this.targetSeconds,
      actualSeconds: actualSeconds ?? this.actualSeconds,
      restSecondsTaken: restSecondsTaken ?? this.restSecondsTaken,
      skipped: skipped ?? this.skipped,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<String>(sessionExerciseId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (actualReps.present) {
      map['actual_reps'] = Variable<int>(actualReps.value);
    }
    if (targetSeconds.present) {
      map['target_seconds'] = Variable<int>(targetSeconds.value);
    }
    if (actualSeconds.present) {
      map['actual_seconds'] = Variable<int>(actualSeconds.value);
    }
    if (restSecondsTaken.present) {
      map['rest_seconds_taken'] = Variable<int>(restSecondsTaken.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetRowsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('targetReps: $targetReps, ')
          ..write('actualReps: $actualReps, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('actualSeconds: $actualSeconds, ')
          ..write('restSecondsTaken: $restSecondsTaken, ')
          ..write('skipped: $skipped, ')
          ..write('completedAt: $completedAt, ')
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
  late final $WorkoutSessionRowsTable workoutSessionRows =
      $WorkoutSessionRowsTable(this);
  late final $WorkoutSessionExerciseRowsTable workoutSessionExerciseRows =
      $WorkoutSessionExerciseRowsTable(this);
  late final $WorkoutSetRowsTable workoutSetRows = $WorkoutSetRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profileRows,
    assessmentRows,
    workoutSessionRows,
    workoutSessionExerciseRows,
    workoutSetRows,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_session_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('workout_session_exercise_rows', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_session_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_set_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_session_exercise_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_set_rows', kind: UpdateKind.delete)],
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
typedef $$WorkoutSessionRowsTableCreateCompanionBuilder =
    WorkoutSessionRowsCompanion Function({
      required String id,
      required String templateId,
      required String templateName,
      required String mode,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required int plannedMinutes,
      Value<int?> perceivedEffort,
      Value<bool> isPaused,
      Value<DateTime?> restEndsAt,
      Value<int?> restRemainingSeconds,
      required DateTime lastActivityAt,
      Value<int> rowid,
    });
typedef $$WorkoutSessionRowsTableUpdateCompanionBuilder =
    WorkoutSessionRowsCompanion Function({
      Value<String> id,
      Value<String> templateId,
      Value<String> templateName,
      Value<String> mode,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> plannedMinutes,
      Value<int?> perceivedEffort,
      Value<bool> isPaused,
      Value<DateTime?> restEndsAt,
      Value<int?> restRemainingSeconds,
      Value<DateTime> lastActivityAt,
      Value<int> rowid,
    });

final class $$WorkoutSessionRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSessionRowsTable,
          WorkoutSessionRow
        > {
  $$WorkoutSessionRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutSessionExerciseRowsTable,
    List<WorkoutSessionExerciseRow>
  >
  _workoutSessionExerciseRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workoutSessionExerciseRows,
    aliasName:
        'workout_session_rows__id__workout_session_exercise_rows__session_id',
  );

  $$WorkoutSessionExerciseRowsTableProcessedTableManager
  get workoutSessionExerciseRowsRefs {
    final manager = $$WorkoutSessionExerciseRowsTableTableManager(
      $_db,
      $_db.workoutSessionExerciseRows,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionExerciseRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSetRowsTable, List<WorkoutSetRow>>
  _workoutSetRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSetRows,
    aliasName: 'workout_session_rows__id__workout_set_rows__session_id',
  );

  $$WorkoutSetRowsTableProcessedTableManager get workoutSetRowsRefs {
    final manager = $$WorkoutSetRowsTableTableManager(
      $_db,
      $_db.workoutSetRows,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionRowsTable> {
  $$WorkoutSessionRowsTableFilterComposer({
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

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perceivedEffort => $composableBuilder(
    column: $table.perceivedEffort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restRemainingSeconds => $composableBuilder(
    column: $table.restRemainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSessionExerciseRowsRefs(
    Expression<bool> Function($$WorkoutSessionExerciseRowsTableFilterComposer f)
    f,
  ) {
    final $$WorkoutSessionExerciseRowsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSessionExerciseRows,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExerciseRowsTableFilterComposer(
                $db: $db,
                $table: $db.workoutSessionExerciseRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> workoutSetRowsRefs(
    Expression<bool> Function($$WorkoutSetRowsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetRows,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetRowsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionRowsTable> {
  $$WorkoutSessionRowsTableOrderingComposer({
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

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perceivedEffort => $composableBuilder(
    column: $table.perceivedEffort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restRemainingSeconds => $composableBuilder(
    column: $table.restRemainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionRowsTable> {
  $$WorkoutSessionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perceivedEffort => $composableBuilder(
    column: $table.perceivedEffort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restRemainingSeconds => $composableBuilder(
    column: $table.restRemainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => column,
  );

  Expression<T> workoutSessionExerciseRowsRefs<T extends Object>(
    Expression<T> Function(
      $$WorkoutSessionExerciseRowsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$WorkoutSessionExerciseRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSessionExerciseRows,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExerciseRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSessionExerciseRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workoutSetRowsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetRowsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetRows,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSetRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionRowsTable,
          WorkoutSessionRow,
          $$WorkoutSessionRowsTableFilterComposer,
          $$WorkoutSessionRowsTableOrderingComposer,
          $$WorkoutSessionRowsTableAnnotationComposer,
          $$WorkoutSessionRowsTableCreateCompanionBuilder,
          $$WorkoutSessionRowsTableUpdateCompanionBuilder,
          (WorkoutSessionRow, $$WorkoutSessionRowsTableReferences),
          WorkoutSessionRow,
          PrefetchHooks Function({
            bool workoutSessionExerciseRowsRefs,
            bool workoutSetRowsRefs,
          })
        > {
  $$WorkoutSessionRowsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> templateName = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> plannedMinutes = const Value.absent(),
                Value<int?> perceivedEffort = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<int?> restRemainingSeconds = const Value.absent(),
                Value<DateTime> lastActivityAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionRowsCompanion(
                id: id,
                templateId: templateId,
                templateName: templateName,
                mode: mode,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                perceivedEffort: perceivedEffort,
                isPaused: isPaused,
                restEndsAt: restEndsAt,
                restRemainingSeconds: restRemainingSeconds,
                lastActivityAt: lastActivityAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateId,
                required String templateName,
                required String mode,
                required String status,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required int plannedMinutes,
                Value<int?> perceivedEffort = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<int?> restRemainingSeconds = const Value.absent(),
                required DateTime lastActivityAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionRowsCompanion.insert(
                id: id,
                templateId: templateId,
                templateName: templateName,
                mode: mode,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                perceivedEffort: perceivedEffort,
                isPaused: isPaused,
                restEndsAt: restEndsAt,
                restRemainingSeconds: restRemainingSeconds,
                lastActivityAt: lastActivityAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionRowsTable, WorkoutSessionRow>(
                    table,
                  ),
                  $$WorkoutSessionRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutSessionExerciseRowsRefs = false,
                workoutSetRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSessionExerciseRowsRefs)
                      db.workoutSessionExerciseRows,
                    if (workoutSetRowsRefs) db.workoutSetRows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSessionExerciseRowsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutSessionRow,
                          $WorkoutSessionRowsTable,
                          WorkoutSessionExerciseRow,
                          $WorkoutSessionExerciseRowsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionRowsTableReferences
                              ._workoutSessionExerciseRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionExerciseRowsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                      if (workoutSetRowsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutSessionRow,
                          $WorkoutSessionRowsTable,
                          WorkoutSetRow,
                          $WorkoutSetRowsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionRowsTableReferences
                              ._workoutSetRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetRowsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSessionRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionRowsTable,
      WorkoutSessionRow,
      $$WorkoutSessionRowsTableFilterComposer,
      $$WorkoutSessionRowsTableOrderingComposer,
      $$WorkoutSessionRowsTableAnnotationComposer,
      $$WorkoutSessionRowsTableCreateCompanionBuilder,
      $$WorkoutSessionRowsTableUpdateCompanionBuilder,
      (WorkoutSessionRow, $$WorkoutSessionRowsTableReferences),
      WorkoutSessionRow,
      PrefetchHooks Function({
        bool workoutSessionExerciseRowsRefs,
        bool workoutSetRowsRefs,
      })
    >;
typedef $$WorkoutSessionExerciseRowsTableCreateCompanionBuilder =
    WorkoutSessionExerciseRowsCompanion Function({
      required String id,
      required String sessionId,
      required String exerciseId,
      required int orderIndex,
      required int plannedSets,
      Value<int?> targetReps,
      Value<int?> targetSeconds,
      required int restSeconds,
      Value<bool> skipped,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSessionExerciseRowsTableUpdateCompanionBuilder =
    WorkoutSessionExerciseRowsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> exerciseId,
      Value<int> orderIndex,
      Value<int> plannedSets,
      Value<int?> targetReps,
      Value<int?> targetSeconds,
      Value<int> restSeconds,
      Value<bool> skipped,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$WorkoutSessionExerciseRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSessionExerciseRowsTable,
          WorkoutSessionExerciseRow
        > {
  $$WorkoutSessionExerciseRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionRowsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessionRows.createAlias(
        'workout_session_exercise_rows__session_id__workout_session_rows__id',
      );

  $$WorkoutSessionRowsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionRowsTableTableManager(
      $_db,
      $_db.workoutSessionRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetRowsTable, List<WorkoutSetRow>>
  _workoutSetRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSetRows,
    aliasName: 'workout_session_exercise_rows__id__workout_set_rows__session_exercise_id',
  );

  $$WorkoutSetRowsTableProcessedTableManager get workoutSetRowsRefs {
    final manager = $$WorkoutSetRowsTableTableManager($_db, $_db.workoutSetRows)
        .filter(
          (f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_workoutSetRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionExerciseRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionExerciseRowsTable> {
  $$WorkoutSessionExerciseRowsTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSets => $composableBuilder(
    column: $table.plannedSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionRowsTableFilterComposer get sessionId {
    final $$WorkoutSessionRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessionRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionRowsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetRowsRefs(
    Expression<bool> Function($$WorkoutSetRowsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetRows,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetRowsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionExerciseRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionExerciseRowsTable> {
  $$WorkoutSessionExerciseRowsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSets => $composableBuilder(
    column: $table.plannedSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionRowsTableOrderingComposer get sessionId {
    final $$WorkoutSessionRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessionRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionRowsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionExerciseRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionExerciseRowsTable> {
  $$WorkoutSessionExerciseRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedSets => $composableBuilder(
    column: $table.plannedSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$WorkoutSessionRowsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.workoutSessionRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSessionRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> workoutSetRowsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetRowsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetRows,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSetRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionExerciseRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionExerciseRowsTable,
          WorkoutSessionExerciseRow,
          $$WorkoutSessionExerciseRowsTableFilterComposer,
          $$WorkoutSessionExerciseRowsTableOrderingComposer,
          $$WorkoutSessionExerciseRowsTableAnnotationComposer,
          $$WorkoutSessionExerciseRowsTableCreateCompanionBuilder,
          $$WorkoutSessionExerciseRowsTableUpdateCompanionBuilder,
          (
            WorkoutSessionExerciseRow,
            $$WorkoutSessionExerciseRowsTableReferences,
          ),
          WorkoutSessionExerciseRow,
          PrefetchHooks Function({bool sessionId, bool workoutSetRowsRefs})
        > {
  $$WorkoutSessionExerciseRowsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionExerciseRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionExerciseRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutSessionExerciseRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutSessionExerciseRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> plannedSets = const Value.absent(),
                Value<int?> targetReps = const Value.absent(),
                Value<int?> targetSeconds = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionExerciseRowsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                plannedSets: plannedSets,
                targetReps: targetReps,
                targetSeconds: targetSeconds,
                restSeconds: restSeconds,
                skipped: skipped,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String exerciseId,
                required int orderIndex,
                required int plannedSets,
                Value<int?> targetReps = const Value.absent(),
                Value<int?> targetSeconds = const Value.absent(),
                required int restSeconds,
                Value<bool> skipped = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionExerciseRowsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                plannedSets: plannedSets,
                targetReps: targetReps,
                targetSeconds: targetSeconds,
                restSeconds: restSeconds,
                skipped: skipped,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WorkoutSessionExerciseRowsTable,
                    WorkoutSessionExerciseRow
                  >(table),
                  $$WorkoutSessionExerciseRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, workoutSetRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetRowsRefs) db.workoutSetRows,
                  ],
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
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable:
                                $$WorkoutSessionExerciseRowsTableReferences
                                    ._sessionIdTable(db),
                            referencedColumn:
                                $$WorkoutSessionExerciseRowsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetRowsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutSessionExerciseRow,
                          $WorkoutSessionExerciseRowsTable,
                          WorkoutSetRow,
                          $WorkoutSetRowsTable
                        >(
                          currentTable: table,
                          referencedTable:
                              $$WorkoutSessionExerciseRowsTableReferences
                                  ._workoutSetRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionExerciseRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetRowsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSessionExerciseRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionExerciseRowsTable,
      WorkoutSessionExerciseRow,
      $$WorkoutSessionExerciseRowsTableFilterComposer,
      $$WorkoutSessionExerciseRowsTableOrderingComposer,
      $$WorkoutSessionExerciseRowsTableAnnotationComposer,
      $$WorkoutSessionExerciseRowsTableCreateCompanionBuilder,
      $$WorkoutSessionExerciseRowsTableUpdateCompanionBuilder,
      (WorkoutSessionExerciseRow, $$WorkoutSessionExerciseRowsTableReferences),
      WorkoutSessionExerciseRow,
      PrefetchHooks Function({bool sessionId, bool workoutSetRowsRefs})
    >;
typedef $$WorkoutSetRowsTableCreateCompanionBuilder =
    WorkoutSetRowsCompanion Function({
      required String id,
      required String sessionId,
      required String sessionExerciseId,
      required String exerciseId,
      required int setIndex,
      Value<int?> targetReps,
      Value<int?> actualReps,
      Value<int?> targetSeconds,
      Value<int?> actualSeconds,
      Value<int?> restSecondsTaken,
      Value<bool> skipped,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetRowsTableUpdateCompanionBuilder =
    WorkoutSetRowsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> sessionExerciseId,
      Value<String> exerciseId,
      Value<int> setIndex,
      Value<int?> targetReps,
      Value<int?> actualReps,
      Value<int?> targetSeconds,
      Value<int?> actualSeconds,
      Value<int?> restSecondsTaken,
      Value<bool> skipped,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

final class $$WorkoutSetRowsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetRowsTable, WorkoutSetRow> {
  $$WorkoutSetRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionRowsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessionRows
      .createAlias('workout_set_rows__session_id__workout_session_rows__id');

  $$WorkoutSessionRowsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionRowsTableTableManager(
      $_db,
      $_db.workoutSessionRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutSessionExerciseRowsTable _sessionExerciseIdTable(
    _$AppDatabase db,
  ) => db.workoutSessionExerciseRows.createAlias(
    'workout_set_rows__session_exercise_id__workout_session_exercise_rows__id',
  );

  $$WorkoutSessionExerciseRowsTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<String>('session_exercise_id')!;

    final manager = $$WorkoutSessionExerciseRowsTableTableManager(
      $_db,
      $_db.workoutSessionExerciseRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetRowsTable> {
  $$WorkoutSetRowsTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualSeconds => $composableBuilder(
    column: $table.actualSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSecondsTaken => $composableBuilder(
    column: $table.restSecondsTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionRowsTableFilterComposer get sessionId {
    final $$WorkoutSessionRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessionRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionRowsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutSessionExerciseRowsTableFilterComposer get sessionExerciseId {
    final $$WorkoutSessionExerciseRowsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.workoutSessionExerciseRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExerciseRowsTableFilterComposer(
                $db: $db,
                $table: $db.workoutSessionExerciseRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetRowsTable> {
  $$WorkoutSetRowsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualSeconds => $composableBuilder(
    column: $table.actualSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSecondsTaken => $composableBuilder(
    column: $table.restSecondsTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionRowsTableOrderingComposer get sessionId {
    final $$WorkoutSessionRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessionRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionRowsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutSessionExerciseRowsTableOrderingComposer get sessionExerciseId {
    final $$WorkoutSessionExerciseRowsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.workoutSessionExerciseRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExerciseRowsTableOrderingComposer(
                $db: $db,
                $table: $db.workoutSessionExerciseRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetRowsTable> {
  $$WorkoutSetRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualSeconds => $composableBuilder(
    column: $table.actualSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSecondsTaken => $composableBuilder(
    column: $table.restSecondsTaken,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$WorkoutSessionRowsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.workoutSessionRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSessionRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$WorkoutSessionExerciseRowsTableAnnotationComposer get sessionExerciseId {
    final $$WorkoutSessionExerciseRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.workoutSessionExerciseRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExerciseRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSessionExerciseRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetRowsTable,
          WorkoutSetRow,
          $$WorkoutSetRowsTableFilterComposer,
          $$WorkoutSetRowsTableOrderingComposer,
          $$WorkoutSetRowsTableAnnotationComposer,
          $$WorkoutSetRowsTableCreateCompanionBuilder,
          $$WorkoutSetRowsTableUpdateCompanionBuilder,
          (WorkoutSetRow, $$WorkoutSetRowsTableReferences),
          WorkoutSetRow,
          PrefetchHooks Function({bool sessionId, bool sessionExerciseId})
        > {
  $$WorkoutSetRowsTableTableManager(
    _$AppDatabase db,
    $WorkoutSetRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> sessionExerciseId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<int?> targetReps = const Value.absent(),
                Value<int?> actualReps = const Value.absent(),
                Value<int?> targetSeconds = const Value.absent(),
                Value<int?> actualSeconds = const Value.absent(),
                Value<int?> restSecondsTaken = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetRowsCompanion(
                id: id,
                sessionId: sessionId,
                sessionExerciseId: sessionExerciseId,
                exerciseId: exerciseId,
                setIndex: setIndex,
                targetReps: targetReps,
                actualReps: actualReps,
                targetSeconds: targetSeconds,
                actualSeconds: actualSeconds,
                restSecondsTaken: restSecondsTaken,
                skipped: skipped,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String sessionExerciseId,
                required String exerciseId,
                required int setIndex,
                Value<int?> targetReps = const Value.absent(),
                Value<int?> actualReps = const Value.absent(),
                Value<int?> targetSeconds = const Value.absent(),
                Value<int?> actualSeconds = const Value.absent(),
                Value<int?> restSecondsTaken = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetRowsCompanion.insert(
                id: id,
                sessionId: sessionId,
                sessionExerciseId: sessionExerciseId,
                exerciseId: exerciseId,
                setIndex: setIndex,
                targetReps: targetReps,
                actualReps: actualReps,
                targetSeconds: targetSeconds,
                actualSeconds: actualSeconds,
                restSecondsTaken: restSecondsTaken,
                skipped: skipped,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetRowsTable, WorkoutSetRow>(table),
                  $$WorkoutSetRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, sessionExerciseId = false}) {
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
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$WorkoutSetRowsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$WorkoutSetRowsTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (sessionExerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionExerciseId,
                            referencedTable: $$WorkoutSetRowsTableReferences
                                ._sessionExerciseIdTable(db),
                            referencedColumn: $$WorkoutSetRowsTableReferences
                                ._sessionExerciseIdTable(db)
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

typedef $$WorkoutSetRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetRowsTable,
      WorkoutSetRow,
      $$WorkoutSetRowsTableFilterComposer,
      $$WorkoutSetRowsTableOrderingComposer,
      $$WorkoutSetRowsTableAnnotationComposer,
      $$WorkoutSetRowsTableCreateCompanionBuilder,
      $$WorkoutSetRowsTableUpdateCompanionBuilder,
      (WorkoutSetRow, $$WorkoutSetRowsTableReferences),
      WorkoutSetRow,
      PrefetchHooks Function({bool sessionId, bool sessionExerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfileRowsTableTableManager get profileRows =>
      $$ProfileRowsTableTableManager(_db, _db.profileRows);
  $$AssessmentRowsTableTableManager get assessmentRows =>
      $$AssessmentRowsTableTableManager(_db, _db.assessmentRows);
  $$WorkoutSessionRowsTableTableManager get workoutSessionRows =>
      $$WorkoutSessionRowsTableTableManager(_db, _db.workoutSessionRows);
  $$WorkoutSessionExerciseRowsTableTableManager
  get workoutSessionExerciseRows =>
      $$WorkoutSessionExerciseRowsTableTableManager(
        _db,
        _db.workoutSessionExerciseRows,
      );
  $$WorkoutSetRowsTableTableManager get workoutSetRows =>
      $$WorkoutSetRowsTableTableManager(_db, _db.workoutSetRows);
}
