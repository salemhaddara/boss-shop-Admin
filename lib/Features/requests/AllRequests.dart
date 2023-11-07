// ignore_for_file: use_build_context_synchronously, avoid_print, depend_on_referenced_packages, library_private_types_in_public_api

import 'package:bossshopadmin/config/Models/NotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bossshopadmin/config/Models/MyOrder.dart';
import 'package:bossshopadmin/config/Models/MyUser.dart';

class Allrequests extends StatefulWidget {
  const Allrequests({Key? key}) : super(key: key);

  @override
  _AllrequestsState createState() => _AllrequestsState();
}

class _AllrequestsState extends State<Allrequests> {
  List<MyOrder> orders = [];
  String selectedStatus = 'en attente de paiement';

  @override
  void initState() {
    super.initState();
    getAllUsersFromCustomersCollection();
  }

  void getAllUsersFromCustomersCollection() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('customers').get();

      for (var documentSnapshot in querySnapshot.docs) {
        final userData = documentSnapshot.data() as Map<String, dynamic>;
        MyUser(
          name: userData['name'],
          id: userData['id'],
          email: userData['email'],
          notifications:
              List<Map<String, dynamic>>.from(userData['notifications']),
          mybuyedthings: List<MyOrder>.from(userData['mybuyedthings'].map(
            (myOrderData) {
              final order = MyOrder.fromMap(myOrderData);
              orders.add(order);
              return order;
            },
          )),
        );
      }
      setState(() {});
    } catch (e) {
      print('Error fetching users: $e');
      // Handle the error as needed
    }
  }

  void updateOrderStatus(String newStatus, MyOrder selectedOrder) async {
    // Update the status in the local order list
    setState(() {
      selectedOrder.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders =
        orders.where((order) => order.status == selectedStatus).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Dropdown for selecting the status
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (newStatus) {
                setState(() {
                  selectedStatus = newStatus!;
                });
              },
              items: [
                'en attente de paiement',
                'commandea vérifiée',
                'quitté le pays de fabrication',
                'parvenues aux douaniers',
                'arrivé à votre logement',
              ]
                  .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                            order: order,
                            onStatusChange: (newStatus) {
                              updateOrderStatus(newStatus, order);
                            },
                          ),
                        ),
                      );
                    },
                    child: OrderRequest(
                      myOrder: order,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderRequest extends StatelessWidget {
  final MyOrder myOrder;

  const OrderRequest({Key? key, required this.myOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${myOrder.name}', style: const TextStyle(fontSize: 18)),
          Text('Order ID: ${myOrder.orderId}',
              style: const TextStyle(fontSize: 18)),
          Text('Time: ${myOrder.time}', style: const TextStyle(fontSize: 18)),
          Text('Quantity: ${myOrder.quantity}',
              style: const TextStyle(fontSize: 18)),
          Text('State: ${myOrder.state}', style: const TextStyle(fontSize: 18)),
          Text('Zip Code: ${myOrder.zipcode}',
              style: const TextStyle(fontSize: 18)),
          Text('Phone Number: ${myOrder.phoneNumber}',
              style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final MyOrder order;
  final Function(String) onStatusChange;

  const OrderDetailScreen(
      {Key? key, required this.order, required this.onStatusChange})
      : super(key: key);

  Future<void> _updateStatusAndNavigate(
      BuildContext context, String newStatus) async {
    await onStatusChange(newStatus);
    updateOrderStatus(newStatus, order.userId, order, context);
  }

  void updateOrderStatus(String newStatus, String userId, MyOrder selectedOrder,
      BuildContext context) async {
    final userRef = FirebaseFirestore.instance
        .collection('customers')
        .where('id', isEqualTo: userId);

    try {
      QuerySnapshot querySnapshot = await userRef.get();

      if (querySnapshot.size > 0) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data() as Map<String, dynamic>;
        final orders =
            List<Map<String, dynamic>>.from(userData['mybuyedthings']);
        final selectedOrderIndex = orders.indexWhere(
            (orderData) => orderData['orderId'] == selectedOrder.orderId);

        if (selectedOrderIndex != -1) {
          orders[selectedOrderIndex]['status'] = newStatus;

          final notificationMessage =
              "Le statut de la commande ${selectedOrder.orderId} a été changé en $newStatus.";

          final notification = NotificationModel(
            NotificationText: notificationMessage,
            NotificationTime: DateTime.now(),
          );
          userData['notifications'].add(notification.toMap());

          await userDoc.reference.update({
            'mybuyedthings': orders,
            'notifications': userData['notifications'],
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Allrequests(),
            ),
          );
        } else {
          print('Selected order not found in mybuyedthings list');
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: order.status,
            onChanged: (newStatus) {
              _updateStatusAndNavigate(context, newStatus!);
            },
            items: [
              'en attente de paiement',
              'commandea vérifiée',
              'quitté le pays de fabrication',
              'parvenues aux douaniers',
              'arrivé à votre logement',
            ]
                .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
