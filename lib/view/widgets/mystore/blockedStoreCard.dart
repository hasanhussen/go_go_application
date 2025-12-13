import 'package:flutter/material.dart';
import 'package:go_go/controller/my_stores_controller.dart';
import 'package:go_go/data/model/my_store_model.dart';

class BlockedStoreCard extends StatelessWidget {
  final MyStoreModel store;
  final MyStoresController controller;

  const BlockedStoreCard({
    super.key,
    required this.store,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white, // خلفية بيضاء
          border: Border.all(color: Colors.red.shade400, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.block, color: Colors.red.shade700, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    store.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (store.banReason != null)
              Text(
                "📄 السبب: ${store.banReason}",
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                softWrap: true,
              ),
            const SizedBox(height: 6),
            // التاريخ وزر الاعتراض في Row واحد
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (store.banUntil != null)
                  Text(
                    "⏱ حتى: ${store.banUntil}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                // ElevatedButton.icon(
                //   onPressed: () => showAppealDialog(context,
                //       controller: controller, storeId: store.id!),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.red,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(6)),
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     minimumSize: const Size(60, 30),
                //   ),
                //   icon: const Icon(Icons.flag, color: Colors.white, size: 16),
                //   label: const Text(
                //     "اعتراض",
                //     style: TextStyle(color: Colors.white, fontSize: 12),
                //   ),
                // ),
              ],
            ),
            if (store.appeal != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "📄 تم تقديم طلب استئناف",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ),
          ],
        ));
  }
}
