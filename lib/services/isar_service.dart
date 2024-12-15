import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/psychological_metrics.dart';
import 'package:attendanceapp/model/statemodel.dart';
import 'package:attendanceapp/model/locationmodel.dart';
import 'package:attendanceapp/model/user_face.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/app_usage_model.dart';
import '../model/appversion.dart';
import '../model/departmentmodel.dart';
import '../model/designationmodel.dart';
import '../model/facility_staff_model.dart';
import '../model/gendercategory.dart';
import '../model/last_update_date.dart';
import '../model/leave_request_model.dart';
import '../model/marital_status_model.dart';
import '../model/projectmodel.dart';
import '../model/reasonfordaysoff.dart';
import '../model/remaining_leave_model.dart';
import '../model/staffcategory.dart';
import '../model/supervisor_model.dart';
import '../model/survey_result_model.dart';
import '../model/task.dart';
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

  Future<void> saveFacilityStaffList(FacilityStaffModel newfacilityStaffList) async {
    final isar = await db;
    //we return an int int thr writeTxnSync because we want to get the id of the saved attendance
    await isar
        .writeTxnSync<int>(() => isar.facilityStaffModels.putSync(newfacilityStaffList));
  }

  Future<void> updateBioSignatureLink(int id, BioModel bioModel, bool isSynced) async {
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        final existingBio = await isar.bioModels.get(id);

        if (existingBio != null) {
          existingBio.signatureLink = bioModel.signatureLink;
          existingBio.isSynced = isSynced;
          await isar.bioModels.put(existingBio);
        }
      });
    }
  }

  Future<void> saveLocation(LocationModel newlocation) async {
    final isar = await db;
    try{

      await isar
          .writeTxnSync<int>(() => isar.locationModels.putSync(newlocation));
    }catch(e){
      log("Error on save location:$e");

    }

  }
