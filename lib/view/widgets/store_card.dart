import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'package:go_go/linkapi.dart';

class StoreCard extends StatelessWidget {
  final MyStoreModel store;
  final VoidCallback onEdit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const StoreCard({
    super.key,
    required this.store,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("120".tr, style: TextStyle(color: Colors.red)),
        content: Text(" ${'122'.tr} '${store.name}'؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("124".tr, style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text("123".tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Slidable(
        key: Key(store.id.toString()),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => _confirmDelete(context),
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.red.shade100,
                  blurRadius: 10,
                  offset: Offset(0, 5)),
            ],
          ),
          child: Row(
            children: [
              // Updated image section with better error handling
              _buildStoreImage(),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.address!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreImage() {
    // Check if the image URL is not null and not empty
    if (store.image != null && store.image!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.all(8),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // زوايا مدورة
          image: DecorationImage(
            image: NetworkImage("${AppLink.imageststatic}/${store.image!}"),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // تأكيد الزوايا
          child: CachedNetworkImage(
            imageUrl: "${AppLink.imageststatic}/${store.image!}",
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Icon(Icons.store, color: Colors.grey[400]),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, color: Colors.grey[400]),
            ),
          ),
        ),
      );
    } else {
      // Fallback to local asset when no image URL is provided
      return ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
        child: Image.asset(
          "assets/images/store.png",
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
