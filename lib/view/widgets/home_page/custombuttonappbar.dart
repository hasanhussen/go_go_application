import 'package:flutter/material.dart';
import 'package:go_go/core/constant/color.dart';

class CustomButtonAppBar extends StatelessWidget {
  final void Function()? onPressed;
  final String textbutton;
  final IconData icondata;
  final bool? active;
  final int notificationCount; // 👈 أضفنا هذا المتغير لعدد الإشعارات

  const CustomButtonAppBar({
    Key? key,
    required this.textbutton,
    required this.icondata,
    required this.onPressed,
    required this.active,
    this.notificationCount = 0, // 👈 القيمة الافتراضية صفر
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icondata,
                  color:
                      active == true ? AppColor.primaryColor : AppColor.grey2,
                  size: 28,
                ),
                if (icondata == Icons.notifications && notificationCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          notificationCount > 99 ? '99+' : '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Text(
            //   textbutton,
            //   style: TextStyle(
            //     color: active == true
            //         ? AppColor.primaryColor
            //         : AppColor.grey2,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
