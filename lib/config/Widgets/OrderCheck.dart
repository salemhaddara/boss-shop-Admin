// ignore_for_file: must_be_immutable

import 'package:bossshopadmin/config/Models/Product.dart';
import 'package:bossshopadmin/config/Widgets/text700normal.dart';
import 'package:bossshopadmin/core/theme/MyColors.dart';
import 'package:flutter/material.dart';

class OrderCheck extends StatelessWidget {
  final Product product;
  final double screenWidth;
  Function(String productId) onDeleteClicked;
  OrderCheck(
      {super.key,
      required this.product,
      required this.screenWidth,
      required this.onDeleteClicked});

  @override
  Widget build(BuildContext context) {
    double widgetWidth = (screenWidth - 32);
    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            )),
        width: widgetWidth,
        child: Row(children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: Image.network(
                product.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 5),
                      width: (widgetWidth / 2),
                      child: text700normal(
                        text: product.productName,
                        color: darkblack,
                        fontsize: 16,
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      width: (widgetWidth / 2),
                      child: Text(
                        '${product.price.toString()} \$',
                        style: TextStyle(color: orange, fontFamily: 'horizon'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    onDeleteClicked(product.productId);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: const Icon(Icons.delete)))
        ]),
      ),
    );
  }
}
