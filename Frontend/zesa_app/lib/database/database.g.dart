// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PowerHistoryTable extends PowerHistory
    with TableInfo<$PowerHistoryTable, PowerHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PowerHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIDMeta = const VerificationMeta('userID');
  @override
  late final GeneratedColumn<String> userID = GeneratedColumn<String>(
    'user_i_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generationValueMeta = const VerificationMeta(
    'generationValue',
  );
  @override
  late final GeneratedColumn<double> generationValue = GeneratedColumn<double>(
    'generation_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumptionValueMeta = const VerificationMeta(
    'consumptionValue',
  );
  @override
  late final GeneratedColumn<double> consumptionValue = GeneratedColumn<double>(
    'consumption_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userID,
    timestamp,
    generationValue,
    consumptionValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'power_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PowerHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_i_d')) {
      context.handle(
        _userIDMeta,
        userID.isAcceptableOrUnknown(data['user_i_d']!, _userIDMeta),
      );
    } else if (isInserting) {
      context.missing(_userIDMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('generation_value')) {
      context.handle(
        _generationValueMeta,
        generationValue.isAcceptableOrUnknown(
          data['generation_value']!,
          _generationValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generationValueMeta);
    }
    if (data.containsKey('consumption_value')) {
      context.handle(
        _consumptionValueMeta,
        consumptionValue.isAcceptableOrUnknown(
          data['consumption_value']!,
          _consumptionValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consumptionValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PowerHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PowerHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_i_d'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      generationValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}generation_value'],
      )!,
      consumptionValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consumption_value'],
      )!,
    );
  }

  @override
  $PowerHistoryTable createAlias(String alias) {
    return $PowerHistoryTable(attachedDatabase, alias);
  }
}

class PowerHistoryData extends DataClass
    implements Insertable<PowerHistoryData> {
  final int id;
  final String userID;
  final DateTime timestamp;
  final double generationValue;
  final double consumptionValue;
  const PowerHistoryData({
    required this.id,
    required this.userID,
    required this.timestamp,
    required this.generationValue,
    required this.consumptionValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_i_d'] = Variable<String>(userID);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['generation_value'] = Variable<double>(generationValue);
    map['consumption_value'] = Variable<double>(consumptionValue);
    return map;
  }

  PowerHistoryCompanion toCompanion(bool nullToAbsent) {
    return PowerHistoryCompanion(
      id: Value(id),
      userID: Value(userID),
      timestamp: Value(timestamp),
      generationValue: Value(generationValue),
      consumptionValue: Value(consumptionValue),
    );
  }

  factory PowerHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PowerHistoryData(
      id: serializer.fromJson<int>(json['id']),
      userID: serializer.fromJson<String>(json['userID']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      generationValue: serializer.fromJson<double>(json['generationValue']),
      consumptionValue: serializer.fromJson<double>(json['consumptionValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userID': serializer.toJson<String>(userID),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'generationValue': serializer.toJson<double>(generationValue),
      'consumptionValue': serializer.toJson<double>(consumptionValue),
    };
  }

  PowerHistoryData copyWith({
    int? id,
    String? userID,
    DateTime? timestamp,
    double? generationValue,
    double? consumptionValue,
  }) => PowerHistoryData(
    id: id ?? this.id,
    userID: userID ?? this.userID,
    timestamp: timestamp ?? this.timestamp,
    generationValue: generationValue ?? this.generationValue,
    consumptionValue: consumptionValue ?? this.consumptionValue,
  );
  PowerHistoryData copyWithCompanion(PowerHistoryCompanion data) {
    return PowerHistoryData(
      id: data.id.present ? data.id.value : this.id,
      userID: data.userID.present ? data.userID.value : this.userID,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      generationValue: data.generationValue.present
          ? data.generationValue.value
          : this.generationValue,
      consumptionValue: data.consumptionValue.present
          ? data.consumptionValue.value
          : this.consumptionValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PowerHistoryData(')
          ..write('id: $id, ')
          ..write('userID: $userID, ')
          ..write('timestamp: $timestamp, ')
          ..write('generationValue: $generationValue, ')
          ..write('consumptionValue: $consumptionValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userID, timestamp, generationValue, consumptionValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PowerHistoryData &&
          other.id == this.id &&
          other.userID == this.userID &&
          other.timestamp == this.timestamp &&
          other.generationValue == this.generationValue &&
          other.consumptionValue == this.consumptionValue);
}

class PowerHistoryCompanion extends UpdateCompanion<PowerHistoryData> {
  final Value<int> id;
  final Value<String> userID;
  final Value<DateTime> timestamp;
  final Value<double> generationValue;
  final Value<double> consumptionValue;
  const PowerHistoryCompanion({
    this.id = const Value.absent(),
    this.userID = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.generationValue = const Value.absent(),
    this.consumptionValue = const Value.absent(),
  });
  PowerHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String userID,
    required DateTime timestamp,
    required double generationValue,
    required double consumptionValue,
  }) : userID = Value(userID),
       timestamp = Value(timestamp),
       generationValue = Value(generationValue),
       consumptionValue = Value(consumptionValue);
  static Insertable<PowerHistoryData> custom({
    Expression<int>? id,
    Expression<String>? userID,
    Expression<DateTime>? timestamp,
    Expression<double>? generationValue,
    Expression<double>? consumptionValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userID != null) 'user_i_d': userID,
      if (timestamp != null) 'timestamp': timestamp,
      if (generationValue != null) 'generation_value': generationValue,
      if (consumptionValue != null) 'consumption_value': consumptionValue,
    });
  }

  PowerHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? userID,
    Value<DateTime>? timestamp,
    Value<double>? generationValue,
    Value<double>? consumptionValue,
  }) {
    return PowerHistoryCompanion(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      timestamp: timestamp ?? this.timestamp,
      generationValue: generationValue ?? this.generationValue,
      consumptionValue: consumptionValue ?? this.consumptionValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userID.present) {
      map['user_i_d'] = Variable<String>(userID.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (generationValue.present) {
      map['generation_value'] = Variable<double>(generationValue.value);
    }
    if (consumptionValue.present) {
      map['consumption_value'] = Variable<double>(consumptionValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PowerHistoryCompanion(')
          ..write('id: $id, ')
          ..write('userID: $userID, ')
          ..write('timestamp: $timestamp, ')
          ..write('generationValue: $generationValue, ')
          ..write('consumptionValue: $consumptionValue')
          ..write(')'))
        .toString();
  }
}

class $SummaryTableTable extends SummaryTable
    with TableInfo<$SummaryTableTable, SummaryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SummaryTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIDMeta = const VerificationMeta('userID');
  @override
  late final GeneratedColumn<String> userID = GeneratedColumn<String>(
    'user_i_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalGenerationMeta = const VerificationMeta(
    'totalGeneration',
  );
  @override
  late final GeneratedColumn<double> totalGeneration = GeneratedColumn<double>(
    'total_generation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalConsumptionMeta = const VerificationMeta(
    'totalConsumption',
  );
  @override
  late final GeneratedColumn<double> totalConsumption = GeneratedColumn<double>(
    'total_consumption',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userID,
    periodStart,
    periodEnd,
    totalGeneration,
    totalConsumption,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'summary_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SummaryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_i_d')) {
      context.handle(
        _userIDMeta,
        userID.isAcceptableOrUnknown(data['user_i_d']!, _userIDMeta),
      );
    } else if (isInserting) {
      context.missing(_userIDMeta);
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('total_generation')) {
      context.handle(
        _totalGenerationMeta,
        totalGeneration.isAcceptableOrUnknown(
          data['total_generation']!,
          _totalGenerationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalGenerationMeta);
    }
    if (data.containsKey('total_consumption')) {
      context.handle(
        _totalConsumptionMeta,
        totalConsumption.isAcceptableOrUnknown(
          data['total_consumption']!,
          _totalConsumptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalConsumptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SummaryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SummaryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_i_d'],
      )!,
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start'],
      )!,
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end'],
      )!,
      totalGeneration: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_generation'],
      )!,
      totalConsumption: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_consumption'],
      )!,
    );
  }

  @override
  $SummaryTableTable createAlias(String alias) {
    return $SummaryTableTable(attachedDatabase, alias);
  }
}

