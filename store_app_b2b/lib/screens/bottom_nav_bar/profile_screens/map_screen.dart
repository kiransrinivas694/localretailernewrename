import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/profile_controller/map_controller.dart';

class MapProfileScreen extends StatelessWidget {
  MapProfileScreen({Key? key}) : super(key: key);
  MapController mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<MapController>(
        init: MapController(),
        initState: (state) {
          Future.delayed(
            const Duration(microseconds: 300),
            () {
              final mapController = Get.find<MapController>();
              mapController.bodyMap = Get.parameters;
              mapController.update();
              mapController.getCurrentLocation();
            },
          );
        },
        builder: (MapController mapController) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              title: CommonText(
                content: "My Store Location",
                boldNess: FontWeight.w600,
                textSize: width * 0.047,
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff2F394B),
                      Color(0xff090F1A),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                !mapController.isLoading
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: mapController.bodyMap.isEmpty
                              ? LatLng(mapController.position!.latitude,
                                  mapController.position!.longitude)
                              : LatLng(
                                  double.parse(
                                      mapController.bodyMap['latitude']),
                                  double.parse(
                                      mapController.bodyMap['longitude'])),
                          zoom: 12,
                        ),
                        zoomControlsEnabled: false,
                        markers: mapController.markers,
                        // onMapCreated: (GoogleMapController controller) {
                        //   if (!mapController.controller.isCompleted) {
                        //     mapController.controller.complete(controller);
                        //   }
                        // },
                      )
                    : const SizedBox(),
                Container(
                  height: height / 5,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/location.png",
                              scale: 3.5,
                            ),
                            SizedBox(width: width * 0.03),
                            Column(
                              children: [
                                CommonText(
                                  content: mapController.address?.name ?? '',
                                  textSize: width * 0.045,
                                  boldNess: FontWeight.w600,
                                  textColor: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.075),
                          child: CommonText(
                            content:
                                '${mapController.address?.street ?? ''}, ${mapController.address?.locality ?? ''}, ${mapController.address?.subLocality ?? ''}, ${mapController.address?.postalCode ?? ''}, ${mapController.address?.country ?? ''}',
                            textColor: ColorsConst.hintColor,
                            textSize: width * 0.035,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (mapController.isLoading)
                  Center(
                      child: CircularProgressIndicator(
                          color: ColorsConst.primaryColor)),
              ],
            ),
          );
        });
  }
}
