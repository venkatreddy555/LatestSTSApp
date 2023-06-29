import 'package:shared_preferences/shared_preferences.dart';

class SaveSharedPreference{
  static String TokenData='TokenData';
  static String MobileNumber='MobileNumber';
  static String UserId='UserId';
  static String Username='Username';
  static String RoleId='RoleId';
  static String EmployeeId='EmployeeId';
  static String BranchId='BranchId';
  static String VehicleID='VehicleID';
  static String RouteId='RouteId';

  // Write Token DATA
  static Future<bool> saveTokenData(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(TokenData, token);
  }

// Read Token Data
  static Future getTokenData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(TokenData);
  }
  // Write MobileNumber DATA
  static Future<bool> saveMobileNumber(mobilenumber) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(MobileNumber, mobilenumber);
  }
// Read MobileNumber Data
  static Future getMobileNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(MobileNumber);
  }


  // Write MobileNumber DATA
  static Future<bool> saveUserId(userid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(UserId, userid);
  }
// Read MobileNumber Data
  static Future getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(UserId);
  }

  // Write MobileNumber DATA
  static Future<bool> saveUsername(username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(Username, username);
  }
// Read MobileNumber Data
  static Future getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(Username);
  }

  // Write RoleId DATA
  static Future<bool> saveRoleId(roleId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(RoleId, roleId);
  }
// Read RoleId Data
  static Future getRoleId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(RoleId);
  }

  // Write RoleId DATA
  static Future<bool> saveEmployeeId(employeeId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(EmployeeId, employeeId);
  }
// Read RoleId Data
  static Future getEmployeeId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(EmployeeId);
  }

  // Write BranchId DATA
  static Future<bool> saveBranchId(branchId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(BranchId, branchId);
  }
// Read BranchId Data
  static Future getBranchId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(BranchId);
  }

  // Write VehicleID DATA
  static Future<bool> saveVehicleId(Vehicleid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(VehicleID, Vehicleid);
  }
// Read VehicleID Data
  static Future getVehicleId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(VehicleID);
  }

  // Write RouteId DATA
  static Future<bool> saveRouteId(routeId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(RouteId, routeId);
  }
// Read RouteId Data
  static Future getRouteId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(RouteId);
  }
}

