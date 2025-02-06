import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/model/lucid/find_location_model.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/findlocation/location_details_screen.dart';
import 'package:store_app_b2b/new_module/snippets/snippets.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class FindLocationScreen extends StatefulWidget {
  FindLocationScreen({super.key});

  @override
  _FindLocationScreenState createState() => _FindLocationScreenState();
}

class _FindLocationScreenState extends State<FindLocationScreen> {
  final ThemeController themeController = Get.find();
  LucidController lucidController = Get.put(LucidController());

  Position? _userPosition;
  bool _locationPermissionGranted = false;

  String _currentLocationName =
      "Fetching current location..."; // Placeholder for user location

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        status = await Geolocator.requestPermission();
      }
      if (status == LocationPermission.deniedForever) {
        Get.snackbar('Permission Required',
            'Location permission is required. Please enable it in settings.');
        await Geolocator.openAppSettings();
        return;
      }

      if (status == LocationPermission.whileInUse ||
          status == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        Placemark place = placemarks[0];
        setState(() {
          _userPosition = position;
          _locationPermissionGranted = true;
          _currentLocationName =
              "${place.subLocality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      logs('Error fetching user location: $e');
    }
  }

  Future<double> calculateDistanceToStore(
      double storeLatitude, double storeLongitude) async {
    if (_userPosition == null) {
      throw Exception('User location is not available');
    }
    return _haversine(_userPosition!.latitude, _userPosition!.longitude,
        storeLatitude, storeLongitude);
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Find location',
        backgroundColor: themeController.textPrimaryColor,
        isTitleNeeded: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(119, 187, 173, 0.22),
          ),
          child: Obx(
            () => lucidController.isLocationListLoading.value
                ? verticalShimmerListView(
                    shimmerContainerHeight: 90,
                    shimmerContainerWidth: 350,
                  )
                : Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Icon(
                          Icons.location_on,
                          color: themeController.navShadow1,
                          size: 15,
                        ),
                        // Obx(() => mapController.homeScreenAddressLoading.value
                        //     ? LoadingAnimationWidget.waveDots(
                        //         color: themeController.textPrimaryColor,
                        //         size: 20)
                        //     : mapController.homeScreenAddress.value.isNotEmpty
                        //         ? AppText(
                        //             mapController.homeScreenAddress.value,
                        //             color: themeController.black300Color,
                        //             fontWeight: FontWeight.w400,
                        //             fontSize: 15.sp,
                        //             maxLines: 1,
                        //             overflow: TextOverflow.ellipsis,
                        //           )
                        //         : const SizedBox())
                        AppText(
                          //mapController.address?.subLocality ?? "",
                          _currentLocationName,
                          color: themeController.black300Color,
                          fontSize: 14.sp,
                        )
                      ]),
                      Gap(1.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: lucidController.locationList.length,
                        itemBuilder: (context, index) {
                          BasicLocationModel findLocation =
                              lucidController.locationList[index];
                          DateTime time = DateFormat("HH:mm:ss")
                              .parse(findLocation.closingTime);
                          String closeTime = DateFormat("h a").format(time);

                          double? latitude =
                              double.tryParse(findLocation.lattitude ?? '');
                          double? longitude =
                              double.tryParse(findLocation.logittude ?? '');

                          logs('Latitude: $latitude, Longitude: $longitude');

                          return GestureDetector(
                            onTap: () {
                              Get.to(() => LocationDetailsScreen(
                                    locationId: findLocation.id,
                                    storeLat: latitude,
                                    storeLong: longitude,
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: themeController.textPrimaryColor,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: AppImageAsset(
                                        image: findLocation.image,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Gap(4.w),
                                  Expanded(
                                    child: SizedBox(
                                      height: 14.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            "Lucid Diagnostics",
                                            color:
                                                themeController.black500Color,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppFont.poppins,
                                          ),
                                          AppText(
                                            "Hyderabad",
                                            color:
                                                themeController.black500Color,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppFont.poppins,
                                          ),
                                          Gap(0.5.h),
                                          AppText(
                                            findLocation.branchName ?? "",
                                            color: themeController
                                                .textSecondaryColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppFont.poppins,
                                          ),
                                          Gap(0.5.h),
                                          if (latitude != null &&
                                              longitude != null)
                                            FutureBuilder<double>(
                                              future: calculateDistanceToStore(
                                                  latitude, longitude),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<double>
                                                      snapshot) {
                                                logs(
                                                    "location status${snapshot.connectionState},${snapshot.hasData},${snapshot.data}");
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return AppText(
                                                    "Calculating distance...",
                                                    color: themeController
                                                        .textSecondaryColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: AppFont.poppins,
                                                  );
                                                } else if (snapshot.hasError) {
                                                  // Logging error for debugging
                                                  logs(
                                                      'Error: ${snapshot.error}');
                                                  return AppText(
                                                    "Distance:...",
                                                    color: themeController
                                                        .textSecondaryColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: AppFont.poppins,
                                                  );
                                                } else if (snapshot.hasData) {
                                                  logs(
                                                      "here comming data is-->$snapshot");
                                                  return AppText(
                                                    "Distance: ${snapshot.data!.toStringAsFixed(2)} km",
                                                    color: themeController
                                                        .textSecondaryColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: AppFont.poppins,
                                                  );
                                                } else {
                                                  return AppText(
                                                    "Unable to calculate distance",
                                                    color: themeController
                                                        .textSecondaryColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: AppFont.poppins,
                                                  );
                                                }
                                              },
                                            ),
                                          if (latitude == null ||
                                              longitude == null)
                                            AppText(
                                              "Invalid location data",
                                              color: themeController
                                                  .textSecondaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppFont.poppins,
                                            ),
                                          Gap(0.5.h),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_sharp,
                                                size: 15,
                                                color: Color.fromRGBO(
                                                    207, 91, 107, 1),
                                              ),
                                              const Gap(2),
                                              AppText(
                                                "${findLocation.openigTime ?? "10 AM"} TO $closeTime",
                                                color:
                                                    themeController.navShadow1,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: AppFont.poppins,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Gap(1.h);
                        },
                      ),
                      Gap(4.h),
                    ],
                  ),
          ),
        ),
      ),
      // bottomNavigationBar: AppBottomBar(
      //   index: 2,
      //   useIndexFromController: false,
      //   cartIndexChangeTo: 1,
      // ),
    );
  }
}
