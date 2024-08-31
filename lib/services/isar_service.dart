import 'dart:typed_data';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/statemodel.dart';
import 'package:attendanceapp/model/locationmodel.dart';
import 'package:attendanceapp/model/user_face.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/app_usage_model.dart';
import '../model/track_location_model.dart';

class IsarService extends DatabaseAdapter {
  IsarService._privateConstructor();
  static final IsarService _instance = IsarService._privateConstructor();
  static IsarService get instance => _instance;

  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveAttendance(AttendanceModel newattendance) async {
    final isar = await db;
    //we return an int int thr writeTxnSync because we want to get the id of the saved attendance
    await isar
        .writeTxnSync<int>(() => isar.attendanceModels.putSync(newattendance));
  }

  Future<void> saveLocation(LocationModel newlocation) async {
    final isar = await db;
    await isar
        .writeTxnSync<int>(() => isar.locationModels.putSync(newlocation));
  }

  Future<void> saveState(StateModel newstate) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.stateModels.putSync(newstate));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving state: Unique index violated. State likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving state: $e");
      }
    }
  }

  Future<void> saveLocationData(TrackLocationModel newtracklocationdata) async {
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.trackLocationModels.putSync(newtracklocationdata));
  }

  Future<List<TrackLocationModel>> getAttendanceForEmptyLocationFor12() async {
    final isar = await db;
    return await isar.trackLocationModels
        .filter()
        .locationNameIsNull()
        .or()
        .locationNameEqualTo("")
        .findAll();
  }

  Future<TrackLocationModel?> getLastLocationFor12() async {
    await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.trackLocationModels
        .where()
        .sortByTimestampDesc()
        .findFirst();
    //where().sortByDateDesc().findFirst();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<TrackLocationModel>> getTracklocationForPartialUnSynced() async {
    final isar = await db;
    return await isar.trackLocationModels
        .filter()
        .isSynchedEqualTo(false)
        .findAll();
  }

  Future<void> updateSyncStatusForTrackLocationBy12(
      int id,
      TrackLocationModel trackLocationModels,
      bool isSynched,
      ) async {
    final isar = await db;
    final updateSyncStatus = await isar.trackLocationModels.get(id);

    updateSyncStatus!..isSynched = isSynched;

    await isar.writeTxn(() async {
      await isar.trackLocationModels.put(updateSyncStatus);
    });
  }

  Future<void> updateEmptyLocationFor12(
      int id,
      TrackLocationModel trackLocationModels,
      String locationName,
      ) async {
    final isar = await db;
    final emptyLocationUpdate = await isar.trackLocationModels.get(id);

    emptyLocationUpdate!
      ..locationName = locationName;

    await isar.writeTxn(() async {
      await isar.trackLocationModels.put(emptyLocationUpdate);
    });
  }

  Future<void> saveBioData(BioModel newbiodata) async {
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.bioModels.putSync(newbiodata));
  }

  Future<void> saveUserFace(UserFace newbiodata) async {
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.userFaces.putSync(newbiodata));
  }

  Future<List<UserFace>> getAllUserFace() async {
    final isar = await db;
    return await isar.userFaces.where().findAll();
  }

  // Future<void> saveDaysOff(DaysOffModel newdaysoff) async {
  //   final isar = await db;
  //   //we return an int int thr writeTxnSync because we want to get the id of the saved attendance
  //   await isar.writeTxnSync<int>(() => isar.daysOffModels.putSync(newdaysoff));
  // }

  Future<List<AttendanceModel>> getAllAttendance() async {
    final isar = await db;
    return await isar.attendanceModels.where().findAll();
  }

  Future<List<LocationModel>> getAllLocation() async {
    final isar = await db;
    return await isar.locationModels.where().findAll();
  }

  Future<List<LocationModel>> getLocationsByState(String? state) async {
    final isar = await db;
    return await isar.locationModels.filter().stateEqualTo(state).findAll();
  }

  Future<List<LocationModel>> getAllLocations() async {
    final isar = await db;
    return await isar.locationModels.where().findAll();
  }

  Future<List<AttendanceModel>> getAttendanceFor1990() async {
    final isar = await db;
    return await isar.attendanceModels
        .where()
        .filter()
        .monthEqualTo("January 1900")
        .findAll();
  }

  // Future<String> getAllAttendance2(AESEncryption encryption) async {
  //   final isar = await db;
  //   final attend = await isar.attendanceModels.where().findAll();
  //   String attend2 = attend.toString();
  //   var encrypted = encryption.encryptMsg(attend2.toString()).base16;
  //   print("Encyrpted Data = $encrypted");
  //   var decrypted = encryption.decryptMsg(encryption.getCode(encrypted));
  //   print("Decyrpted Data = $decrypted");
  //   // final data1 = await json.decode(decrypted);

  //   return encrypted;
  // }

  Future<void> importAllAttendance(AttendanceModel rest) async {
    final isar = await db;

    // await isar.writeTxnSync(() => isar.attendanceModels
    //     .importJson(rest));

    // rest.map<AttendanceModel>((json) => AttendanceModel.fromJson(json)).toList();
  }

  exportAllAttendance() async {
    final isar = await db;
    final attend = await isar.attendanceModels.where().findAll();

    List<Map<String, dynamic>>? listAttendance =
        attend.map((e) => e.toJson()).toList();
    Map<String, dynamic> params = {'Attendance': listAttendance};
    print(params);
    return params;
  }

  exportAllBioInfo() async {
    final isar = await db;
    final bio = await isar.bioModels.where().findAll();

    List<Map<String, dynamic>>? listBioInfo =
        bio.map((e) => e.toJson()).toList();
    Map<String, dynamic> params = {'BioInfo': listBioInfo};
    print(params);
    return params;
  }

  Stream<List<AttendanceModel>> listenToAttendance() async* {
    final isar = await db;
    //yield* returns everything in your db via the stream function
    yield* isar.attendanceModels.where().watch();
  }



  Stream<List<BioModel>> watchBioInfoWithFirebaseAuth() async*  {
    // ... (implementation to watch BioInfo changes in Isar)
    final isar = await db;
    //yield* isar.bioModels.where().watch();
    final query = isar.bioModels.where().filter().firebaseAuthIdIsNotNull().build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      }
    }
  }



  Stream<AttendanceModel?> watchLastAttendance(String month) async* {
    final isar = await db; // Assuming 'db' is a Future<Isar>

    await for (final attendance in isar.attendanceModels.where()
        .filter()
        .monthEqualTo(month)
        .sortByDateDesc()
        .watch(fireImmediately: true)) {
      yield attendance.isNotEmpty ? attendance.first : null;
    }
  }

  Stream<List<AttendanceModel>> getHourWorkedForMonth(String month) async* {
    final isar = await db;
    final query = isar.attendanceModels
        .where()
        .filter()
        .monthEqualTo(month)
        .and()
        .offDayEqualTo(false)
    // .and()
    // .isUpdatedEqualTo(true)
        .build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      }
    }
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }



  Future<Isar> openDB() async {
    final directory = await getApplicationSupportDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([
        AttendanceModelSchema,
        BioModelSchema,
        UserFaceSchema,
        LocationModelSchema,
        StateModelSchema,
        AppUsageModelSchema,
        TrackLocationModelSchema
      ], inspector: true, directory: directory.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> cleanDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<void> cleanLocationCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.locationModels.clear()); // Truncate collection
  }

  Future<void> cleanStateCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.stateModels.clear()); // Truncate collection
  }

  Future<List<AttendanceModel>> getAttendanceFor(
      AttendanceModel attendanceModel) async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .idEqualTo(attendanceModel.id)
        .findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<AttendanceModel>> getAttendanceForDate(String? date) async {
    final isar = await db;
    return await isar.attendanceModels.filter().dateEqualTo(date).findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }



  Stream<List<AttendanceModel>> getDaysOffForMonth(String month) async* {
    final isar = await db;
    final query = isar.attendanceModels
        .where()
        .filter()
        .monthEqualTo(month)
        .and()
        .offDayEqualTo(true)
        // .and()
        // .isUpdatedEqualTo(true)
        .build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      }
    }
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Stream<List<AttendanceModel?>> listenToLastAttendance(String month) async* {
    final isar = await db;

    final query = await isar.attendanceModels
        .where()
        .filter()
        .monthEqualTo(month)
        .sortByDateDesc()
        .build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      }
    }
  }

  // Future<List<AttendanceModel>> getAttendanceForLast() async {
  //   final isar = await db;
  //   return await isar.attendanceModels.where().sortByDateDesc().findAll();
  //   // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  // }

  Future<AttendanceModel?> getLastAttendance(String month) async {
    await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .monthEqualTo(month)
        .sortByDateDesc()
        .findFirst();
    //where().sortByDateDesc().findFirst();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<UserFace?> getLastUserFace() async {
    //await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.userFaces.filter().arrayIsNotEmpty().findFirst();
    //where().sortByDateDesc().findFirst();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<AttendanceModel>> getAttendanceForSpecificDate(
      String date) async {
    final isar = await db;
    return await isar.attendanceModels.filter().dateEqualTo(date).findAll();
  }

  Future<List<AttendanceModel>> getAttendanceForUnSynced() async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<AttendanceModel>> getAttendanceForSpecificMonth(
      String month) async {
    final isar = await db;
    return await isar.attendanceModels.filter().monthEqualTo(month).findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<int> getCountForClockIn() async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .clockInIsNotNull()
        .and()
        .monthEqualTo(DateFormat('MMMM').format(DateTime.now()))
        .and()
        .offDayEqualTo(false)
        .count();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<int> getCountForClockOut() async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .clockOutIsNotNull()
        .and()
        .monthEqualTo(DateFormat('MMMM').format(DateTime.now()))
        .and()
        .offDayEqualTo(false)
        .count();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<int> getCountForoffDay(String month) async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .monthEqualTo(month)
        .and()
        .offDayEqualTo(true)
        .count();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<AttendanceModel>> getAttendanceForPartialUnSynced() async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .isSyncedEqualTo(false)
        .and()
        .isUpdatedEqualTo(true)
        .and()
        .clockOutLatitudeGreaterThan(0.0)
        .findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  getUnsyncedData() async {
    final isar = await db;
    IsarCollection<AttendanceModel> attendanceModelCollection =
        isar.collection<AttendanceModel>();
    List<AttendanceModel?> attendanceModel = await attendanceModelCollection
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
    return attendanceModel;
  }

  Future<List<AttendanceModel>> getAttendanceForEmptyClockInLocation() async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .clockInLocationIsNull()
        .or()
        .clockInLocationEqualTo("")
        .and()
        .clockInLatitudeGreaterThan(0.0)
        .and()
        .clockInLongitudeGreaterThan(0.0)
        .findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<AttendanceModel>> getAttendanceForEmptyClockOutLocation() async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .clockOutLocationIsNull()
        .or()
        .clockOutLocationEqualTo("")
        .and()
        .clockOutLatitudeGreaterThan(0.0)
        .and()
        .clockOutLongitudeGreaterThan(0.0)
        .findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<void> updateAttendance(
      int id,
      AttendanceModel attendanceModels,
      String clockOut,
      double clockOutLatitude,
      double clockOutLongitude,
      String clockOutLocation,
      bool isSynced,
      bool isUpdated,
      String durationWorked,
      double noOfHours) async {
    final isar = await db;
    final attendanceUpdate = await isar.attendanceModels.get(id);

    attendanceUpdate!
      ..clockOut = clockOut
      ..clockOutLatitude = clockOutLatitude
      ..clockOutLongitude = clockOutLongitude
      ..clockOutLocation = clockOutLocation
      ..isSynced = isSynced
      ..isUpdated = isUpdated
      ..durationWorked = durationWorked
      ..noOfHours = noOfHours;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(attendanceUpdate);
    });
  }

  Future<void> updateAttendanceWithComment(
      int id,
      AttendanceModel attendanceModels,
      String comments) async {
    final isar = await db;
    final attendanceUpdate = await isar.attendanceModels.get(id);

    attendanceUpdate!
      ..comments = comments;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(attendanceUpdate);
    });
  }

  Future<AttendanceModel?> getSpecificAttendance(int id) async {
    final isar = await db;
    return await isar.attendanceModels.filter().idEqualTo(id).findFirst();
  }

  Future<List<AttendanceModel?>> getListSpecificAttendance(int id) async {
    final isar = await db;
    return await isar.attendanceModels.filter().idEqualTo(id).findAll();
  }

  Future<void> voidAttendance(
    int id,
    AttendanceModel newAttendanceModel,
    bool isSynced,
    bool voided,
  ) async {
    final isar = await db;
    final voidAttendance = await isar.attendanceModels.get(id);

    voidAttendance!
      ..isSynced = isSynced
      ..voided = voided;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(voidAttendance);
    });
  }

  Future<void> updateEmptyClockInLocation(
    int id,
    AttendanceModel attendanceModels,
    String clockInLocation,
  ) async {
    final isar = await db;
    final emptyclockInLocationUpdate = await isar.attendanceModels.get(id);

    emptyclockInLocationUpdate!
      ..clockInLocation = clockInLocation
      ..isUpdated = true;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(emptyclockInLocationUpdate);
    });
  }

  Future<void> updateEmptyClockOutLocation(
    int id,
    AttendanceModel attendanceModels,
    String clockOutLocation,
  ) async {
    final isar = await db;
    final emptyclockOutLocationUpdate = await isar.attendanceModels.get(id);

    emptyclockOutLocationUpdate!
      ..clockOutLocation = clockOutLocation
      ..isUpdated = true;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(emptyclockOutLocationUpdate);
    });
  }

  Future<void> updateClockOut(
      int id,
      AttendanceModel attendanceModels,
      String clockOut,
      double clockOutLatitude,
      String clockOutLocation,
      double clockOutLongitude,
      String durationWorked,
      double noOfHours) async {
    final isar = await db;
    final emptyclockOut = await isar.attendanceModels.get(id);

    emptyclockOut!
      ..clockOut = clockOut
      ..clockOutLatitude = clockOutLatitude
      ..clockOutLocation = clockOutLocation
      ..clockOutLongitude = clockOutLongitude
      ..durationWorked = durationWorked
      ..noOfHours = noOfHours
      ..isSynced = false
      ..voided = false
      ..isUpdated = true;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(emptyclockOut);
    });
  }

  Stream<List<AttendanceModel>> searchAllAttendance({String? search}) async* {
    print(search);
    final isar = await db;
    final query = isar.attendanceModels
        .where()
        .filter()
        .voidedEqualTo(false)
        .and()
        .dateContains(search ?? '', caseSensitive: false)
        .sortByDateDesc()
        .build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      }
    }
  }

  // Stream<List<DaysOffModel>> searchAllDaysOff({String? search}) async* {
  //   print(search);
  //   final isar = await db;
  //   final query = isar.daysOffModels
  //       .where()
  //       .filter()
  //       .voidedEqualTo(false)
  //       .and()
  //       .dateContains(search ?? '', caseSensitive: false)
  //       .build();

  //   await for (final results in query.watch(fireImmediately: true)) {
  //     if (results.isNotEmpty) {
  //       yield results;
  //     }
  //   }
  // }

  // removeAttendance(AttendanceModel attendanceModel,int id) async {
  //   final isar = await db;
  //   await isar.writeTxn(() async {
  //     await isar.attendanceModels.delete(attendanceModel.id);
  //   });
  // }

  removeAttendance(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.attendanceModels.delete(id);
    });
  }

  removeAllAttendance(AttendanceModel attendanceModel) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.attendanceModels.filter().idGreaterThan(0).deleteAll();
    });
  }

  removeAllLocation(LocationModel locationModel) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.locationModels.filter().idGreaterThan(0).deleteAll();
    });
  }

  void updateSync(AttendanceModel attendanceModel) async {
    final isar = await db;
    attendanceModel.isSynced = true;
    await isar.writeTxn(() async {
      await isar.attendanceModels.put(attendanceModel);
    });
  }

  //Another way to update unsynced data
  Future<void> updateSyncStatus(
    int id,
    AttendanceModel attendanceModels,
    bool isSynced,
  ) async {
    final isar = await db;
    final updateSyncStatus = await isar.attendanceModels.get(id);

    updateSyncStatus!..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.attendanceModels.put(updateSyncStatus);
    });
  }

  @override
  Future<void> storeImage(Uint8List imageBytes) async {
    // TODO: implement storeImage
    final isar = await db;

    throw UnimplementedError();
  }

  @override
  Future<List<Uint8List>> getImages() {
    // TODO: implement getImages
    throw UnimplementedError();
  }

  Future<AppUsageModel?> getLastUsedDate() async {
    // Retrieve the last used date from Isar (implementation depends on your Isar setup)
    // Example: using a dedicated Isar object called 'AppUsage'
    final isar = await db;
    //return await isar.appUsageModels.where().findFirst();
     final appUsage = isar.appUsageModels.where().findFirst();
    return appUsage;
  }

  Future<void> saveLastUsedDate(AppUsageModel newappusagemodel) async {
    // Save the current date in Isar (implementation depends on your Isar setup)
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.appUsageModels.putSync(newappusagemodel));
  }

  // Future<void> saveLastUsedDate() async {
  //   final isar = await db;
  //   final appUsage = await isar.appUsageModels.where().findFirst() ??
  //       AppUsageModel(lastUsedDate: DateTime.now()); // Create a new AppUsageModel if not found
  //   appUsage.lastUsedDate = DateTime.now(); // Update the lastUsedDate
  //   await isar.writeTxnSync<int>(() => isar.appUsageModels.putSync(appUsage));
  // }

  // Future<AppUsageModel?> getLastUsedDate() async {
  //   final isar = await db;
  //   final appUsage = await isar.appUsageModels.where().findFirst();
  //   return appUsage;
  // }
  //
  // Future<void> saveLastUsedDate() async {
  //   final isar = await db;
  //   final appUsage = await isar.appUsageModels.where().findFirst() ??
  //       AppUsageModel(lastUsedDate: DateTime.now());
  //   appUsage.lastUsedDate = DateTime.now();
  //   await isar.writeTxnSync<int>(() => isar.appUsageModels.putSync(appUsage));
  // }


  Future<List<BioModel>> getBioInfo() async {
    final isar = await db;
    return await isar.bioModels.where().findAll();
  }

  Future<List<BioModel>> getBioInfoForSuperUser() async {
    final isar = await db;
    return await isar.bioModels
        .where()
        .filter()
        .roleEqualTo("Super-Admin")
        .findAll();
  }

  Future<BioModel?> getBioInfoWithFirebaseAuth() async {
    //await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.bioModels.filter().firebaseAuthIdIsNotNull().findFirst();
    //where().sortByDateDesc().findFirst();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }
}
