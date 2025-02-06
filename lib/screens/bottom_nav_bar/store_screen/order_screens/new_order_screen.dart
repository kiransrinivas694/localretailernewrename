import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/new_order_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/bottom_controller/order_controller/new_order_controller.dart';
import 'package:b2c/widget/accepted_order_tab.dart';
import 'package:b2c/widget/new_orders_tab.dart';
import '../../../../utils/shar_preferences.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  var isLogin = false;
  int tabSelect = 0;

  @override
  void initState() {
    getLogin();
    super.initState();
  }

  Future<dynamic> getLogin() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    !isLogin
        ? Get.dialog(barrierDismissible: false, const LoginDialog())
        : const SizedBox();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<NewOrderController>(
      init: NewOrderController(),
      initState: (state) {},
      builder: (controller) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: "Orders",
              boldNess: FontWeight.w600,
              textSize: width * 0.047,
            ),
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.appGradientColor,
                ),
              ),
            ),
          ),
          body: !isLogin
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      /* CommonText(
                  content:
                      "https://play.google.com/store/apps/details?id=com.ongo.localretailer",
                  textSize: width * 0.037,
                  textColor: AppColors.blueColor,
                  boldNess: FontWeight.w400,
                  textDecoration: TextDecoration.underline,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: AppColors.primaryColor),
                  ),
                  onPressed: () async {
                    await FlutterShare.share(
                      title: "Let's explore",
                      text: '',
                      linkUrl: '',
                      chooserTitle: '',
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Color(0xff2B2B2B),
                        ),
                      ),
                      CommonText(
                        content: "Share my store",
                        textSize: width * 0.03,
                        boldNess: FontWeight.w400,
                        textColor: AppColors.textColor,
                      ),
                    ],
                  ),
                ),*/
                      DefaultTabController(
                        initialIndex: 0,
                        length: 2,
                        child: PreferredSize(
                          preferredSize: const Size.fromHeight(kToolbarHeight),
                          child: Material(
                            color: Colors.transparent,
                            child: TabBar(
                              controller: controller.controller,
                              indicatorColor: AppColors.primaryColor,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 0,
                              indicator: MD2Indicator(
                                indicatorSize: MD2IndicatorSize.full,
                                indicatorHeight: 2.0,
                                indicatorColor: AppColors.primaryColor,
                              ),
                              onTap: (value) {
                                print(value);
                                tabSelect = value;
                                // NewOrderScreenController.to.newOrdersRes.clear();
                                // NewOrderScreenController.to.acceptedOrdersRes.clear();
                                /* if (value == 0) {
                            NewOrderScreenController.to.newOrdersApi(
                                queryParameters: {"page": 0, "size": 10},
                                storeID: GetHelperController.storeID.value);
                          } else {
                            NewOrderScreenController.to.acceptedOrdersApi(
                              queryParameters: {"page": 0, "size": 10},
                              storeID: GetHelperController.storeID.value,
                            );
                          }*/
                              },
                              tabs: const [
                                Tab(
                                  child: CommonText(
                                    content: "New",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w500,
                                  ),
                                ),
                                Tab(
                                  child: CommonText(
                                    content: "Accepted",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: controller.controller,
                          children: [
                            NewOrdersTab(
                              viewMore: controller.viewMoreNewOrder.value,
                            ),
                            AcceptedOrderTab(
                              viewMore: controller.viewMoreAcceptedOrder.value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class MD2Indicator extends Decoration {
  final double? indicatorHeight;
  final Color? indicatorColor;
  final MD2IndicatorSize? indicatorSize;

  const MD2Indicator(
      {this.indicatorHeight, this.indicatorColor, this.indicatorSize});

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return new _MD2Painter(this, onChanged!);
  }
}

class _MD2Painter extends BoxPainter {
  final MD2Indicator decoration;

  _MD2Painter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    Rect rect = const Offset(1.0, 2.0) & const Size(3.0, 4.0);
    if (decoration.indicatorSize == MD2IndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(16, decoration.indicatorHeight ?? 3);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor ?? const Color(0xff1967d2);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topRight: const Radius.circular(0),
            topLeft: const Radius.circular(0)),
        paint);
  }
}