// Helper function to format DateTime as string
  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd-MMMM-yyyy');
    return formatter.format(date);
  }

  /// Fetch all tasks from Isar
  Future<List<Task>> getAllTasks() async {
    final isar = await db;
    return await isar.tasks.where().findAll();
  }


  Stream<List<Task>> listenToTasks() async* {
    final isar = await db;
    yield* isar.tasks.where().watch(fireImmediately: true);
  }

  /// Get a single task by ID
  Future<Task?> getTaskById(int id) async {
    final isar = await db;
    return await isar.tasks.get(id);
  }



  /// Update an existing task in Isar
  Future<void> updateTask(Task task) async {
    final isar = await db;
    await isar.writeTxn(() async => isar.tasks.put(task));
  }

  Future<void>deleteAllTasks() async {
    final isar = await db;
    await isar.writeTxn(() async => isar.tasks.where().deleteAll());
  }




  Stream<List<AttendanceModel>> searchAttendanceByDateRange(
      DateTime startDate, DateTime endDate) async* {
    final isar = await db;

    final start = _formatDate(startDate); // Formatted start date
    final end = _formatDate(endDate);   // Formatted end date

    print("Querying Isar between: $start and $end");

    final query = isar.attendanceModels
        .where()
        .filter()
        .dateGreaterThan(start, include: true)  // String comparison
        .and()
        .dateLessThan(end, include: true);     // String comparison

    print("Query Results: ${await query.findAll()}");

    yield* query.watch(fireImmediately: true);
  }

  Future<void> saveAllAttendance(List<AttendanceModel> attendances) async {
    final isar = await db;

    await isar
        .writeTxn(() => isar.attendanceModels.putAll(attendances));
    // await isar.writeTxn((isar) async {
    //   await isar.attendanceModels.putAll(attendances);
    // } );
  }

  Future<void> saveAllBioData(List<BioModel> bioInfoList) async {
    final isar = await db;
    await isar
        .writeTxn(() => isar.bioModels.putAll(bioInfoList));
    // await isar.writeTxn((isar) async {
    //   await isar.bioModels.putAll(bioInfoList);
    // } as Future Function());
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

  Future<void> saveSupervisor(SupervisorModel newsupervisor) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.supervisorModels.putSync(newsupervisor));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving Supervisor: Unique index violated. Supervisor likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving Supervisor: $e");
      }
    }
  }

  Future<void> saveDepartment(DepartmentModel newdepartment) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.departmentModels.putSync(newdepartment));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving Department: Unique index violated. Department likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving Department: $e");
      }
    }
  }

  Future<void> saveDesignation(DesignationModel newdesignation) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.designationModels.putSync(newdesignation));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving Designation: Unique index violated. Designation likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving Designation: $e");
      }
    }
  }



  Future<void> saveProject(ProjectModel newproject) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.projectModels.putSync(newproject));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving Project: Unique index violated. Project likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving Project: $e");
      }
    }
  }

  Future<void> saveGender(GenderCategoryModel newgender) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.genderCategoryModels.putSync(newgender));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving Gender: Unique index violated. Gender likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving Gender: $e");
      }
    }
  }



  Future<void> saveMaritalStatus(MaritalStatusModel newmaritalstatus) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.maritalStatusModels.putSync(newmaritalstatus));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving Marital Status: Unique index violated. Marital Status likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving Marital Status: $e");
      }
    }
  }

  Future<void> saveAppVersion(AppVersionModel newappversion) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.appVersionModels.putSync(newappversion));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving AppVersion: Unique index violated. AppVersion likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving AppVersion: $e");
      }
    }
  }

  Future<void> saveLastUpdateDate(LastUpdateDateModel newlastupdatedate) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.lastUpdateDateModels.putSync(newlastupdatedate));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving LastUpdateDate: Unique index violated. LastUpdateDate likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving LastUpdateDate: $e");
      }
    }
  }

  Future<void> saveStaffCategory(StaffCategoryModel newstaffcategory) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.staffCategoryModels.putSync(newstaffcategory));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving StaffCategory: Unique index violated. StaffCategory likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving StaffCategory: $e");
      }
    }
  }

  Future<void> saveReasonForDaysOff(ReasonForDaysOffModel newreasonfordaysoff) async {
    final isar = await db;
    try {
      await isar.writeTxnSync<int>(() => isar.reasonForDaysOffModels.putSync(newreasonfordaysoff));
    } catch (e) {
      if (e is IsarError && e.message.contains("Unique index violated")) {
        // Handle unique index violation
        print("Error saving ReasonForDaysOff: Unique index violated. ReasonForDaysOff likely already exists.");
        // You can either update the existing state or handle the error differently
      } else {
        // Handle other Isar errors
        print("Error saving ReasonForDaysOff: $e");
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

  Future<void> updateAppVersion(
      int id,
      AppVersionModel appVersionModels,
      DateTime checkDate,
      bool isLatestVersion
      ) async {
    final isar = await db;
    final updateSyncStatus = await isar.appVersionModels.get(id);

    updateSyncStatus!..checkDate = checkDate
    ..latestVersion = isLatestVersion;

    await isar.writeTxn(() async {
      await isar.appVersionModels.put(updateSyncStatus);
    });
  }

  Future<void> updateReasonsForRejectedLeave(
      int id,
      String reasonsForRejectedLeaves
      ) async {
    final isar = await db;
    final reasonsForRejectedLeave = await isar.leaveRequestModels.get(id);

    reasonsForRejectedLeave!..reasonsForRejectedLeave = reasonsForRejectedLeaves;
;

    await isar.writeTxn(() async {
      await isar.leaveRequestModels.put(reasonsForRejectedLeave);
    });
  }




  Future<void> updateAppVersion1(
      int id,
      AppVersionModel appVersionModels,
      DateTime appVersionDate,
      DateTime checkDate,
      bool isLatestVersion
      ) async {
    final isar = await db;
    final updateSyncStatus = await isar.appVersionModels.get(id);

    updateSyncStatus!..checkDate = checkDate
    ..appVersionDate = appVersionDate
    ..latestVersion = isLatestVersion;

    await isar.writeTxn(() async {
      await isar.appVersionModels.put(updateSyncStatus);
    });
  }

  Future<void> updateAppVersion2(
      int id,
      AppVersionModel appVersionModels,
      DateTime checkDate,
      bool isLatestVersion
      ) async {
    final isar = await db;
    final updateSyncStatus = await isar.appVersionModels.get(id);

    updateSyncStatus!..checkDate = checkDate
      ..latestVersion = isLatestVersion;

    await isar.writeTxn(() async {
      await isar.appVersionModels.put(updateSyncStatus);
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

  Future<void> saveAppVersionData(AppVersionModel newappversiondata) async {
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.appVersionModels.putSync(newappversiondata));
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

  Future<List<Task>> getAllTask() async {
    final isar = await db;
    return await isar.tasks.where().findAll();
  }

  Future<BioModel?> getBioData() async {
    final isar = await db;
    return await isar.bioModels.filter().idEqualTo(2).findFirst();
  }



  Future<List<LocationModel>> getAllLocation() async {
    final isar = await db;
    return await isar.locationModels.where().findAll();
  }

  Future<List<String?>> getStatesFromIsar(String state) async {
    final isar = await db;
    final stateModels = await isar.stateModels.where().stateNameNotEqualTo(state).findAll();
    return stateModels.map((model) => model.stateName).toList();
  }

  Future<List<String?>> getStatesFromIsarForFCT(String state) async {
    final isar = await db;
    final stateModels = await isar.stateModels.where().stateNameEqualTo(state).findAll();
    return stateModels.map((model) => model.stateName).toList();
  }

  Future<List<String?>> getLocationsFromIsar(String state, String category) async {
    final isar = await db;
    final locationModels = await isar.locationModels.filter().stateEqualTo(state).categoryEqualTo(category).findAll();
    return locationModels.map((model) => model.locationName).toList();
  }
  Future<List<String?>> getDepartmentsFromIsar() async {
    final isar = await db;
    final departmentModels = await isar.departmentModels.where().findAll();
    return departmentModels.map((model) => model.departmentName).toList();
  }

  Future<List<String?>> getStaffCategoryFromIsar() async {
    final isar = await db;
    final staffCategoryModels = await isar.staffCategoryModels.where().findAll();
    return staffCategoryModels.map((model) => model.staffCategory).toList();
  }


  Future<List<String?>> getGenderFromIsar() async {
    final isar = await db;
    final genderCategoryModels = await isar.genderCategoryModels.where().findAll();
    return genderCategoryModels.map((model) => model.gender).toList();
  }

  Future<List<String?>> getMaritalStatusFromIsar() async {
    final isar = await db;
    final maritalStatusModels = await isar.maritalStatusModels.where().findAll();
    return maritalStatusModels.map((model) => model.maritalStatus).toList();
  }


  Future<List<String?>> getDesignationsFromIsar(String? department,String? category) async {
    final isar = await db;
    final designationModels = await isar.designationModels.filter().departmentNameEqualTo(department).categoryEqualTo(category).findAll();
    return designationModels.map((model) => model.designationName).toList();
  }

  Future<List<String?>> getSupervisorsFromIsar(String? department, String? state) async {
    final isar = await db;
    final supervisorModels = await isar.supervisorModels.filter().departmentEqualTo(department).stateEqualTo(state).findAll();
    return supervisorModels.map((model) => model.supervisor).toList();
  }
  Future<List<String?>> getSupervisorEmailFromIsar(String? department,String? nameofsupervisor) async {
    final isar = await db;
    final supervisorModels = await isar.supervisorModels.filter().departmentEqualTo(department).supervisorEqualTo(nameofsupervisor).findAll();
    return supervisorModels.map((model) => model.email).toList();
  }

  Stream<List<String?>> getSupervisorStream(String department, String state) {
    final isar = Isar.getInstance(); // Make sure you have an Isar instance
    if (isar != null) {
      return isar.supervisorModels // Replace supervisorModels with your collection name
          .filter()
          .departmentEqualTo(department)
          .stateEqualTo(state)
          .watch(fireImmediately: true) // This creates the stream
          .map((supervisorList) => supervisorList.map((supervisor) => supervisor.supervisor).toList()); // Map to email list
    } else {
      return Stream.value([]); // Return an empty stream if Isar is not initialized
    }
  }


  Future<List<String?>> getReasonsForDaysOffFromIsar() async {
    final isar = await db;
    final reasonForDaysOffModels = await isar.reasonForDaysOffModels.where().findAll();
    return reasonForDaysOffModels.map((model) => model.reasonForDaysOff).toList();
  }

  Future<List<String?>> getProjectFromIsar() async {
    final isar = await db;
    final projectModels = await isar.projectModels.where().findAll();
    return projectModels.map((model) => model.project).toList();
  }

  Future<List<String?>> getAllStatesFromIsar() async {
    final isar = await db;
    final stateModels = await isar.stateModels.where().findAll();
    return stateModels.map((model) => model.stateName).toList();
  }

  Future<List<String?>> getAllStatesFromIsarForFCT() async {
    final isar = await db;
    final stateModels = await isar.stateModels.filter().stateNameEqualTo("Federal Capital Territory").findAll();
    return stateModels.map((model) => model.stateName).toList();
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
        TrackLocationModelSchema,
        DepartmentModelSchema,
        DesignationModelSchema,
        ProjectModelSchema,
        AppVersionModelSchema,
        ReasonForDaysOffModelSchema,
        StaffCategoryModelSchema,
        LastUpdateDateModelSchema,
        SupervisorModelSchema,
        LeaveRequestModelSchema,
        RemainingLeaveModelSchema,
        GenderCategoryModelSchema,
        MaritalStatusModelSchema,
        TaskSchema,
        FacilityStaffModelSchema,
        SurveyResultModelSchema,
        PsychologicalMetricsModelSchema


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

  Future<void> PsychologicalMetricsCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.psychologicalMetricsModels.clear()); // Truncate collection
  }

  Future<void> cleanStateCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.stateModels.clear()); // Truncate collection
  }

  Future<void> cleanDepartmentCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.departmentModels.clear()); // Truncate collection
  }
  Future<void> cleanSupervisorCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.supervisorModels.clear()); // Truncate collection
  }

  Future<void> cleanFacilityStaffListCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.facilityStaffModels.clear()); // Truncate collection
  }

  Future<void> cleanMaritalStatusCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.maritalStatusModels.clear()); // Truncate collection
  }

  Future<void> cleanGenderCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.genderCategoryModels.clear()); // Truncate collection
  }

  Future<void> cleanAttendanceCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.attendanceModels.clear()); // Truncate collection
  }

  Future<void> cleanDesignationCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.designationModels.clear()); // Truncate collection
  }

  Future<void> cleanAppVersionCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.appVersionModels.clear()); // Truncate collection
  }

  Future<void> cleanReasonsForDayOffCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.reasonForDaysOffModels.clear()); // Truncate collection
  }

  Future<void> cleanStaffCategoryCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.staffCategoryModels.clear()); // Truncate collection
  }

  Future<void> cleanBioCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.bioModels.clear()); // Truncate collection
  }

  Future<void> cleanLastUpdateDateCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.lastUpdateDateModels.clear()); // Truncate collection
  }

  Future<void> cleanProjectCollection() async {
    final isar = await db;
    await isar.writeTxn(() => isar.projectModels.clear()); // Truncate collection
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

  Future<List<LeaveRequestModel>> getFilteredLeaves(
      LeaveRequestModel leaveRequestModels,String firebaseAuthId ) async {
    final isar = await db;
    return await isar.leaveRequestModels
        .filter()
        .staffIdEqualTo(firebaseAuthId!) // Correct filter method
        .findAll();

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



  Future<AttendanceModel?> getLastAttendanceFordate(String date) async {
    await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .dateEqualTo(date)
        .sortByDateDesc()
        .findFirst();
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

  Future<List<FacilityStaffModel>> getFacilityListForSpecificFacility1(
      String state,String facilityName) async {
    final isar = await db;
    return await isar.facilityStaffModels.filter().stateEqualTo(state).facilityNameEqualTo(facilityName).findAll();
  }



  Future<List<SurveyResultModel>> getUnsyncedSurveyResults() async {
    final isar = await db;
    return await isar.surveyResultModels.filter().isSyncedEqualTo(false).findAll();
  }

  Future<List<FacilityStaffModel>> getFacilityListForSpecificFacility() async {
    final isar = await db;

    try {
      final bioData = await isar.bioModels.filter().firebaseAuthIdIsNotNull().findAll();

      if (bioData.isNotEmpty) {
        print("bioDataState====${bioData[0].location}");

        final firstList =  await isar.facilityStaffModels.filter().stateEqualTo(bioData[0].state).facilityNameEqualTo(bioData[0].location).findAll();

        print("firstList====$firstList");
        // Filter out records matching bioData[0].firebaseAuthId
        final filteredList = firstList.where((staff) => staff.userId != bioData[0].firebaseAuthId).toList();
        print("filteredList====$filteredList");
        return filteredList;
      }
      return []; // Return empty list if no matching BioModel or no authIds
    } catch (e) {
      // Handle potential Isar errors
      log("Error in getFacilityListForSpecificFacility: $e");
      return []; // Return empty list in case of error
    }
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
  Future<List<AttendanceModel>> getAttendanceForId(int id) async {
    final isar = await db;
    return await isar.attendanceModels
        .filter()
        .idEqualTo(id)
        .isUpdatedEqualTo(true)
        .findAll();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<BioModel>> getBioForId() async {
    final isar = await db;
    return await isar.bioModels
        .filter()
        .idEqualTo(2)
        .isSyncedEqualTo(false)
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

  // Future<void> updateAppVersion(
  //     int id,
  //     AppVersionModel appVersionModels,
  //     DateTime appVersionDate) async {
  //   final isar = await db;
  //   final appVersionUpdate = await isar.appVersionModels.get(id);
  //
  //   appVersionUpdate!
  //     ..appVersionDate = appVersionDate;
  //
  //   await isar.writeTxn(() async {
  //     await isar.appVersionModels.put(appVersionUpdate);
  //   });
  // }


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

  Future<void> updateBioLocation(
      int id,
      BioModel bioModels,
      String location,
      bool isSynced) async {
    final isar = await db;
    final bioLocationUpdate = await isar.bioModels.get(id);

    bioLocationUpdate!
      ..location = location
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioLocationUpdate);
    });
  }

  Future<void> updateStaffCategoryLocation(
      int id,
      BioModel bioModels,
      String staffCategory,
      bool isSynced) async {
    final isar = await db;
    final bioLocationUpdate = await isar.bioModels.get(id);

    bioLocationUpdate!
      ..staffCategory = staffCategory
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioLocationUpdate);
    });
  }

  Future<void> updateBioDesignation(
      int id,
      BioModel bioModels,
      String designation,
      bool isSynced) async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(id);

    bioUpdate!
      ..designation = designation
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }

  Future<void> updateBioSignatureLinktoNull() async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(2);

    bioUpdate!
      ..signatureLink = null;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }

  Future<void> updateBioProject(
      int id,
      BioModel bioModels,
      String project,
      bool isSynced) async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(id);

    bioUpdate!
      ..project = project
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }


  Future<void> updateBioDetails(
      int id,
      BioModel bioModels,
      bool isSynced,
      String supervisor,
      String supervisorEmail,
      ) async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(id);

    bioUpdate!
      ..isSynced = isSynced
    ..supervisorEmail = supervisorEmail
    ..supervisor = supervisor
    ;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }

  Future<void> updateStateProject(
      int id,
      BioModel bioModels,
      String state,
      bool isSynced) async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(id);

    bioUpdate!
      ..state = state
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }

  Future<void> updateBioSupervisor(
      int id,
      BioModel bioModels,
      String supervisor,
      bool isSynced) async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(id);

    bioUpdate!
      ..supervisor = supervisor
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }

  Future<void> updateBioSupervisorEmail(
      int id,
      BioModel bioModels,
      String supervisorEmail,
      bool isSynced) async {
    final isar = await db;
    final bioUpdate = await isar.bioModels.get(id);

    bioUpdate!
      ..supervisorEmail = supervisorEmail
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioUpdate);
    });
  }

  Future<void> updateBioEmail(
      int id,
      BioModel bioModels,
      String emailAddress,
      bool isSynced) async {
    final isar = await db;
    final bioEmailUpdate = await isar.bioModels.get(id);

    bioEmailUpdate!
      ..emailAddress = emailAddress
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioEmailUpdate);
    });
  }

  Future<void> updateBioPhone(
      int id,
      BioModel bioModels,
      String mobile,
      bool isSynced) async {
    final isar = await db;
    final bioModelUpdate = await isar.bioModels.get(id);

    bioModelUpdate!
      ..mobile = mobile
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioModelUpdate);
    });
  }


  Future<void> updateBioDepartment(
      int id,
      BioModel bioModels,
      String department,
      bool isSynced) async {
    final isar = await db;
    final bioModelUpdate = await isar.bioModels.get(id);

    bioModelUpdate!
      ..department = department
      ..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(bioModelUpdate);
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

  Stream<List<LeaveRequestModel>> searchAllLeaveRequest(String staffId) {
    final controller = StreamController<List<LeaveRequestModel>>();

    Future<void> fetchAndEmitResults() async {
      final isar = await db; // Get your Isar instance

      final results = await isar.leaveRequestModels
          .filter()
          .staffIdEqualTo(staffId)
          .findAll();
      controller.add(results);
    }

    fetchAndEmitResults(); // Emit initial results

    db.then((isar) {
      final query = isar.leaveRequestModels
          .filter()
          .staffIdEqualTo(staffId)
          .build();

      query.watchLazy(fireImmediately: true).listen((_) async {
        await fetchAndEmitResults(); // Re-fetch and emit updates
      });
    });

    return controller.stream;
  }


  // Stream<List<AttendanceModel>> searchAllAttendance1({String? search}) async* {
  //   print(search);
  //   final isar = await db; // Assuming 'db' is a Future<Isar> instance
  //   final query = isar.attendanceModels
  //       .where()
  //       .filter() // This filter is currently empty. Add filtering logic if needed.
  //       .voidedEqualTo(false)
  //       .and()
  //       .dateContains(search ?? '', caseSensitive: false)
  //       .sortByDateDesc()
  //       .limit(5) // Limit the results to the last 3 records
  //       .build();
  //
  //   await for (final results in query.watch(fireImmediately: true)) {
  //     yield results; // No need to check if results.isNotEmpty
  //   }
  // }

  Stream<List<BioModel>> listenToBiometric1({String? search}) async* {

    final isar = await db;
    final query = isar.bioModels
        .where()
        .filter()
        .idEqualTo(2)
        .build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        print("BioModel from stream: $results");
        yield results;
      }
    }
  }

