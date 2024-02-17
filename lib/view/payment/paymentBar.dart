// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_pos/theme/palette.dart';

class PaymentBar extends StatelessWidget {
  const PaymentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.textColor,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // only one edge is rounded
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                      '\$100.00',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'PAY',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        // split cents and dollars
                        Text(
                          '\$100.00',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
