import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/view/screen/homepage.dart';
import 'package:go_go/view/screen/resturant_list_screen.dart';
import 'package:go_go/view/widgets/home_page/custombottomappbarhome.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllerImp());
    return GetBuilder<HomeScreenControllerImp>(
        builder: (controller) => Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              backgroundColor: controller.showHomePage == false
                  ? Colors.white
                  : AppColor.primaryColor,
              onPressed: () {
                controller.toggleShowHomePage();
              },
              shape: CircleBorder(),
              child: Icon(Icons.store,
                  color: controller.showHomePage == false
                      ? AppColor.primaryColor
                      : Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: const CustomBottomAppBarHome(),
            body: HandlingDataRequest(
              statusRequest: controller.statusRequest,
              widget: controller.showHomePage == true
                  ? HomePage()
                  : controller.showcategoryList == true
                      ? RestaurantListScreen(
                          image: controller.image ?? '',
                          type: controller.type ?? '',
                        )
                      : controller.listPage.elementAt(controller.currentpage!),
            )));
  }
}
