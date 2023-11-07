import 'package:bossshopadmin/config/Models/MyUser.dart';
import 'package:bossshopadmin/core/utils/Backend/Backend.dart';

class UsertoMap {
  static Map<String, dynamic> convert(MyUser user) {
    Map<String, dynamic> map = {
      Backend.idField: user.id,
      Backend.nameField: user.name,
      Backend.emailField: user.email,
      Backend.mybuyedthings: user.mybuyedthings,
      Backend.notifications: user.notifications
    };
    return map;
  }
}
