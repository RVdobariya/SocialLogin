import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../config/app_color.dart';
import '../config/app_images.dart';
import '../config/app_textStyle.dart';

Widget customButton({double? height, double? width, String? text, void Function()? onTap, String? fontFamily, double? fontSize, Color? color}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          height: height ?? 50,
          width: width ?? Get.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[300]!,
                Colors.blue[500]!,
                Colors.blue[700]!,
                // Color(0XFFf3658f),
                // Color(0XFFe54072)
                // Colors.pink[300]!,
                // Colors.pink[500]!,
                // const Color(0XFFE94057)
              ]),
              borderRadius: BorderRadius.circular(10)),
          child: Text("$text",
              style: AppTextStyle.regular
                  .copyWith(fontSize: fontSize ?? 18, fontFamily: fontFamily ?? "lexend", fontWeight: FontWeight.w400, color: color ?? AppColors.whiteColor))));
}

Widget backArrow({Color color = AppColors.primaryColor, void Function()? onTap}) {
  return InkWell(
    highlightColor: AppColors.whiteColor,
    onTap: onTap ??
        () {
          Get.back();
        },
    child: Icon(CupertinoIcons.back, size: 24, color: color),
  );
}

Widget commonGridView({
  List<String>? images,
}) {
  return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: images!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  // Get.to(() => UserDetailsScreen(image: images[index]));
                },
                child: Stack(alignment: Alignment.bottomLeft, children: [
                  Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, spreadRadius: 0)]),
                      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(images[index], fit: BoxFit.cover))),
                  Container(
                      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 2),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          color: Colors.black.withOpacity(0.1)),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Belle Benson, 28",
                            overflow: TextOverflow.ellipsis, style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 16)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          /* Text(
                            "1.5 km away",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 12),
                          ),*/
                          Row(children: [
                            const Icon(
                              Icons.camera_alt_rounded,
                              size: 14,
                              color: AppColors.whiteColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "35",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 12),
                            )
                          ])
                        ])
                      ])),
                  if (index % 3 == 0)
                    Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                            width: 10,
                            height: 10,
                            decoration: const ShapeDecoration(
                                gradient: RadialGradient(center: Alignment(0.24, 0.70), radius: 0.21, colors: [Color(0xFFBFFF6E), Color(0xFF12D13C)]),
                                shape: OvalBorder())))
                ]));
          }));
}

Widget commonGridView1({userDetails, bool? isMatch, bool? isMatchScreen = false, bool? isLikedScreen = false}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20),
    child: userDetails!.isEmpty
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              isMatch! ? AppImages.appLogo : AppImages.appLogo,
              height: 140,
              width: 140,
            ),
            const SizedBox(height: 5),
            Text(
              isMatch ? "No matches in your record. " : "No likes yet.",
              style: AppTextStyle.medium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16, height: -0.2),
            ),
            const SizedBox(height: 5),
            Text(
              isMatch ? "It's a match if you both swipe right!" : "We'll notify you when you get a like.",
              style: AppTextStyle.medium.copyWith(color: AppColors.blackColor, fontSize: 14),
            )
          ])
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            itemCount: userDetails.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userDetails[index],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: Get.height,
                        width: Get.width,
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, spreadRadius: 0)]),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    DateFormat format = DateFormat('dd MMM yyyy');
                    DateTime dob = format.parse(snapshot.data!.data()?['dob'] ?? "02 Jan 1999");
                    return GestureDetector(
                        onTap: snapshot.data!.data()?['is_delete'] == true ? () {} : () {},
                        child: Stack(alignment: Alignment.bottomLeft, children: [
                          Container(
                              height: Get.height,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, spreadRadius: 0)]),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10), child: Image.network(snapshot.data!.data()?['profile_image'], fit: BoxFit.cover))),
                          if (snapshot.data!.data()?['online'] == true)
                            const Positioned(top: 5, right: 5, child: Icon(Icons.circle, size: 12, color: CupertinoColors.activeGreen)),
                          Container(
                              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  color: Colors.black.withOpacity(0.1)),
                              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "${snapshot.data!.data()?['first_name']}".capitalizeFirst.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 16),
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  /* Text(
                                    "1.5 km away",
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 12),
                                  ),*/

                                  Text(
                                    // "35",
                                    "Age: ${DateTime.now().year - dob.year}",
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 12),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.photo,
                                    size: 14,
                                    color: AppColors.whiteColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                      // "35",
                                      "${snapshot.data!.data()?["otherImages"].length ?? 0}",
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.medium.copyWith(color: AppColors.whiteColor, fontSize: 12))
                                ])
                              ])),
                          if (snapshot.data!.data()?['is_delete'] == true)
                            Positioned(
                                top: -10,
                                right: -35,
                                child: Container(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      Colors.pink[300]!,
                                      Colors.pink[500]!,
                                      Colors.pink[700]!,
                                    ])),
                                    transform: Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
                                    child: Text("Deactive", style: AppTextStyle.semiBold.copyWith(color: Colors.white, fontSize: 10))))
                        ]));
                  });
            }),
  );
}

Widget likeContainer(
    {double? height,
    double? width,
    double? imageheight,
    double? imagewidth,
    String? icon,
    Color? color,
    EdgeInsetsGeometry? margin,
    GestureTapCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: margin ?? const EdgeInsets.all(0),
      width: width ?? 50,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: AppColors.blackColor.withOpacity(0.3), blurRadius: 5, spreadRadius: 0),
        ],
      ),
      child: Center(
        child: Image.asset(
          icon!,
          height: imageheight ?? 28,
          width: imagewidth ?? 28,
          color: color,
        ),
      ),
    ),
  );
}

Widget commonContainer({
  String? image,
  String? title,
  void Function()? onTap,
}) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Column(
      children: [
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    image!,
                    height: 20,
                    width: 20,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    title!,
                    style: const TextStyle(fontFamily: "lexend", fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right, size: 28)
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: AppColors.blackColor,
          height: 0.5,
        ),
      ],
    ),
  );
}

Widget commonListview() {
  return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: AppColors.blackColor.withOpacity(0.1), blurRadius: 5, spreadRadius: 0),
          ], color: AppColors.whiteColor, borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: const ShapeDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80"),
                          fit: BoxFit.cover),
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x26312856),
                          blurRadius: 15,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        )
                      ])),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Ruby Ramon",
                  style: AppTextStyle.medium.copyWith(color: AppColors.blackColor, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text("Found from matches proposal", style: AppTextStyle.medium.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.greyColor)),
                const SizedBox(height: 5),
                Text("12:20 AM  |  29.04.2021", style: AppTextStyle.medium.copyWith(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.greyColor))
              ])),
              SizedBox(
                  width: 20,
                  height: 20,
                  child: PopupMenuButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      offset: const Offset(0, kToolbarHeight - 6),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            PopupMenuItem(child: Text('Delete', style: AppTextStyle.medium.copyWith(color: AppColors.primaryColor, fontSize: 13)))
                          ]))
            ]),
          ]),
        );
      });
}

cameraButton({onTap, size, icon, txt}) {
  return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
            height: size ?? 60,
            width: size ?? 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.1),
              // border: Border.all(color:  AppColors.transparentColor, width: 1)
            ),
            child: Padding(
                padding: const EdgeInsets.all(0),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                )
                // Image.asset(
                //   img,
                //   // color: imgClr ?? AppColors.primaryColor,
                //   scale: 3.5,
                // ),
                )),
        const SizedBox(height: 5),
        Text(txt, style: AppTextStyle.medium.copyWith(fontSize: 14, color: AppColors.primaryColor))
      ]));
}
