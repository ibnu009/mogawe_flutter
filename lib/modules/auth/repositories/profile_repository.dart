import 'dart:io';

import 'package:mogawe/constant/api_path.dart';
import 'package:mogawe/core/data/response/profile/profile_history_response.dart';
import 'package:mogawe/core/data/response/profile/profile_response.dart';
import 'package:mogawe/core/data/response/register/register_response.dart';
import 'package:mogawe/core/data/sources/network/network_service.dart';

class ProfileRepository extends NetworkService {
  ProfileRepository();

  ProfileRepository._privateConstructor();
  static final ProfileRepository _instance = ProfileRepository._privateConstructor();
  static ProfileRepository get instance => _instance;

  Map<String, String> header = Map();
  final String contentType = "Content-Type";
  final String applicationJson = "application/json; charset=UTF-8";
  final String token = "token";

  //Static token for testing only
  final String userToken = "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJNTy00MjFCM0E"
      "iLCJpYXQiOjE2MzQ1MjkxMzEsInN1YiI6Im1vZ2F3ZXJzIiwiaXNzIjoibW9nYXdlIn0."
      "6I3GpI_gB02jpicmXzotWg4webpBU_3kpwFhWAF57bU";

  Future<ProfileResponse> getProfile({String? realToken}) async {
    var header = {token: userToken}; //Use realToken when implement get from original token
    var map = await postMethod("${BASE_URL}api/mogawers/v2/getProfile", headers: header);
    return ProfileResponse.fromJsonMap(map);
  }

  Future<List<ProfileHistoryData>> getProfileHistory({String? realToken,
    String? page, String? periode}) async {
    var header = { token: userToken }; //Use realToken when implement get from original token
    var map = await getMethod("${BASE_URL}api/fieldresult/history?"
        "page=${page ?? "1"}&offset=20&periode=${periode ?? "all"}", header);
    return ProfileHistoryResponse.fromJsonMap(map).object;
  }

  Future<RegisterResponse> updateProfile(Map<String, String>? body, {String? realToken}) async {
    var header = {
      token: userToken, //Use realToken when implement get from original token
      contentType: applicationJson
    };
    var map = await postMethod("${BASE_URL}api/mogawers/updateProfile",
        headers: header, body: body);
    return RegisterResponse.fromJsonMap(map);
  }

  Future<RegisterResponse> updateTargetRevenue(Map<String, dynamic>? body, {String? realToken}) async {
    var header = {
      token: userToken, //Use realToken when implement get from original token
      contentType: applicationJson
    };
    var map = await putMethod("${BASE_URL}api/mogawers/config/update",
        header: header, body: body);
    return RegisterResponse.fromJsonMap(map);
  }

  Future<RegisterResponse> updatePhotoProfile(Map<String, File> body, {String? relToken}) async {
    var header = { token: userToken }; //Use realToken when implement get from original token
    var map = await multipartPost("${BASE_URL}api/mogawers/updatePhotoProfile",
      files: body, header: header);
    return RegisterResponse.fromJsonMap(map);
  }

}