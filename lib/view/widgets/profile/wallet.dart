import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/constant/color.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              child: Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "58".tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white, // لون النص
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: Text(
                '60.00',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // يمكنك تغيير اللون حسب الحاجة
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
