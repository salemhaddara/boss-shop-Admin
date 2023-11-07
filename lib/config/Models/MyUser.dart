import 'package:bossshopadmin/config/Models/MyOrder.dart';

class MyUser {
  String name, id, email;
  List<Map<String, dynamic>> notifications = List.empty();
  List<MyOrder> mybuyedthings = List.empty();
  MyUser({
    required this.name,
    required this.id,
    required this.email,
    required this.notifications,
    required this.mybuyedthings,
  });
}
