import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/profile_conroller.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/linkapi.dart';

class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 5.0, top: 10.0, bottom: 10, end: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 5.0, top: 12.0, bottom: 8, end: 5),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: controller.file != null &&
                          controller.file!.isNotEmpty &&
                          !controller.file!.contains("https://")
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: CachedNetworkImage(
                            imageUrl:
                                AppLink.imageststatic + "/" + controller.file!,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                            errorWidget: (context, url, error) => Image.asset(
                                AppImageAsset.avatar,
                                height: 60,
                                width: 60),
                          ),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(AppImageAsset.avatar),
                        ),
                ),
              ),
              SizedBox(width: 20),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 10.0, bottom: 10, end: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(controller.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  height: 2)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(controller.phone,
                            style: TextStyle(color: Colors.black, height: 1)),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    controller.gotoEditProfile();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: AppColor.grey2,
                  ))
            ],
          ),
        );
      },
    );
  }
}