// In your IsarService class:
  Stream<BioModel?> listenToBiometric() async* {
    final isar = await db;
    await for (final changes in isar.bioModels.watchLazy()) {
      // Get the first result asynchronously
      final bioModel = await isar.bioModels.filter().idEqualTo(2).findFirst();
      print("BioModel from stream: $bioModel"); // Add this print statement

      yield bioModel;
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

  removeTask(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }

  removeAttendance(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.attendanceModels.delete(id);
    });
  }

  removeAllTask(AttendanceModel attendanceModel) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.tasks.filter().idGreaterThan(0).deleteAll();
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

  Future<void> updateSyncStatusForBio(
      int id,
      BioModel bioModels,
      bool isSynced,
      ) async {
    final isar = await db;
    final updateSyncStatus = await isar.bioModels.get(id);

    updateSyncStatus!..isSynced = isSynced;

    await isar.writeTxn(() async {
      await isar.bioModels.put(updateSyncStatus);
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
  //
  // Future<LastUpdateDateModel?> getLastUpdateDate() async {
  //   // Retrieve the last used date from Isar (implementation depends on your Isar setup)
  //   // Example: using a dedicated Isar object called 'AppUsage'
  //   final isar = await db;
  //   //return await isar.appUsageModels.where().findFirst();
  //   final lastUpdateDate = isar.lastUpdateDateModels.where().findFirst();
  //   return lastUpdateDate;
  // }

  // Future<List<AppVersionModel>> getAppVersionInfo() async {
  //   final isar = await db;
  //   return await isar.appVersionModels.where().findAll();
  // }

  Future<void> saveTask(Task newtask) async {
    // Save the current date in Isar (implementation depends on your Isar setup)
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.tasks.putSync(newtask));
  }

  Future<void> saveLastUsedDate(AppUsageModel newappusagemodel) async {
    // Save the current date in Isar (implementation depends on your Isar setup)
    final isar = await db;
    await isar.writeTxnSync<int>(() => isar.appUsageModels.putSync(newappusagemodel));
  }

  Future<void> saveLeaveRequest(LeaveRequestModel leaveRequest) async {
    final isar = await db;// Get the Isar instance
    await isar.writeTxn(() async {
      await isar.leaveRequestModels.put(leaveRequest); // Save the LeaveRequestModel
    });
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

  Future<List<BioModel>> getBioInfoForUser() async {
    final isar = await db;
    return await isar.bioModels
        .where()
        .filter()
        .firebaseAuthIdIsNotNull()
        .findAll();
  }



  Future<List<LastUpdateDateModel>> getUpdateDateInfo() async {
    final isar = await db;
    return await isar.lastUpdateDateModels.where().findAll();
  }

  Future<List<AppVersionModel>> getAppVersionInfo() async {
    final isar = await db;
    return await isar.appVersionModels.where().findAll();
  }

  Future<AppVersionModel?> getAppVersionInfo2() async {
    // Retrieve the last used date from Isar (implementation depends on your Isar setup)
    // Example: using a dedicated Isar object called 'AppUsage'
    final isar = await db;
    //return await isar.appUsageModels.where().findFirst();
    final appVersion = isar.appVersionModels.where().findFirst();
    return appVersion;
  }

  Future<List<BioModel>> getBioInfoWithUserBio() async {
    final isar = await db;
    return await isar.bioModels.where().filter().firebaseAuthIdIsNotNull().findAll();
  }

  Future<List<AppVersionModel>> getAppVersion() async {
    final isar = await db;
    return await isar.appVersionModels.where().filter().appVersionIsNotNull().findAll();
  }

  Future<List<BioModel>> getisSyncedForBio() async {
    final isar = await db;
    return await isar.bioModels.where().filter().isSyncedIsNull().idEqualTo(2).findAll();
  }

  Future<List<LastUpdateDateModel>> getLastUpdateDate() async {
    final isar = await db;
    return await isar.lastUpdateDateModels.where().filter().lastUpdateDateIsNotNull().findAll();
  }

  Future<LocationModel?> getLocationByName(var locationName) async {
    //await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.locationModels.filter().locationNameEqualTo(locationName).findFirst();

  }

  Future<BioModel?> getBioInfoWithFirebaseAuth() async {
    //await Future.delayed(const Duration(seconds: 1));
    final isar = await db;
    return await isar.bioModels.filter().firebaseAuthIdIsNotNull().findFirst();
    //where().sortByDateDesc().findFirst();
    // .AttendanceModel((q) => q.idEqualto(attendanceModel.id)).findAll();
  }

  Future<List<LeaveRequestModel>> getLeaveRequestModel() async {
    final isar = await db;
    return await isar.leaveRequestModels
        .filter()
        .isSyncedEqualTo(false)
        .and()
        .selectedSupervisorEmailEqualTo("appsupport@ccfng.org")
        .findAll();
  }


  @override
  Future<List<Uint8List>> getSignatureImages() {
    // TODO: implement getSignatureImages
    throw UnimplementedError();
  }

  @override
  Future<void> storeSignatureImage(Uint8List imageBytes) {
    // TODO: implement storeSignatureImage
    throw UnimplementedError();
  }

  @override
  Future<void> clearSignatureImages1() {
    // TODO: implement clearSignatureImages1
    throw UnimplementedError();
  }
}
