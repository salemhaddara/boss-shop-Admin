import 'package:bossshopadmin/Features/AllUsersWidgets/UserWidget.dart';
import 'package:bossshopadmin/Features/AllUsersWidgets/basicInfo.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/CategoryViewer.dart';
// import 'package:bossshopadmin/Features/Productsmanager/allProducts.dart';
import 'package:bossshopadmin/Features/requests/AllRequests.dart';
import 'package:bossshopadmin/config/Models/MyOrder.dart';
import 'package:bossshopadmin/config/Models/MyUser.dart';
import 'package:bossshopadmin/config/Widgets/button.dart';
import 'package:bossshopadmin/config/Widgets/searchbar.dart';
import 'package:bossshopadmin/config/Widgets/text700normal.dart';
import 'package:bossshopadmin/core/theme/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<MyUser> allusers = [];
  List<MyUser> filteredusers = [];
  MyUser? userchosen;
  bool isShown = false;

  @override
  void initState() {
    super.initState();
    getAllUsersFromCustomersCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Allrequests();
          }));
        },
        child: SvgPicture.asset('assets/images/request.svg'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!isShown)
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: button(
                          text: 'Products',
                          width: MediaQuery.of(context).size.width,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return categoryViewer(
                                category: 'all',
                                title: 'All Products',
                              );
                            }));
                          }),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: text700normal(
                        fontsize: 25,
                        color: darkblack,
                        text: 'All Users',
                      ),
                    ),
                    searchbar(
                      hint: 'Search by name',
                      onChanged: (text) {
                        if (text != null && text.isNotEmpty) {
                          setState(() {
                            filteredusers = allusers.where((element) {
                              return element.name.toLowerCase().contains(text);
                            }).toList();
                          });
                        } else {
                          setState(() {
                            filteredusers = allusers;
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: filteredusers.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                userchosen = filteredusers[index];
                                isShown = true;
                              });
                            },
                            child: basicInfo(user: filteredusers[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (isShown)
              Expanded(
                child: Container(
                  color: Colors.amber,
                  child: ColoredBox(
                    color: Colors.amber,
                    child: Column(
                      children: [
                        button(
                          text: 'Hide',
                          width: MediaQuery.of(context).size.width,
                          onTap: () {
                            setState(() {
                              isShown = false;
                            });
                          },
                        ),
                        Expanded(
                          child: UserWidget(user: userchosen!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getAllUsersFromCustomersCollection() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('customers').get();

      List<MyUser> users = querySnapshot.docs.map((documentSnapshot) {
        final userData = documentSnapshot.data() as Map<String, dynamic>;
        return MyUser(
          name: userData['name'],
          id: userData['id'],
          email: userData['email'],
          notifications:
              List<Map<String, dynamic>>.from(userData['notifications']),
          mybuyedthings: List<MyOrder>.from(
            userData['mybuyedthings'].map(
              (myOrderData) => MyOrder.fromMap(myOrderData),
            ),
          ),
        );
      }).toList();

      setState(() {
        allusers = users;
        filteredusers = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
      // Handle the error as needed
    }
  }
}
