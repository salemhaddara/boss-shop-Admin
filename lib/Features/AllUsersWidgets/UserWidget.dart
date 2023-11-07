import 'package:bossshopadmin/config/Models/MyUser.dart';
import 'package:bossshopadmin/config/Widgets/text400normal.dart';
import 'package:bossshopadmin/config/Widgets/text600normal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserWidget extends StatefulWidget {
  final MyUser user;
  const UserWidget({super.key, required this.user});

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  int currentCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        margin: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Info'),
                      Tab(text: 'Notifications'),
                      Tab(text: 'Bought Things'),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    onTap: (index) {
                      setState(() {
                        currentCategoryIndex = index;
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: TabBarView(
                      children: [
                        // Info Category
                        ListView(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            text600normal(
                              text: 'Name: ${widget.user.name}',
                              fontsize: 18.0,
                              color: Colors.black,
                              align: TextAlign.center,
                            ),
                            text600normal(
                              text: 'ID: ${widget.user.id}',
                              fontsize: 18.0,
                              color: Colors.black,
                              align: TextAlign.center,
                            ),
                            text600normal(
                              text: 'Email: ${widget.user.email}',
                              fontsize: 18.0,
                              color: Colors.black,
                              align: TextAlign.center,
                            ),
                          ],
                        ),
                        // Notifications Category
                        ListView(
                          children:
                              widget.user.notifications.map((notification) {
                            return Card(
                              // Wrap with Card to provide constraints
                              elevation: 2,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  text400normal(
                                    text: notification['NotificationText'],
                                    fontsize: 16.0,
                                    color: Colors.black,
                                  ),
                                  text400normal(
                                    text: (notification['NotificationTime']
                                            as Timestamp)
                                        .toDate()
                                        .toString(),
                                    fontsize: 16.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        // Bought Things Category
                        ListView(
                          children: widget.user.mybuyedthings.map((myOrder) {
                            return Card(
                              // Wrap with Card to provide constraints
                              elevation: 2,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  text400normal(
                                    text:
                                        'Product: ${myOrder.product.productName}',
                                    fontsize: 16.0,
                                    color: Colors.black,
                                  ),
                                  text400normal(
                                    text: 'Time: ${myOrder.time.toString()}',
                                    fontsize: 16.0,
                                    color: Colors.black,
                                  ),
                                  text400normal(
                                    text: 'Status: ${myOrder.status}',
                                    fontsize: 16.0,
                                    color: Colors.black,
                                  ),
                                  text400normal(
                                    text:
                                        'Payment Method: ${myOrder.paymentMethod}',
                                    fontsize: 16.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
