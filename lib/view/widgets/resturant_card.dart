import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'package:go_go/linkapi.dart';

class RestaurantCard extends StatelessWidget {
  // final StoreModel restaurant;
  final MyStoreModel restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Widget buildStoreImage() {
      // Check if the image URL is not null and not empty
      if (restaurant.image != null && restaurant.image!.isNotEmpty) {
        return ClipRRect(
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: '${AppLink.imageststatic}/${restaurant.image!}',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              height: 50,
              width: 50,
              child: Icon(Icons.store, color: Colors.grey[400]),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              height: 50,
              width: 50,
              child: Icon(Icons.broken_image, color: Colors.grey[400]),
            ),
          ),
        );
      } else {
        // Fallback to local asset when no image URL is provided
        return ClipRRect(
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
          child: Image.asset(
            "assets/images/a2.png",
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
          leading: buildStoreImage(),
          title: Text(restaurant.name!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: [
              Icon(Icons.directions_car, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text("10.6 km", style: TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: restaurant.bayesianScore != null &&
                  restaurant.bayesianScore! > 0.0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(restaurant.bayesianScore!.toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                )
              : null),
    );
  }
}
