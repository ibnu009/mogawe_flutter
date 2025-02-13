import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mogawe/constant/api_path.dart';
import 'package:mogawe/core/data/request/reset_password_request.dart';
import 'package:mogawe/core/data/response/hire_me/category_list_response.dart';
import 'package:mogawe/core/data/response/hire_me/favorite_hire_me_sales_response.dart';
import 'package:mogawe/core/data/response/hire_me/hire_me_sales_response.dart';
import 'package:mogawe/core/data/response/pesona/detail_pesona_response.dart';
import 'package:mogawe/core/data/response/pesona/pesona_response.dart';
import 'package:mogawe/core/data/response/reset_password_response.dart';
import 'package:mogawe/core/data/response/user_login_response.dart';
import 'package:mogawe/core/data/response/user_profile_response.dart';
import 'package:mogawe/core/data/response/user_response.dart';

class UserNetworkService {
  Future<UserResponse> fetchVersion(int versionNumber) async {
    final response = await http.get(Uri.parse(
        "$BASE_URL/api/mogawers/versionCheckerV2?versionNumber=$versionNumber"));
    if (response.statusCode == 200) {
      return UserResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Terjadi kegagalan');
    }
  }

  Future<UserLoginResponse> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/mogawers/logIn/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return UserLoginResponse.fromJson(json.decode(response.body));
  }

  Future<UserLoginResponse> loginUserFacebook(String email, String id, String nama) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/mogawers/logInSocMed"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'fullName': nama, 'email': email, 'idFacebook': id}),
    );
    return UserLoginResponse.fromJson(json.decode(response.body));
  }

  Future<UserLoginResponse> loginUserTwitter(String email, String id, String nama) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/mogawers/logInSocMed"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'fullName': nama, 'email': email, 'idTwitter': id}),
    );
    return UserLoginResponse.fromJson(json.decode(response.body));
  }

  Future<UserProfileResponse> profileUser(String token) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/mogawers/v2/getProfile"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8','token': '$token'
      },
      body: jsonEncode(<String, String>{'token': token}),
    );
    return UserProfileResponse.fromJson(json.decode(response.body));
  }

  Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest request) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/mogawers/forgotPassword/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );
    return ResetPasswordResponse.fromJson(json.decode(response.body));
  }
  //
  // Future<PesonaResponses> pesonaresponse(String token) async {
  //   final response = await http.post(
  //     Uri.parse("$BASE_URL/api/mogawers/certificate/mine"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8','token': '$token'
  //     },
  //     body: jsonEncode(<String, String>{'token': token}),
  //   );
  //   return PesonaResponses.fromJson(json.decode(response.body));
  // }

  Future<PesonaResponses> pesonaresponse(token) async {

    print(token);
    final requestUrl = '$BASE_URL/api/mogawers/certificate/mine';
    final response = await http.get(Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8','token': '$token'
      },

    );

    final maps = json.decode(response.body);
    if (maps.isNotEmpty) {
      return PesonaResponses.fromJson(maps);
    }

    else {
      throw Exception('not found');
    }
  }

  Future<HireMeSalesResponses> hiremeSalesresponse(token) async {

    print(token);
    final requestUrl = '$BASE_URL/api/sales/product/get?page=1&offset=30';
    final response = await http.get(Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8','token': '$token'
      },

    );

    final maps = json.decode(response.body);
    if (maps.isNotEmpty) {
      return HireMeSalesResponses.fromJson(maps);
    }

    else {
      throw Exception('not found');
    }
  }

  Future<HireMeSalesResponses> CategoryhiremeSalesresponse(token, uuid) async {

    print(token);
    final requestUrl = '$BASE_URL/api/sales/product/get?uuidCategory=$uuid&page=1&offset=30';
    final response = await http.get(Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8','token': '$token'
      },

    );

    final maps = json.decode(response.body);
    if (maps.isNotEmpty) {
      return HireMeSalesResponses.fromJson(maps);
    }

    else {
      throw Exception('not found');
    }
  }

  Future<FavHireMeSalesResponses> favhiremeSalesresponse(token) async {

    print(token);
    final requestUrl = '$BASE_URL/api/sales/product/favorite/get?q=&page=1&offset=20';
    final response = await http.get(Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8','token': '$token'
      },

    );

    final maps = json.decode(response.body);
    if (maps.isNotEmpty) {
      return FavHireMeSalesResponses.fromJson(maps);
    }

    else {
      throw Exception('not found');
    }
  }

  Future<DetailPesonaResponses> detailpesonaresponse(token, uuidjob) async {
    final requestUrl = '$BASE_URL/api/fieldtask/job/get/$uuidjob';
    final response = await http.get(Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8','token': '$token'
      },

    );

    final maps = json.decode(response.body);
    if (maps.isNotEmpty) {
      return DetailPesonaResponses.fromJson(maps);
    }

    else {
      throw Exception('not found');
    }
  }

  Future<HireMeSalesResponses> postFavHireMeSales(bool fav, String token, String uuid) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/sales/product/favorite/$uuid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', 'token': '$token'
      },
      body: jsonEncode(<String, String>{'isFavorite': fav.toString()}),
    );
    return HireMeSalesResponses.fromJson(json.decode(response.body));
  }

  Future<HireMeSalesResponses> deleteFavHireMeSales(bool fav, String token, String uuid) async {
    final response = await http.delete(
      Uri.parse("$BASE_URL/api/sales/product/favorite/$uuid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', 'token': '$token'
      },
      body: jsonEncode(<String, String>{'isFavorite': fav.toString()}),
    );
    return HireMeSalesResponses.fromJson(json.decode(response.body));
  }

  Future<CategoryListResponse> getCategory(String token) async {
    final requestUrl = '$BASE_URL/api/sales/product/category/get';
    final response = await http.get(Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', 'token': '$token'
      },

    );

    final maps = json.decode(response.body);
    if (maps.isNotEmpty) {
      return CategoryListResponse.fromJson(maps);
    }

    else {
      throw Exception('not found');
    }
  }

}
