import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_go/controller/my_stores_controller.dart';
import 'package:go_go/core/functions/showAppeaDialog.dart';
import 'package:go_go/data/model/my_store_model.dart';

class Rejectedstorecard extends StatelessWidget {
  final MyStoreModel store;
  final MyStoresController controller;
  const Rejectedstorecard(
      {super.key, required this.store, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(store.name ?? "",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("❌ تم رفض أو حذف هذا المتجر",
              style: TextStyle(color: Colors.red)),
          if (store.rejectionReason != null)
            Text("📄 السبب: ${store.rejectionReason}",
                style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => showAppealDialog(context,
                  controller: controller, storeId: store.id!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.flag, color: Colors.white, size: 20),
              label:
                  const Text("اعتراض", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 8),
          if (store.appeal != null)
            Text("📄تم تقديم طلب استئناف",
                style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
