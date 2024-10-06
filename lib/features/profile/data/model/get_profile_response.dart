import 'package:final_flashcard/features/profile/data/model/profile_model.dart';

class GetProfileResponse {
  ProfileModel? data;
  bool? success;
  int? code;

  GetProfileResponse({this.data, this.success, this.code});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProfileModel.fromJson(json['data']) : null;
    success = json['success'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['code'] = code;
    return data;
  }
}
