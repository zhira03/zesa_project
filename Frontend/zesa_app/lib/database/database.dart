import 'package:drift/drift.dart';

part 'database.g.dart';

//base power table
class PowerHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userID => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get generationValue => real()(); //in kWh
  RealColumn get consumptionValue => real()(); //in kWh
}

//period power table
class SummaryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userID => text()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  RealColumn get totalGeneration => real()(); //in kWh
  RealColumn get totalConsumption => real()(); //in kWh
}

//user table
class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userID => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get userRole => text().check(userRole.isIn(['admin', 'prosumer', 'consumer']))();
  TextColumn get phoneNumber => text()();
}

//system info
class SystemInfo extends Table {
  TextColumn get systemID => text().customConstraint('REFERENCES user_table(user_id)')();
  TextColumn get location => text()(); // ill want to use actual gis coordinates later
  IntColumn get panelCount => integer()();
  RealColumn get panelCapacity => real()(); // in kW
  RealColumn get batteryCapacity => real()(); // in kWh
  RealColumn get inverterCapacity => real()(); // in kWh
}

//transaction table
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get transactionDate => dateTime()();
  RealColumn get pricePerKwh => real()(); // in currency
  RealColumn get totalPrice => real()(); // in currency
  RealColumn get kWhSold => real()(); // in kWh
  TextColumn get status => text().check(status.isIn(['pending', 'completed', 'failed']))();
  IntColumn get powerRawID => integer().customConstraint('REFERENCES power_history(id)')();// link to power history
}

//blockchain table
class RecentBlocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get blockHash => text().unique()();
  TextColumn get previousHash => text()();
  TextColumn get merkleRoot => text()();
  IntColumn get height => integer().unique()(); // CRITICAL for ordering and identifying the oldest block
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get transactionCount => integer().nullable()();
  TextColumn get source => text().nullable()();
}

@DriftDatabase(tables: [PowerHistory, SummaryTable, UserTable, SystemInfo, TransactionTable, RecentBlocks])
  class AppDatabase extends _$AppDatabase {
    AppDatabase(QueryExecutor e) : super(e); 

    @override
    int get schemaVersion => 1;
  }

@DriftAccessor(tables: [RecentBlocks])
class BlockchainDao extends DatabaseAccessor<AppDatabase> with _$BlockchainDaoMixin {
  BlockchainDao(super.db);
  
  static const int maxWindowSize = 5;
  Future<void> insertNewBlockAndTrim(RecentBlocksCompanion newBlock) async {
    await transaction(() async { 
      
      // Step 1: Insert the new block
      await into(recentBlocks).insert(newBlock);

      // Step 2: Check if we need to trim the oldest block(s)
      final currentBlockCount = await (select(recentBlocks).get()).then((list) => list.length);

      // If the table size is greater than the window size, delete the oldest
      if (currentBlockCount > maxWindowSize) {
        
        // Find the block with the lowest 'height' (the oldest one)
        final query = select(recentBlocks)
          ..orderBy([
            (t) => OrderingTerm(expression: t.height, mode: OrderingMode.asc)
          ])
          ..limit(currentBlockCount - maxWindowSize); // Delete only the excess blocks

        // Perform the deletion of the oldest block(s)
        await delete(recentBlocks).where((t) => t.id.isInQuery(query.map((row) => row.id))).go();
      }
    });
  }
}