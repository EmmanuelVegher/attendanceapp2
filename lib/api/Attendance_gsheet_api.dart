import 'package:attendanceapp/model/attendance_gsheet_model.dart';
import 'package:gsheets/gsheets.dart';

class AttendanceGSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "caritas-attendance-sheet",
  "private_key_id": "cc3de8b8550c47d99ab4ebc808215c87a333a8cc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCgcSSKj1sTW4So\nF6ERO/QOqOnzk4HouNkt/vBEJiZIDqKimDHd8MKi2uZyXWF0rNiwb0NDwAvWe6Fc\nsg0Ase2fuWVazXaHL0ZDgoAUMKBfuvMtTSD2ty00fNLUpEtS7EKOwJd7jbaaK6CH\ntZoMB2UZkDXs9z7Ih4T/myMlYO0W59tt1ZHSnPcflnLD2vlCQ60/5kTAek29xVBi\nW/O0C+3ewOLoI0Bxw4uGYe8puf5FPAYeOKrzpv7kQxRxwKvf2IGU3Xx/4TRSh9lm\n+FS62koulrWxpED75z4F/NKcntk5Lr7IW0AJLORrN8YxFPZxoxN5C4d0AN+9j219\nfK9ijUwTAgMBAAECgf9L8K9xA1OquKarI9R/U8tc29iBTWZUcHpbfjnUxg35ewKH\nCTl7SGQLJl4ZFBn+H7SrWSMXBD03FMm5ZsfIF2hpIvh3PLphJOHp3yQuEn5LRoIr\nXMQnjbDJPSc9CdcvjUVSspQWuzASEh9BUAtm2VsIX20JkI/H5Z8GrZNqJR7C4+Mg\nm7J1nvZdw0yQbFmSO/asx602KAHHaBk/pmeSmEQmlgACuP6mlAS84NHM580vhJ5c\nvHj3h5SRhVs5dkVT4xMIIx/by/kQ61PLRt0RxPvt8EFniwvTYtFzTfhYGpYSiPtJ\nixALGlzbznjemxxbwoMMEYHyBAPpYMj/B1jw6nkCgYEA3kdbbniNPsE9aDLUoKcS\nj3feQwtxnrKy0mZokGvo1hvId2YD6IKUOat7cpLxQ64LM3/OjQ8pt+xHXZHqTxfP\nv5Q0k59cKxBQEu0J0GPXcyKWAYAF2pYQyrY8c75Pwfw6NYpt/RSZDiOl9oKkYdgO\n6i5irKgex8U7+7nAtSDxO00CgYEAuMg602ipTFh4K9wo70jE9m96IpAFr9gY2PSS\n/wf48Al8LQopxmUSI42NTLxtk5WrpxvDcOpXDt2C59LSDnOs4YCqY/dh9YICEOf3\nBvVk/4XMR7iX9HAICVuQlH0WvOy3wdC1K1JF9Km5ftCujfmWjEXAXwXfhVIKI+Pg\n6wxbNN8CgYBu2XEsb2wpDp98FlVZZNhpueKa1tsrxHxPVwjwdRAhrqtTeAmc63nW\nJMGkislM8j/dx/APAq/QbEHO1RTfqsVNCjEKKaACTdlRBustBI2OeoIKb3j74Hix\nTx5orlECMbIpv0ZIvvvxRC/g9pfZv7D4cnd9GT54a9EVITaMXchPxQKBgCnOw+CJ\nUaTAb5Ac4/Yf1NCdMFkZlO/QSO7th0TEnQJSYxIdto342D3LDSlLiM9XkdrhYTrv\nCnuGitPA014JthffcK3ljvhpTeZdVXrxksRtlWa00Uyw/GCBoxi1pKtiM8FaY2NF\n3iYZMKsMtDHTQsjCD2Bwh742bazpJj6IMSqpAoGBAJ9BQQufLHQ787fMg9o5dZRB\nOTReKOMhk01xKuDAfis2ijTuXY/DwSv/DDuIdyminEojAw8etUVj0qV8XRDhoBlc\np1SxhfyY+J9eDd3LhE0shhXtzAMkz0QZYeafmtM0K5iXO/dg7SfPBf1Owe2deztK\nmvfaEQAlAaACyoqWijDU\n-----END PRIVATE KEY-----\n",
  "client_email": "caritas-attendance-sheet@caritas-attendance-sheet.iam.gserviceaccount.com",
  "client_id": "103835725861162059945",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/caritas-attendance-sheet%40caritas-attendance-sheet.iam.gserviceaccount.com"
}

''';
  static const _spreadsheetId = '1x1G3Kbo9OpZzBzVF2vvPSxffBnA48R_YFwkVdpX8ads';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _attendanceSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _attendanceSheet = await _getWorkSheet(spreadsheet, title: 'Attendance');
      final firstRow = UserFields.getFields();
      _attendanceSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    //Create the worksheet if it doesnt exit..Use the try catch block to catch incase it exist
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    //Check first if the row is existing
    if (_attendanceSheet == null) return;
    _attendanceSheet!.values.map.appendRows(rowList);
  }

  static Future<int> getRowCount() async {
    //Check first if the row is existing
    if (_attendanceSheet == null) return 0;
    final lastRow = await _attendanceSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future<User?> getById(int id) async {
//Check first if the row is existing
    if (_attendanceSheet == null) return null;

    final json = await _attendanceSheet!.values.map.rowByKey(id, fromColumn: 1);
    return json == null ? null : User.fromJson(json);
  }

  static Future<bool> update(int id, Map<String, dynamic> user) async {
    if (_attendanceSheet == null) return false;
    return _attendanceSheet!.values.map.insertRowByKey(id, user);
  }
}
