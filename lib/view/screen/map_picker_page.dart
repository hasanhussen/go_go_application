import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/add_store_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatelessWidget {
  const MapPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddStoreController>();

    return FutureBuilder(
      future: controller.getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.selectedLocation == null) {
          return const Scaffold(
            body: Center(child: Text("تعذر الحصول على الموقع")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("اختر الموقع")),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.selectedLocation!,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("picked"),
                position: controller.selectedLocation!,
                draggable: true,
                onDragEnd: (newPos) {
                  controller.selectedLocation = newPos;
                },
              )
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.back();
            },
            label: const Text("تأكيد الموقع"),
            icon: const Icon(Icons.check),
          ),
        );
      },
    );
  }
}