class SummaryTableData extends DataClass
    implements Insertable<SummaryTableData> {
  final int id;
  final String userID;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalGeneration;
  final double totalConsumption;
  const SummaryTableData({
    required this.id,
    required this.userID,
    required this.periodStart,
    required this.periodEnd,
    required this.totalGeneration,
    required this.totalConsumption,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_i_d'] = Variable<String>(userID);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['total_generation'] = Variable<double>(totalGeneration);
    map['total_consumption'] = Variable<double>(totalConsumption);
    return map;
  }

  SummaryTableCompanion toCompanion(bool nullToAbsent) {
    return SummaryTableCompanion(
      id: Value(id),
      userID: Value(userID),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      totalGeneration: Value(totalGeneration),
      totalConsumption: Value(totalConsumption),
    );
  }

  factory SummaryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SummaryTableData(
      id: serializer.fromJson<int>(json['id']),
      userID: serializer.fromJson<String>(json['userID']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      totalGeneration: serializer.fromJson<double>(json['totalGeneration']),
      totalConsumption: serializer.fromJson<double>(json['totalConsumption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userID': serializer.toJson<String>(userID),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'totalGeneration': serializer.toJson<double>(totalGeneration),
      'totalConsumption': serializer.toJson<double>(totalConsumption),
    };
  }

  SummaryTableData copyWith({
    int? id,
    String? userID,
    DateTime? periodStart,
    DateTime? periodEnd,
    double? totalGeneration,
    double? totalConsumption,
  }) => SummaryTableData(
    id: id ?? this.id,
    userID: userID ?? this.userID,
    periodStart: periodStart ?? this.periodStart,
    periodEnd: periodEnd ?? this.periodEnd,
    totalGeneration: totalGeneration ?? this.totalGeneration,
    totalConsumption: totalConsumption ?? this.totalConsumption,
  );
  SummaryTableData copyWithCompanion(SummaryTableCompanion data) {
    return SummaryTableData(
      id: data.id.present ? data.id.value : this.id,
      userID: data.userID.present ? data.userID.value : this.userID,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      totalGeneration: data.totalGeneration.present
          ? data.totalGeneration.value
          : this.totalGeneration,
      totalConsumption: data.totalConsumption.present
          ? data.totalConsumption.value
          : this.totalConsumption,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SummaryTableData(')
          ..write('id: $id, ')
          ..write('userID: $userID, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('totalGeneration: $totalGeneration, ')
          ..write('totalConsumption: $totalConsumption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userID,
    periodStart,
    periodEnd,
    totalGeneration,
    totalConsumption,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SummaryTableData &&
          other.id == this.id &&
          other.userID == this.userID &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.totalGeneration == this.totalGeneration &&
          other.totalConsumption == this.totalConsumption);
}

class SummaryTableCompanion extends UpdateCompanion<SummaryTableData> {
  final Value<int> id;
  final Value<String> userID;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<double> totalGeneration;
  final Value<double> totalConsumption;
  const SummaryTableCompanion({
    this.id = const Value.absent(),
    this.userID = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.totalGeneration = const Value.absent(),
    this.totalConsumption = const Value.absent(),
  });
  SummaryTableCompanion.insert({
    this.id = const Value.absent(),
    required String userID,
    required DateTime periodStart,
    required DateTime periodEnd,
    required double totalGeneration,
    required double totalConsumption,
  }) : userID = Value(userID),
       periodStart = Value(periodStart),
       periodEnd = Value(periodEnd),
       totalGeneration = Value(totalGeneration),
       totalConsumption = Value(totalConsumption);
  static Insertable<SummaryTableData> custom({
    Expression<int>? id,
    Expression<String>? userID,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<double>? totalGeneration,
    Expression<double>? totalConsumption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userID != null) 'user_i_d': userID,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (totalGeneration != null) 'total_generation': totalGeneration,
      if (totalConsumption != null) 'total_consumption': totalConsumption,
    });
  }

  SummaryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userID,
    Value<DateTime>? periodStart,
    Value<DateTime>? periodEnd,
    Value<double>? totalGeneration,
    Value<double>? totalConsumption,
  }) {
    return SummaryTableCompanion(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      totalGeneration: totalGeneration ?? this.totalGeneration,
      totalConsumption: totalConsumption ?? this.totalConsumption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userID.present) {
      map['user_i_d'] = Variable<String>(userID.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (totalGeneration.present) {
      map['total_generation'] = Variable<double>(totalGeneration.value);
    }
    if (totalConsumption.present) {
      map['total_consumption'] = Variable<double>(totalConsumption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SummaryTableCompanion(')
          ..write('id: $id, ')
          ..write('userID: $userID, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('totalGeneration: $totalGeneration, ')
          ..write('totalConsumption: $totalConsumption')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIDMeta = const VerificationMeta('userID');
  @override
  late final GeneratedColumn<String> userID = GeneratedColumn<String>(
    'user_i_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userRoleMeta = const VerificationMeta(
    'userRole',
  );
  @override
  late final GeneratedColumn<String> userRole = GeneratedColumn<String>(
    'user_role',
    aliasedName,
    false,
    check: () => userRole.isIn(['admin', 'prosumer', 'consumer']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userID,
    name,
    email,
    password,
    userRole,
    phoneNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_i_d')) {
      context.handle(
        _userIDMeta,
        userID.isAcceptableOrUnknown(data['user_i_d']!, _userIDMeta),
      );
    } else if (isInserting) {
      context.missing(_userIDMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('user_role')) {
      context.handle(
        _userRoleMeta,
        userRole.isAcceptableOrUnknown(data['user_role']!, _userRoleMeta),
      );
    } else if (isInserting) {
      context.missing(_userRoleMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_i_d'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      userRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_role'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final int id;
  final String userID;
  final String name;
  final String email;
  final String password;
  final String userRole;
  final String phoneNumber;
  const UserTableData({
    required this.id,
    required this.userID,
    required this.name,
    required this.email,
    required this.password,
    required this.userRole,
    required this.phoneNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_i_d'] = Variable<String>(userID);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['user_role'] = Variable<String>(userRole);
    map['phone_number'] = Variable<String>(phoneNumber);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      userID: Value(userID),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      userRole: Value(userRole),
      phoneNumber: Value(phoneNumber),
    );
  }

  factory UserTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<int>(json['id']),
      userID: serializer.fromJson<String>(json['userID']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      userRole: serializer.fromJson<String>(json['userRole']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userID': serializer.toJson<String>(userID),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'userRole': serializer.toJson<String>(userRole),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
    };
  }

  UserTableData copyWith({
    int? id,
    String? userID,
    String? name,
    String? email,
    String? password,
    String? userRole,
    String? phoneNumber,
  }) => UserTableData(
    id: id ?? this.id,
    userID: userID ?? this.userID,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    userRole: userRole ?? this.userRole,
    phoneNumber: phoneNumber ?? this.phoneNumber,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      userID: data.userID.present ? data.userID.value : this.userID,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      userRole: data.userRole.present ? data.userRole.value : this.userRole,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('userID: $userID, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('userRole: $userRole, ')
          ..write('phoneNumber: $phoneNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userID, name, email, password, userRole, phoneNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.userID == this.userID &&
          other.name == this.name &&
          other.email == this.email &&
          other.password == this.password &&
          other.userRole == this.userRole &&
          other.phoneNumber == this.phoneNumber);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<int> id;
  final Value<String> userID;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> userRole;
  final Value<String> phoneNumber;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.userID = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.userRole = const Value.absent(),
    this.phoneNumber = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String userID,
    required String name,
    required String email,
    required String password,
    required String userRole,
    required String phoneNumber,
  }) : userID = Value(userID),
       name = Value(name),
       email = Value(email),
       password = Value(password),
       userRole = Value(userRole),
       phoneNumber = Value(phoneNumber);
  static Insertable<UserTableData> custom({
    Expression<int>? id,
    Expression<String>? userID,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? userRole,
    Expression<String>? phoneNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userID != null) 'user_i_d': userID,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (userRole != null) 'user_role': userRole,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    });
  }

  UserTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userID,
    Value<String>? name,
    Value<String>? email,
    Value<String>? password,
    Value<String>? userRole,
    Value<String>? phoneNumber,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userRole: userRole ?? this.userRole,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userID.present) {
      map['user_i_d'] = Variable<String>(userID.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (userRole.present) {
      map['user_role'] = Variable<String>(userRole.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('userID: $userID, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('userRole: $userRole, ')
          ..write('phoneNumber: $phoneNumber')
          ..write(')'))
        .toString();
  }
}

class $SystemInfoTable extends SystemInfo
    with TableInfo<$SystemInfoTable, SystemInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _systemIDMeta = const VerificationMeta(
    'systemID',
  );
  @override
  late final GeneratedColumn<String> systemID = GeneratedColumn<String>(
    'system_i_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES user_table(user_id)',
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _panelCountMeta = const VerificationMeta(
    'panelCount',
  );
  @override
  late final GeneratedColumn<int> panelCount = GeneratedColumn<int>(
    'panel_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _panelCapacityMeta = const VerificationMeta(
    'panelCapacity',
  );
  @override
  late final GeneratedColumn<double> panelCapacity = GeneratedColumn<double>(
    'panel_capacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batteryCapacityMeta = const VerificationMeta(
    'batteryCapacity',
  );
  @override
  late final GeneratedColumn<double> batteryCapacity = GeneratedColumn<double>(
    'battery_capacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inverterCapacityMeta = const VerificationMeta(
    'inverterCapacity',
  );
  @override
  late final GeneratedColumn<double> inverterCapacity = GeneratedColumn<double>(
    'inverter_capacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    systemID,
    location,
    panelCount,
    panelCapacity,
    batteryCapacity,
    inverterCapacity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<SystemInfoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('system_i_d')) {
      context.handle(
        _systemIDMeta,
        systemID.isAcceptableOrUnknown(data['system_i_d']!, _systemIDMeta),
      );
    } else if (isInserting) {
      context.missing(_systemIDMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('panel_count')) {
      context.handle(
        _panelCountMeta,
        panelCount.isAcceptableOrUnknown(data['panel_count']!, _panelCountMeta),
      );
    } else if (isInserting) {
      context.missing(_panelCountMeta);
    }
    if (data.containsKey('panel_capacity')) {
      context.handle(
        _panelCapacityMeta,
        panelCapacity.isAcceptableOrUnknown(
          data['panel_capacity']!,
          _panelCapacityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_panelCapacityMeta);
    }
    if (data.containsKey('battery_capacity')) {
      context.handle(
        _batteryCapacityMeta,
        batteryCapacity.isAcceptableOrUnknown(
          data['battery_capacity']!,
          _batteryCapacityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batteryCapacityMeta);
    }
    if (data.containsKey('inverter_capacity')) {
      context.handle(
        _inverterCapacityMeta,
        inverterCapacity.isAcceptableOrUnknown(
          data['inverter_capacity']!,
          _inverterCapacityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inverterCapacityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SystemInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemInfoData(
      systemID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_i_d'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      panelCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}panel_count'],
      )!,
      panelCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}panel_capacity'],
      )!,
      batteryCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}battery_capacity'],
      )!,
      inverterCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}inverter_capacity'],
      )!,
    );
  }

  @override
  $SystemInfoTable createAlias(String alias) {
    return $SystemInfoTable(attachedDatabase, alias);
  }
}

class SystemInfoData extends DataClass implements Insertable<SystemInfoData> {
  final String systemID;
  final String location;
  final int panelCount;
  final double panelCapacity;
  final double batteryCapacity;
  final double inverterCapacity;
  const SystemInfoData({
    required this.systemID,
    required this.location,
    required this.panelCount,
    required this.panelCapacity,
    required this.batteryCapacity,
    required this.inverterCapacity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['system_i_d'] = Variable<String>(systemID);
    map['location'] = Variable<String>(location);
    map['panel_count'] = Variable<int>(panelCount);
    map['panel_capacity'] = Variable<double>(panelCapacity);
    map['battery_capacity'] = Variable<double>(batteryCapacity);
    map['inverter_capacity'] = Variable<double>(inverterCapacity);
    return map;
  }

  SystemInfoCompanion toCompanion(bool nullToAbsent) {
    return SystemInfoCompanion(
      systemID: Value(systemID),
      location: Value(location),
      panelCount: Value(panelCount),
      panelCapacity: Value(panelCapacity),
      batteryCapacity: Value(batteryCapacity),
      inverterCapacity: Value(inverterCapacity),
    );
  }

  factory SystemInfoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemInfoData(
      systemID: serializer.fromJson<String>(json['systemID']),
      location: serializer.fromJson<String>(json['location']),
      panelCount: serializer.fromJson<int>(json['panelCount']),
      panelCapacity: serializer.fromJson<double>(json['panelCapacity']),
      batteryCapacity: serializer.fromJson<double>(json['batteryCapacity']),
      inverterCapacity: serializer.fromJson<double>(json['inverterCapacity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'systemID': serializer.toJson<String>(systemID),
      'location': serializer.toJson<String>(location),
      'panelCount': serializer.toJson<int>(panelCount),
      'panelCapacity': serializer.toJson<double>(panelCapacity),
      'batteryCapacity': serializer.toJson<double>(batteryCapacity),
      'inverterCapacity': serializer.toJson<double>(inverterCapacity),
    };
  }

  SystemInfoData copyWith({
    String? systemID,
    String? location,
    int? panelCount,
    double? panelCapacity,
    double? batteryCapacity,
    double? inverterCapacity,
  }) => SystemInfoData(
    systemID: systemID ?? this.systemID,
    location: location ?? this.location,
    panelCount: panelCount ?? this.panelCount,
    panelCapacity: panelCapacity ?? this.panelCapacity,
    batteryCapacity: batteryCapacity ?? this.batteryCapacity,
    inverterCapacity: inverterCapacity ?? this.inverterCapacity,
  );
  SystemInfoData copyWithCompanion(SystemInfoCompanion data) {
    return SystemInfoData(
      systemID: data.systemID.present ? data.systemID.value : this.systemID,
      location: data.location.present ? data.location.value : this.location,
      panelCount: data.panelCount.present
          ? data.panelCount.value
          : this.panelCount,
      panelCapacity: data.panelCapacity.present
          ? data.panelCapacity.value
          : this.panelCapacity,
      batteryCapacity: data.batteryCapacity.present
          ? data.batteryCapacity.value
          : this.batteryCapacity,
      inverterCapacity: data.inverterCapacity.present
          ? data.inverterCapacity.value
          : this.inverterCapacity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemInfoData(')
          ..write('systemID: $systemID, ')
          ..write('location: $location, ')
          ..write('panelCount: $panelCount, ')
          ..write('panelCapacity: $panelCapacity, ')
          ..write('batteryCapacity: $batteryCapacity, ')
          ..write('inverterCapacity: $inverterCapacity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    systemID,
    location,
    panelCount,
    panelCapacity,
    batteryCapacity,
    inverterCapacity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemInfoData &&
          other.systemID == this.systemID &&
          other.location == this.location &&
          other.panelCount == this.panelCount &&
          other.panelCapacity == this.panelCapacity &&
          other.batteryCapacity == this.batteryCapacity &&
          other.inverterCapacity == this.inverterCapacity);
}

class SystemInfoCompanion extends UpdateCompanion<SystemInfoData> {
  final Value<String> systemID;
  final Value<String> location;
  final Value<int> panelCount;
  final Value<double> panelCapacity;
  final Value<double> batteryCapacity;
  final Value<double> inverterCapacity;
  final Value<int> rowid;
  const SystemInfoCompanion({
    this.systemID = const Value.absent(),
    this.location = const Value.absent(),
    this.panelCount = const Value.absent(),
    this.panelCapacity = const Value.absent(),
    this.batteryCapacity = const Value.absent(),
    this.inverterCapacity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemInfoCompanion.insert({
    required String systemID,
    required String location,
    required int panelCount,
    required double panelCapacity,
    required double batteryCapacity,
    required double inverterCapacity,
    this.rowid = const Value.absent(),
  }) : systemID = Value(systemID),
       location = Value(location),
       panelCount = Value(panelCount),
       panelCapacity = Value(panelCapacity),
       batteryCapacity = Value(batteryCapacity),
       inverterCapacity = Value(inverterCapacity);
  static Insertable<SystemInfoData> custom({
    Expression<String>? systemID,
    Expression<String>? location,
    Expression<int>? panelCount,
    Expression<double>? panelCapacity,
    Expression<double>? batteryCapacity,
    Expression<double>? inverterCapacity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (systemID != null) 'system_i_d': systemID,
      if (location != null) 'location': location,
      if (panelCount != null) 'panel_count': panelCount,
      if (panelCapacity != null) 'panel_capacity': panelCapacity,
      if (batteryCapacity != null) 'battery_capacity': batteryCapacity,
      if (inverterCapacity != null) 'inverter_capacity': inverterCapacity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemInfoCompanion copyWith({
    Value<String>? systemID,
    Value<String>? location,
    Value<int>? panelCount,
    Value<double>? panelCapacity,
    Value<double>? batteryCapacity,
    Value<double>? inverterCapacity,
    Value<int>? rowid,
  }) {
    return SystemInfoCompanion(
      systemID: systemID ?? this.systemID,
      location: location ?? this.location,
      panelCount: panelCount ?? this.panelCount,
      panelCapacity: panelCapacity ?? this.panelCapacity,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      inverterCapacity: inverterCapacity ?? this.inverterCapacity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (systemID.present) {
      map['system_i_d'] = Variable<String>(systemID.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (panelCount.present) {
      map['panel_count'] = Variable<int>(panelCount.value);
    }
    if (panelCapacity.present) {
      map['panel_capacity'] = Variable<double>(panelCapacity.value);
    }
    if (batteryCapacity.present) {
      map['battery_capacity'] = Variable<double>(batteryCapacity.value);
    }
    if (inverterCapacity.present) {
      map['inverter_capacity'] = Variable<double>(inverterCapacity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemInfoCompanion(')
          ..write('systemID: $systemID, ')
          ..write('location: $location, ')
          ..write('panelCount: $panelCount, ')
          ..write('panelCapacity: $panelCapacity, ')
          ..write('batteryCapacity: $batteryCapacity, ')
          ..write('inverterCapacity: $inverterCapacity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionTableTable extends TransactionTable
    with TableInfo<$TransactionTableTable, TransactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _pricePerKwhMeta = const VerificationMeta(
    'pricePerKwh',
  );
  @override
  late final GeneratedColumn<double> pricePerKwh = GeneratedColumn<double>(
    'price_per_kwh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kWhSoldMeta = const VerificationMeta(
    'kWhSold',
  );
  @override
  late final GeneratedColumn<double> kWhSold = GeneratedColumn<double>(
    'k_wh_sold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () => status.isIn(['pending', 'completed', 'failed']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _powerRawIDMeta = const VerificationMeta(
    'powerRawID',
  );
  @override
  late final GeneratedColumn<int> powerRawID = GeneratedColumn<int>(
    'power_raw_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES power_history(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionDate,
    pricePerKwh,
    totalPrice,
    kWhSold,
    status,
    powerRawID,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('price_per_kwh')) {
      context.handle(
        _pricePerKwhMeta,
        pricePerKwh.isAcceptableOrUnknown(
          data['price_per_kwh']!,
          _pricePerKwhMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerKwhMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('k_wh_sold')) {
      context.handle(
        _kWhSoldMeta,
        kWhSold.isAcceptableOrUnknown(data['k_wh_sold']!, _kWhSoldMeta),
      );
    } else if (isInserting) {
      context.missing(_kWhSoldMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('power_raw_i_d')) {
      context.handle(
        _powerRawIDMeta,
        powerRawID.isAcceptableOrUnknown(
          data['power_raw_i_d']!,
          _powerRawIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_powerRawIDMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      pricePerKwh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_kwh'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
      kWhSold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}k_wh_sold'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      powerRawID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}power_raw_i_d'],
      )!,
    );
  }

  @override
  $TransactionTableTable createAlias(String alias) {
    return $TransactionTableTable(attachedDatabase, alias);
  }
}

class TransactionTableData extends DataClass
    implements Insertable<TransactionTableData> {
  final int id;
  final DateTime transactionDate;
  final double pricePerKwh;
  final double totalPrice;
  final double kWhSold;
  final String status;
  final int powerRawID;
  const TransactionTableData({
    required this.id,
    required this.transactionDate,
    required this.pricePerKwh,
    required this.totalPrice,
    required this.kWhSold,
    required this.status,
    required this.powerRawID,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['price_per_kwh'] = Variable<double>(pricePerKwh);
    map['total_price'] = Variable<double>(totalPrice);
    map['k_wh_sold'] = Variable<double>(kWhSold);
    map['status'] = Variable<String>(status);
    map['power_raw_i_d'] = Variable<int>(powerRawID);
    return map;
  }

  TransactionTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTableCompanion(
      id: Value(id),
      transactionDate: Value(transactionDate),
      pricePerKwh: Value(pricePerKwh),
      totalPrice: Value(totalPrice),
      kWhSold: Value(kWhSold),
      status: Value(status),
      powerRawID: Value(powerRawID),
    );
  }

  factory TransactionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTableData(
      id: serializer.fromJson<int>(json['id']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      pricePerKwh: serializer.fromJson<double>(json['pricePerKwh']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      kWhSold: serializer.fromJson<double>(json['kWhSold']),
      status: serializer.fromJson<String>(json['status']),
      powerRawID: serializer.fromJson<int>(json['powerRawID']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'pricePerKwh': serializer.toJson<double>(pricePerKwh),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'kWhSold': serializer.toJson<double>(kWhSold),
      'status': serializer.toJson<String>(status),
      'powerRawID': serializer.toJson<int>(powerRawID),
    };
  }

  TransactionTableData copyWith({
    int? id,
    DateTime? transactionDate,
    double? pricePerKwh,
    double? totalPrice,
    double? kWhSold,
    String? status,
    int? powerRawID,
  }) => TransactionTableData(
    id: id ?? this.id,
    transactionDate: transactionDate ?? this.transactionDate,
    pricePerKwh: pricePerKwh ?? this.pricePerKwh,
    totalPrice: totalPrice ?? this.totalPrice,
    kWhSold: kWhSold ?? this.kWhSold,
    status: status ?? this.status,
    powerRawID: powerRawID ?? this.powerRawID,
  );
  TransactionTableData copyWithCompanion(TransactionTableCompanion data) {
    return TransactionTableData(
      id: data.id.present ? data.id.value : this.id,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      pricePerKwh: data.pricePerKwh.present
          ? data.pricePerKwh.value
          : this.pricePerKwh,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      kWhSold: data.kWhSold.present ? data.kWhSold.value : this.kWhSold,
      status: data.status.present ? data.status.value : this.status,
      powerRawID: data.powerRawID.present
          ? data.powerRawID.value
          : this.powerRawID,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableData(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('pricePerKwh: $pricePerKwh, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('kWhSold: $kWhSold, ')
          ..write('status: $status, ')
          ..write('powerRawID: $powerRawID')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionDate,
    pricePerKwh,
    totalPrice,
    kWhSold,
    status,
    powerRawID,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTableData &&
          other.id == this.id &&
          other.transactionDate == this.transactionDate &&
          other.pricePerKwh == this.pricePerKwh &&
          other.totalPrice == this.totalPrice &&
          other.kWhSold == this.kWhSold &&
          other.status == this.status &&
          other.powerRawID == this.powerRawID);
}

class TransactionTableCompanion extends UpdateCompanion<TransactionTableData> {
  final Value<int> id;
  final Value<DateTime> transactionDate;
  final Value<double> pricePerKwh;
  final Value<double> totalPrice;
  final Value<double> kWhSold;
  final Value<String> status;
  final Value<int> powerRawID;
  const TransactionTableCompanion({
    this.id = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.pricePerKwh = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.kWhSold = const Value.absent(),
    this.status = const Value.absent(),
    this.powerRawID = const Value.absent(),
  });
  TransactionTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime transactionDate,
    required double pricePerKwh,
    required double totalPrice,
    required double kWhSold,
    required String status,
    required int powerRawID,
  }) : transactionDate = Value(transactionDate),
       pricePerKwh = Value(pricePerKwh),
       totalPrice = Value(totalPrice),
       kWhSold = Value(kWhSold),
       status = Value(status),
       powerRawID = Value(powerRawID);
  static Insertable<TransactionTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? transactionDate,
    Expression<double>? pricePerKwh,
    Expression<double>? totalPrice,
    Expression<double>? kWhSold,
    Expression<String>? status,
    Expression<int>? powerRawID,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (pricePerKwh != null) 'price_per_kwh': pricePerKwh,
      if (totalPrice != null) 'total_price': totalPrice,
      if (kWhSold != null) 'k_wh_sold': kWhSold,
      if (status != null) 'status': status,
      if (powerRawID != null) 'power_raw_i_d': powerRawID,
    });
  }

  TransactionTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? transactionDate,
    Value<double>? pricePerKwh,
    Value<double>? totalPrice,
    Value<double>? kWhSold,
    Value<String>? status,
    Value<int>? powerRawID,
  }) {
    return TransactionTableCompanion(
      id: id ?? this.id,
      transactionDate: transactionDate ?? this.transactionDate,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      totalPrice: totalPrice ?? this.totalPrice,
      kWhSold: kWhSold ?? this.kWhSold,
      status: status ?? this.status,
      powerRawID: powerRawID ?? this.powerRawID,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (pricePerKwh.present) {
      map['price_per_kwh'] = Variable<double>(pricePerKwh.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (kWhSold.present) {
      map['k_wh_sold'] = Variable<double>(kWhSold.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (powerRawID.present) {
      map['power_raw_i_d'] = Variable<int>(powerRawID.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableCompanion(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('pricePerKwh: $pricePerKwh, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('kWhSold: $kWhSold, ')
          ..write('status: $status, ')
          ..write('powerRawID: $powerRawID')
          ..write(')'))
        .toString();
  }
}

class $RecentBlocksTable extends RecentBlocks
    with TableInfo<$RecentBlocksTable, RecentBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentBlocksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockHashMeta = const VerificationMeta(
    'blockHash',
  );
  @override
  late final GeneratedColumn<String> blockHash = GeneratedColumn<String>(
    'block_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _previousHashMeta = const VerificationMeta(
    'previousHash',
  );
  @override
  late final GeneratedColumn<String> previousHash = GeneratedColumn<String>(
    'previous_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merkleRootMeta = const VerificationMeta(
    'merkleRoot',
  );
  @override
  late final GeneratedColumn<String> merkleRoot = GeneratedColumn<String>(
    'merkle_root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionCountMeta = const VerificationMeta(
    'transactionCount',
  );
  @override
  late final GeneratedColumn<int> transactionCount = GeneratedColumn<int>(
    'transaction_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockHash,
    previousHash,
    merkleRoot,
    height,
    timestamp,
    transactionCount,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_hash')) {
      context.handle(
        _blockHashMeta,
        blockHash.isAcceptableOrUnknown(data['block_hash']!, _blockHashMeta),
      );
    } else if (isInserting) {
      context.missing(_blockHashMeta);
    }
    if (data.containsKey('previous_hash')) {
      context.handle(
        _previousHashMeta,
        previousHash.isAcceptableOrUnknown(
          data['previous_hash']!,
          _previousHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousHashMeta);
    }
    if (data.containsKey('merkle_root')) {
      context.handle(
        _merkleRootMeta,
        merkleRoot.isAcceptableOrUnknown(data['merkle_root']!, _merkleRootMeta),
      );
    } else if (isInserting) {
      context.missing(_merkleRootMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('transaction_count')) {
      context.handle(
        _transactionCountMeta,
        transactionCount.isAcceptableOrUnknown(
          data['transaction_count']!,
          _transactionCountMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentBlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}block_hash'],
      )!,
      previousHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_hash'],
      )!,
      merkleRoot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merkle_root'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      transactionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_count'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
    );
  }

  @override
  $RecentBlocksTable createAlias(String alias) {
    return $RecentBlocksTable(attachedDatabase, alias);
  }
}

class RecentBlock extends DataClass implements Insertable<RecentBlock> {
  final int id;
  final String blockHash;
  final String previousHash;
  final String merkleRoot;
  final int height;
  final DateTime timestamp;
  final int? transactionCount;
  final String? source;
  const RecentBlock({
    required this.id,
    required this.blockHash,
    required this.previousHash,
    required this.merkleRoot,
    required this.height,
    required this.timestamp,
    this.transactionCount,
    this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_hash'] = Variable<String>(blockHash);
    map['previous_hash'] = Variable<String>(previousHash);
    map['merkle_root'] = Variable<String>(merkleRoot);
    map['height'] = Variable<int>(height);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || transactionCount != null) {
      map['transaction_count'] = Variable<int>(transactionCount);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    return map;
  }

  RecentBlocksCompanion toCompanion(bool nullToAbsent) {
    return RecentBlocksCompanion(
      id: Value(id),
      blockHash: Value(blockHash),
      previousHash: Value(previousHash),
      merkleRoot: Value(merkleRoot),
      height: Value(height),
      timestamp: Value(timestamp),
      transactionCount: transactionCount == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionCount),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
    );
  }

  factory RecentBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentBlock(
      id: serializer.fromJson<int>(json['id']),
      blockHash: serializer.fromJson<String>(json['blockHash']),
      previousHash: serializer.fromJson<String>(json['previousHash']),
      merkleRoot: serializer.fromJson<String>(json['merkleRoot']),
      height: serializer.fromJson<int>(json['height']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      transactionCount: serializer.fromJson<int?>(json['transactionCount']),
      source: serializer.fromJson<String?>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockHash': serializer.toJson<String>(blockHash),
      'previousHash': serializer.toJson<String>(previousHash),
      'merkleRoot': serializer.toJson<String>(merkleRoot),
      'height': serializer.toJson<int>(height),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'transactionCount': serializer.toJson<int?>(transactionCount),
      'source': serializer.toJson<String?>(source),
    };
  }

  RecentBlock copyWith({
    int? id,
    String? blockHash,
    String? previousHash,
    String? merkleRoot,
    int? height,
    DateTime? timestamp,
    Value<int?> transactionCount = const Value.absent(),
    Value<String?> source = const Value.absent(),
  }) => RecentBlock(
    id: id ?? this.id,
    blockHash: blockHash ?? this.blockHash,
    previousHash: previousHash ?? this.previousHash,
    merkleRoot: merkleRoot ?? this.merkleRoot,
    height: height ?? this.height,
    timestamp: timestamp ?? this.timestamp,
    transactionCount: transactionCount.present
        ? transactionCount.value
        : this.transactionCount,
    source: source.present ? source.value : this.source,
  );
  RecentBlock copyWithCompanion(RecentBlocksCompanion data) {
    return RecentBlock(
      id: data.id.present ? data.id.value : this.id,
      blockHash: data.blockHash.present ? data.blockHash.value : this.blockHash,
      previousHash: data.previousHash.present
          ? data.previousHash.value
          : this.previousHash,
      merkleRoot: data.merkleRoot.present
          ? data.merkleRoot.value
          : this.merkleRoot,
      height: data.height.present ? data.height.value : this.height,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      transactionCount: data.transactionCount.present
          ? data.transactionCount.value
          : this.transactionCount,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentBlock(')
          ..write('id: $id, ')
          ..write('blockHash: $blockHash, ')
          ..write('previousHash: $previousHash, ')
          ..write('merkleRoot: $merkleRoot, ')
          ..write('height: $height, ')
          ..write('timestamp: $timestamp, ')
          ..write('transactionCount: $transactionCount, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    blockHash,
    previousHash,
    merkleRoot,
    height,
    timestamp,
    transactionCount,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentBlock &&
          other.id == this.id &&
          other.blockHash == this.blockHash &&
          other.previousHash == this.previousHash &&
          other.merkleRoot == this.merkleRoot &&
          other.height == this.height &&
          other.timestamp == this.timestamp &&
          other.transactionCount == this.transactionCount &&
          other.source == this.source);
}

class RecentBlocksCompanion extends UpdateCompanion<RecentBlock> {
  final Value<int> id;
  final Value<String> blockHash;
  final Value<String> previousHash;
  final Value<String> merkleRoot;
  final Value<int> height;
  final Value<DateTime> timestamp;
  final Value<int?> transactionCount;
  final Value<String?> source;
  const RecentBlocksCompanion({
    this.id = const Value.absent(),
    this.blockHash = const Value.absent(),
    this.previousHash = const Value.absent(),
    this.merkleRoot = const Value.absent(),
    this.height = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.transactionCount = const Value.absent(),
    this.source = const Value.absent(),
  });
  RecentBlocksCompanion.insert({
    this.id = const Value.absent(),
    required String blockHash,
    required String previousHash,
    required String merkleRoot,
    required int height,
    required DateTime timestamp,
    this.transactionCount = const Value.absent(),
    this.source = const Value.absent(),
  }) : blockHash = Value(blockHash),
       previousHash = Value(previousHash),
       merkleRoot = Value(merkleRoot),
       height = Value(height),
       timestamp = Value(timestamp);
  static Insertable<RecentBlock> custom({
    Expression<int>? id,
    Expression<String>? blockHash,
    Expression<String>? previousHash,
    Expression<String>? merkleRoot,
    Expression<int>? height,
    Expression<DateTime>? timestamp,
    Expression<int>? transactionCount,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockHash != null) 'block_hash': blockHash,
      if (previousHash != null) 'previous_hash': previousHash,
      if (merkleRoot != null) 'merkle_root': merkleRoot,
      if (height != null) 'height': height,
      if (timestamp != null) 'timestamp': timestamp,
      if (transactionCount != null) 'transaction_count': transactionCount,
      if (source != null) 'source': source,
    });
  }

  RecentBlocksCompanion copyWith({
    Value<int>? id,
    Value<String>? blockHash,
    Value<String>? previousHash,
    Value<String>? merkleRoot,
    Value<int>? height,
    Value<DateTime>? timestamp,
    Value<int?>? transactionCount,
    Value<String?>? source,
  }) {
    return RecentBlocksCompanion(
      id: id ?? this.id,
      blockHash: blockHash ?? this.blockHash,
      previousHash: previousHash ?? this.previousHash,
      merkleRoot: merkleRoot ?? this.merkleRoot,
      height: height ?? this.height,
      timestamp: timestamp ?? this.timestamp,
      transactionCount: transactionCount ?? this.transactionCount,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockHash.present) {
      map['block_hash'] = Variable<String>(blockHash.value);
    }
    if (previousHash.present) {
      map['previous_hash'] = Variable<String>(previousHash.value);
    }
    if (merkleRoot.present) {
      map['merkle_root'] = Variable<String>(merkleRoot.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (transactionCount.present) {
      map['transaction_count'] = Variable<int>(transactionCount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentBlocksCompanion(')
          ..write('id: $id, ')
          ..write('blockHash: $blockHash, ')
          ..write('previousHash: $previousHash, ')
          ..write('merkleRoot: $merkleRoot, ')
          ..write('height: $height, ')
          ..write('timestamp: $timestamp, ')
          ..write('transactionCount: $transactionCount, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PowerHistoryTable powerHistory = $PowerHistoryTable(this);
  late final $SummaryTableTable summaryTable = $SummaryTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $SystemInfoTable systemInfo = $SystemInfoTable(this);
  late final $TransactionTableTable transactionTable = $TransactionTableTable(
    this,
  );
  late final $RecentBlocksTable recentBlocks = $RecentBlocksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    powerHistory,
    summaryTable,
    userTable,
    systemInfo,
    transactionTable,
    recentBlocks,
  ];
}

typedef $$PowerHistoryTableCreateCompanionBuilder =
    PowerHistoryCompanion Function({
      Value<int> id,
      required String userID,
      required DateTime timestamp,
      required double generationValue,
      required double consumptionValue,
    });
typedef $$PowerHistoryTableUpdateCompanionBuilder =
    PowerHistoryCompanion Function({
      Value<int> id,
      Value<String> userID,
      Value<DateTime> timestamp,
      Value<double> generationValue,
      Value<double> consumptionValue,
    });

final class $$PowerHistoryTableReferences
    extends
        BaseReferences<_$AppDatabase, $PowerHistoryTable, PowerHistoryData> {
  $$PowerHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTableTable, List<TransactionTableData>>
  _transactionTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionTable,
    aliasName: $_aliasNameGenerator(
      db.powerHistory.id,
      db.transactionTable.powerRawID,
    ),
  );

  $$TransactionTableTableProcessedTableManager get transactionTableRefs {
    final manager = $$TransactionTableTableTableManager(
      $_db,
      $_db.transactionTable,
    ).filter((f) => f.powerRawID.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PowerHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PowerHistoryTable> {
  $$PowerHistoryTableFilterComposer({
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

  ColumnFilters<String> get userID => $composableBuilder(
    column: $table.userID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get generationValue => $composableBuilder(
    column: $table.generationValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consumptionValue => $composableBuilder(
    column: $table.consumptionValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionTableRefs(
    Expression<bool> Function($$TransactionTableTableFilterComposer f) f,
  ) {
    final $$TransactionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTable,
      getReferencedColumn: (t) => t.powerRawID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PowerHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PowerHistoryTable> {
  $$PowerHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get userID => $composableBuilder(
    column: $table.userID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get generationValue => $composableBuilder(
    column: $table.generationValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consumptionValue => $composableBuilder(
    column: $table.consumptionValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PowerHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PowerHistoryTable> {
  $$PowerHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userID =>
      $composableBuilder(column: $table.userID, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get generationValue => $composableBuilder(
    column: $table.generationValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consumptionValue => $composableBuilder(
    column: $table.consumptionValue,
    builder: (column) => column,
  );

  Expression<T> transactionTableRefs<T extends Object>(
    Expression<T> Function($$TransactionTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTable,
      getReferencedColumn: (t) => t.powerRawID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PowerHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PowerHistoryTable,
          PowerHistoryData,
          $$PowerHistoryTableFilterComposer,
          $$PowerHistoryTableOrderingComposer,
          $$PowerHistoryTableAnnotationComposer,
          $$PowerHistoryTableCreateCompanionBuilder,
          $$PowerHistoryTableUpdateCompanionBuilder,
          (PowerHistoryData, $$PowerHistoryTableReferences),
          PowerHistoryData,
          PrefetchHooks Function({bool transactionTableRefs})
        > {
  $$PowerHistoryTableTableManager(_$AppDatabase db, $PowerHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PowerHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PowerHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PowerHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userID = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> generationValue = const Value.absent(),
                Value<double> consumptionValue = const Value.absent(),
              }) => PowerHistoryCompanion(
                id: id,
                userID: userID,
                timestamp: timestamp,
                generationValue: generationValue,
                consumptionValue: consumptionValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userID,
                required DateTime timestamp,
                required double generationValue,
                required double consumptionValue,
              }) => PowerHistoryCompanion.insert(
                id: id,
                userID: userID,
                timestamp: timestamp,
                generationValue: generationValue,
                consumptionValue: consumptionValue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PowerHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTableRefs) db.transactionTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTableRefs)
                    await $_getPrefetchedData<
                      PowerHistoryData,
                      $PowerHistoryTable,
                      TransactionTableData
                    >(
                      currentTable: table,
                      referencedTable: $$PowerHistoryTableReferences
                          ._transactionTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PowerHistoryTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.powerRawID == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PowerHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PowerHistoryTable,
      PowerHistoryData,
      $$PowerHistoryTableFilterComposer,
      $$PowerHistoryTableOrderingComposer,
      $$PowerHistoryTableAnnotationComposer,
      $$PowerHistoryTableCreateCompanionBuilder,
      $$PowerHistoryTableUpdateCompanionBuilder,
      (PowerHistoryData, $$PowerHistoryTableReferences),
      PowerHistoryData,
      PrefetchHooks Function({bool transactionTableRefs})
    >;
typedef $$SummaryTableTableCreateCompanionBuilder =
    SummaryTableCompanion Function({
      Value<int> id,
      required String userID,
      required DateTime periodStart,
      required DateTime periodEnd,
      required double totalGeneration,
      required double totalConsumption,
    });
typedef $$SummaryTableTableUpdateCompanionBuilder =
    SummaryTableCompanion Function({
      Value<int> id,
      Value<String> userID,
      Value<DateTime> periodStart,
      Value<DateTime> periodEnd,
      Value<double> totalGeneration,
      Value<double> totalConsumption,
    });

class $$SummaryTableTableFilterComposer
    extends Composer<_$AppDatabase, $SummaryTableTable> {
  $$SummaryTableTableFilterComposer({
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

  ColumnFilters<String> get userID => $composableBuilder(
    column: $table.userID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalGeneration => $composableBuilder(
    column: $table.totalGeneration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalConsumption => $composableBuilder(
    column: $table.totalConsumption,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SummaryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SummaryTableTable> {
  $$SummaryTableTableOrderingComposer({
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

  ColumnOrderings<String> get userID => $composableBuilder(
    column: $table.userID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalGeneration => $composableBuilder(
    column: $table.totalGeneration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalConsumption => $composableBuilder(
    column: $table.totalConsumption,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SummaryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SummaryTableTable> {
  $$SummaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userID =>
      $composableBuilder(column: $table.userID, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<double> get totalGeneration => $composableBuilder(
    column: $table.totalGeneration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalConsumption => $composableBuilder(
    column: $table.totalConsumption,
    builder: (column) => column,
  );
}

class $$SummaryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SummaryTableTable,
          SummaryTableData,
          $$SummaryTableTableFilterComposer,
          $$SummaryTableTableOrderingComposer,
          $$SummaryTableTableAnnotationComposer,
          $$SummaryTableTableCreateCompanionBuilder,
          $$SummaryTableTableUpdateCompanionBuilder,
          (
            SummaryTableData,
            BaseReferences<_$AppDatabase, $SummaryTableTable, SummaryTableData>,
          ),
          SummaryTableData,
          PrefetchHooks Function()
        > {
  $$SummaryTableTableTableManager(_$AppDatabase db, $SummaryTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SummaryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SummaryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SummaryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userID = const Value.absent(),
                Value<DateTime> periodStart = const Value.absent(),
                Value<DateTime> periodEnd = const Value.absent(),
                Value<double> totalGeneration = const Value.absent(),
                Value<double> totalConsumption = const Value.absent(),
              }) => SummaryTableCompanion(
                id: id,
                userID: userID,
                periodStart: periodStart,
                periodEnd: periodEnd,
                totalGeneration: totalGeneration,
                totalConsumption: totalConsumption,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userID,
                required DateTime periodStart,
                required DateTime periodEnd,
                required double totalGeneration,
                required double totalConsumption,
              }) => SummaryTableCompanion.insert(
                id: id,
                userID: userID,
                periodStart: periodStart,
                periodEnd: periodEnd,
                totalGeneration: totalGeneration,
                totalConsumption: totalConsumption,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SummaryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SummaryTableTable,
      SummaryTableData,
      $$SummaryTableTableFilterComposer,
      $$SummaryTableTableOrderingComposer,
      $$SummaryTableTableAnnotationComposer,
      $$SummaryTableTableCreateCompanionBuilder,
      $$SummaryTableTableUpdateCompanionBuilder,
      (
        SummaryTableData,
        BaseReferences<_$AppDatabase, $SummaryTableTable, SummaryTableData>,
      ),
      SummaryTableData,
      PrefetchHooks Function()
    >;
typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      required String userID,
      required String name,
      required String email,
      required String password,
      required String userRole,
      required String phoneNumber,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<String> userID,
      Value<String> name,
      Value<String> email,
      Value<String> password,
      Value<String> userRole,
      Value<String> phoneNumber,
    });

class $$UserTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer({
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

  ColumnFilters<String> get userID => $composableBuilder(
    column: $table.userID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userRole => $composableBuilder(
    column: $table.userRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer({
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

  ColumnOrderings<String> get userID => $composableBuilder(
    column: $table.userID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userRole => $composableBuilder(
    column: $table.userRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userID =>
      $composableBuilder(column: $table.userID, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get userRole =>
      $composableBuilder(column: $table.userRole, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserTableTable,
          UserTableData,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (
            UserTableData,
            BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>,
          ),
          UserTableData,
          PrefetchHooks Function()
        > {
  $$UserTableTableTableManager(_$AppDatabase db, $UserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userID = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> userRole = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                userID: userID,
                name: name,
                email: email,
                password: password,
                userRole: userRole,
                phoneNumber: phoneNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userID,
                required String name,
                required String email,
                required String password,
                required String userRole,
                required String phoneNumber,
              }) => UserTableCompanion.insert(
                id: id,
                userID: userID,
                name: name,
                email: email,
                password: password,
                userRole: userRole,
                phoneNumber: phoneNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserTableTable,
      UserTableData,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (
        UserTableData,
        BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>,
      ),
      UserTableData,
      PrefetchHooks Function()
    >;
typedef $$SystemInfoTableCreateCompanionBuilder =
    SystemInfoCompanion Function({
      required String systemID,
      required String location,
      required int panelCount,
      required double panelCapacity,
      required double batteryCapacity,
      required double inverterCapacity,
      Value<int> rowid,
    });
typedef $$SystemInfoTableUpdateCompanionBuilder =
    SystemInfoCompanion Function({
      Value<String> systemID,
      Value<String> location,
      Value<int> panelCount,
      Value<double> panelCapacity,
      Value<double> batteryCapacity,
      Value<double> inverterCapacity,
      Value<int> rowid,
    });

class $$SystemInfoTableFilterComposer
    extends Composer<_$AppDatabase, $SystemInfoTable> {
  $$SystemInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get systemID => $composableBuilder(
    column: $table.systemID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get panelCount => $composableBuilder(
    column: $table.panelCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get panelCapacity => $composableBuilder(
    column: $table.panelCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get batteryCapacity => $composableBuilder(
    column: $table.batteryCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get inverterCapacity => $composableBuilder(
    column: $table.inverterCapacity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemInfoTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemInfoTable> {
  $$SystemInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get systemID => $composableBuilder(
    column: $table.systemID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get panelCount => $composableBuilder(
    column: $table.panelCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get panelCapacity => $composableBuilder(
    column: $table.panelCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get batteryCapacity => $composableBuilder(
    column: $table.batteryCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get inverterCapacity => $composableBuilder(
    column: $table.inverterCapacity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemInfoTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemInfoTable> {
  $$SystemInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get systemID =>
      $composableBuilder(column: $table.systemID, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get panelCount => $composableBuilder(
    column: $table.panelCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get panelCapacity => $composableBuilder(
    column: $table.panelCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get batteryCapacity => $composableBuilder(
    column: $table.batteryCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get inverterCapacity => $composableBuilder(
    column: $table.inverterCapacity,
    builder: (column) => column,
  );
}

class $$SystemInfoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemInfoTable,
          SystemInfoData,
          $$SystemInfoTableFilterComposer,
          $$SystemInfoTableOrderingComposer,
          $$SystemInfoTableAnnotationComposer,
          $$SystemInfoTableCreateCompanionBuilder,
          $$SystemInfoTableUpdateCompanionBuilder,
          (
            SystemInfoData,
            BaseReferences<_$AppDatabase, $SystemInfoTable, SystemInfoData>,
          ),
          SystemInfoData,
          PrefetchHooks Function()
        > {
  $$SystemInfoTableTableManager(_$AppDatabase db, $SystemInfoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> systemID = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<int> panelCount = const Value.absent(),
                Value<double> panelCapacity = const Value.absent(),
                Value<double> batteryCapacity = const Value.absent(),
                Value<double> inverterCapacity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemInfoCompanion(
                systemID: systemID,
                location: location,
                panelCount: panelCount,
                panelCapacity: panelCapacity,
                batteryCapacity: batteryCapacity,
                inverterCapacity: inverterCapacity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String systemID,
                required String location,
                required int panelCount,
                required double panelCapacity,
                required double batteryCapacity,
                required double inverterCapacity,
                Value<int> rowid = const Value.absent(),
              }) => SystemInfoCompanion.insert(
                systemID: systemID,
                location: location,
                panelCount: panelCount,
                panelCapacity: panelCapacity,
                batteryCapacity: batteryCapacity,
                inverterCapacity: inverterCapacity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SystemInfoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemInfoTable,
      SystemInfoData,
      $$SystemInfoTableFilterComposer,
      $$SystemInfoTableOrderingComposer,
      $$SystemInfoTableAnnotationComposer,
      $$SystemInfoTableCreateCompanionBuilder,
      $$SystemInfoTableUpdateCompanionBuilder,
      (
        SystemInfoData,
        BaseReferences<_$AppDatabase, $SystemInfoTable, SystemInfoData>,
      ),
      SystemInfoData,
      PrefetchHooks Function()
    >;
typedef $$TransactionTableTableCreateCompanionBuilder =
    TransactionTableCompanion Function({
      Value<int> id,
      required DateTime transactionDate,
      required double pricePerKwh,
      required double totalPrice,
      required double kWhSold,
      required String status,
      required int powerRawID,
    });
typedef $$TransactionTableTableUpdateCompanionBuilder =
    TransactionTableCompanion Function({
      Value<int> id,
      Value<DateTime> transactionDate,
      Value<double> pricePerKwh,
      Value<double> totalPrice,
      Value<double> kWhSold,
      Value<String> status,
      Value<int> powerRawID,
    });

final class $$TransactionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionTableTable,
          TransactionTableData
        > {
  $$TransactionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PowerHistoryTable _powerRawIDTable(_$AppDatabase db) =>
      db.powerHistory.createAlias(
        $_aliasNameGenerator(
          db.transactionTable.powerRawID,
          db.powerHistory.id,
        ),
      );

  $$PowerHistoryTableProcessedTableManager get powerRawID {
    final $_column = $_itemColumn<int>('power_raw_i_d')!;

    final manager = $$PowerHistoryTableTableManager(
      $_db,
      $_db.powerHistory,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_powerRawIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableFilterComposer({
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

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerKwh => $composableBuilder(
    column: $table.pricePerKwh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kWhSold => $composableBuilder(
    column: $table.kWhSold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$PowerHistoryTableFilterComposer get powerRawID {
    final $$PowerHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.powerRawID,
      referencedTable: $db.powerHistory,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PowerHistoryTableFilterComposer(
            $db: $db,
            $table: $db.powerHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerKwh => $composableBuilder(
    column: $table.pricePerKwh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kWhSold => $composableBuilder(
    column: $table.kWhSold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$PowerHistoryTableOrderingComposer get powerRawID {
    final $$PowerHistoryTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.powerRawID,
      referencedTable: $db.powerHistory,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PowerHistoryTableOrderingComposer(
            $db: $db,
            $table: $db.powerHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerKwh => $composableBuilder(
    column: $table.pricePerKwh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kWhSold =>
      $composableBuilder(column: $table.kWhSold, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PowerHistoryTableAnnotationComposer get powerRawID {
    final $$PowerHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.powerRawID,
      referencedTable: $db.powerHistory,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PowerHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.powerHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionTableTable,
          TransactionTableData,
          $$TransactionTableTableFilterComposer,
          $$TransactionTableTableOrderingComposer,
          $$TransactionTableTableAnnotationComposer,
          $$TransactionTableTableCreateCompanionBuilder,
          $$TransactionTableTableUpdateCompanionBuilder,
          (TransactionTableData, $$TransactionTableTableReferences),
          TransactionTableData,
          PrefetchHooks Function({bool powerRawID})
        > {
  $$TransactionTableTableTableManager(
    _$AppDatabase db,
    $TransactionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<double> pricePerKwh = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<double> kWhSold = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> powerRawID = const Value.absent(),
              }) => TransactionTableCompanion(
                id: id,
                transactionDate: transactionDate,
                pricePerKwh: pricePerKwh,
                totalPrice: totalPrice,
                kWhSold: kWhSold,
                status: status,
                powerRawID: powerRawID,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime transactionDate,
                required double pricePerKwh,
                required double totalPrice,
                required double kWhSold,
                required String status,
                required int powerRawID,
              }) => TransactionTableCompanion.insert(
                id: id,
                transactionDate: transactionDate,
                pricePerKwh: pricePerKwh,
                totalPrice: totalPrice,
                kWhSold: kWhSold,
                status: status,
                powerRawID: powerRawID,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({powerRawID = false}) {
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
                    if (powerRawID) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.powerRawID,
                                referencedTable:
                                    $$TransactionTableTableReferences
                                        ._powerRawIDTable(db),
                                referencedColumn:
                                    $$TransactionTableTableReferences
                                        ._powerRawIDTable(db)
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

typedef $$TransactionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionTableTable,
      TransactionTableData,
      $$TransactionTableTableFilterComposer,
      $$TransactionTableTableOrderingComposer,
      $$TransactionTableTableAnnotationComposer,
      $$TransactionTableTableCreateCompanionBuilder,
      $$TransactionTableTableUpdateCompanionBuilder,
      (TransactionTableData, $$TransactionTableTableReferences),
      TransactionTableData,
      PrefetchHooks Function({bool powerRawID})
    >;
typedef $$RecentBlocksTableCreateCompanionBuilder =
    RecentBlocksCompanion Function({
      Value<int> id,
      required String blockHash,
      required String previousHash,
      required String merkleRoot,
      required int height,
      required DateTime timestamp,
      Value<int?> transactionCount,
      Value<String?> source,
    });
typedef $$RecentBlocksTableUpdateCompanionBuilder =
    RecentBlocksCompanion Function({
      Value<int> id,
      Value<String> blockHash,
      Value<String> previousHash,
      Value<String> merkleRoot,
      Value<int> height,
      Value<DateTime> timestamp,
      Value<int?> transactionCount,
      Value<String?> source,
    });

class $$RecentBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $RecentBlocksTable> {
  $$RecentBlocksTableFilterComposer({
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

  ColumnFilters<String> get blockHash => $composableBuilder(
    column: $table.blockHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousHash => $composableBuilder(
    column: $table.previousHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merkleRoot => $composableBuilder(
    column: $table.merkleRoot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionCount => $composableBuilder(
    column: $table.transactionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentBlocksTable> {
  $$RecentBlocksTableOrderingComposer({
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

  ColumnOrderings<String> get blockHash => $composableBuilder(
    column: $table.blockHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousHash => $composableBuilder(
    column: $table.previousHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merkleRoot => $composableBuilder(
    column: $table.merkleRoot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionCount => $composableBuilder(
    column: $table.transactionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentBlocksTable> {
  $$RecentBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get blockHash =>
      $composableBuilder(column: $table.blockHash, builder: (column) => column);

  GeneratedColumn<String> get previousHash => $composableBuilder(
    column: $table.previousHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merkleRoot => $composableBuilder(
    column: $table.merkleRoot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get transactionCount => $composableBuilder(
    column: $table.transactionCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$RecentBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentBlocksTable,
          RecentBlock,
          $$RecentBlocksTableFilterComposer,
          $$RecentBlocksTableOrderingComposer,
          $$RecentBlocksTableAnnotationComposer,
          $$RecentBlocksTableCreateCompanionBuilder,
          $$RecentBlocksTableUpdateCompanionBuilder,
          (
            RecentBlock,
            BaseReferences<_$AppDatabase, $RecentBlocksTable, RecentBlock>,
          ),
          RecentBlock,
          PrefetchHooks Function()
        > {
  $$RecentBlocksTableTableManager(_$AppDatabase db, $RecentBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> blockHash = const Value.absent(),
                Value<String> previousHash = const Value.absent(),
                Value<String> merkleRoot = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int?> transactionCount = const Value.absent(),
                Value<String?> source = const Value.absent(),
              }) => RecentBlocksCompanion(
                id: id,
                blockHash: blockHash,
                previousHash: previousHash,
                merkleRoot: merkleRoot,
                height: height,
                timestamp: timestamp,
                transactionCount: transactionCount,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String blockHash,
                required String previousHash,
                required String merkleRoot,
                required int height,
                required DateTime timestamp,
                Value<int?> transactionCount = const Value.absent(),
                Value<String?> source = const Value.absent(),
              }) => RecentBlocksCompanion.insert(
                id: id,
                blockHash: blockHash,
                previousHash: previousHash,
                merkleRoot: merkleRoot,
                height: height,
                timestamp: timestamp,
                transactionCount: transactionCount,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentBlocksTable,
      RecentBlock,
      $$RecentBlocksTableFilterComposer,
      $$RecentBlocksTableOrderingComposer,
      $$RecentBlocksTableAnnotationComposer,
      $$RecentBlocksTableCreateCompanionBuilder,
      $$RecentBlocksTableUpdateCompanionBuilder,
      (
        RecentBlock,
        BaseReferences<_$AppDatabase, $RecentBlocksTable, RecentBlock>,
      ),
      RecentBlock,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PowerHistoryTableTableManager get powerHistory =>
      $$PowerHistoryTableTableManager(_db, _db.powerHistory);
  $$SummaryTableTableTableManager get summaryTable =>
      $$SummaryTableTableTableManager(_db, _db.summaryTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$SystemInfoTableTableManager get systemInfo =>
      $$SystemInfoTableTableManager(_db, _db.systemInfo);
  $$TransactionTableTableTableManager get transactionTable =>
      $$TransactionTableTableTableManager(_db, _db.transactionTable);
  $$RecentBlocksTableTableManager get recentBlocks =>
      $$RecentBlocksTableTableManager(_db, _db.recentBlocks);
}

mixin _$BlockchainDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecentBlocksTable get recentBlocks => attachedDatabase.recentBlocks;
}
