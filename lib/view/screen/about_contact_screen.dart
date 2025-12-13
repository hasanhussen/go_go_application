import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/about_contact_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/class/statusrequest.dart';

class AboutContactScreen extends StatelessWidget {
  AboutContactScreen({super.key});

  final controller = Get.put(AboutContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('مـن نـحـن',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 18, color: Colors.red),
                  ),
                  // const Text("طلب جديد", style: TextStyle(color: Colors.red, fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
      body: GetBuilder<AboutContactController>(
        builder: (_) {
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(" "),
                  card(
                    child: Text(
                      controller.appDescription,
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                  SizedBox(height: 25),
                  sectionTitle("معلومات التواصل"),
                  card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoRow(
                          icon: Icons.phone,
                          text: controller.phone,
                          onTap: () => controller.callNumber(controller.phone),
                        ),
                        infoRow(
                          icon: Icons.email,
                          text: controller.email,
                          onTap: () => controller.sendEmail(controller.email),
                        ),
                        infoRow(
                          icon: Icons.location_on,
                          text: controller.address,
                          onTap: () => controller.openMap(controller.address),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  sectionTitle("تابعنا على"),
                  card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (controller.facebook.isNotEmpty)
                          socialButton(
                            icon: Icons.facebook,
                            label: "Facebook",
                            onTap: () => open(controller.facebook),
                          ),
                        if (controller.instagram.isNotEmpty)
                          socialButton(
                            icon: FontAwesomeIcons.instagram,
                            label: "Instagram",
                            onTap: () => open(controller.instagram),
                          ),
                        if (controller.whatsapp.isNotEmpty)
                          socialButton(
                            icon: FontAwesomeIcons.whatsapp,
                            label: "WhatsApp",
                            onTap: () => open(controller.whatsapp),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.red,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            spreadRadius: .5,
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget infoRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 22),
            SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(fontSize: 15))),
          ],
        ),
      ),
    );
  }

  Widget socialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red.withOpacity(.1),
            child: Icon(icon, color: Colors.red, size: 26),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  void open(String url) {
    controller.open(url);
  }
}
