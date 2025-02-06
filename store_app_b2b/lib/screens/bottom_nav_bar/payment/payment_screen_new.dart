import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/widget/all_payment_tab_new.dart';
import 'package:store_app_b2b/widget/credit_rating_tab_new.dart';
import 'package:store_app_b2b/widget/payment_request_tab_new.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
        initState: (state) async {
          Future.delayed(
            const Duration(milliseconds: 150),
            () async {
              PaymentController controller = Get.find<PaymentController>();
              await controller.getPaymentRequestDataApi();
              await controller.getPaymentOverview();
              await controller.getStoreCreditRatingPresent();
              controller.update();
            },
          );
        },
        init: PaymentController(),
        builder: (paymentController) {
          return Column(
            children: [
              DefaultTabController(
                initialIndex: 0,
                length: 3,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: paymentController.controller,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 5,
                      indicator: const MD2Indicator(
                        indicatorSize: MD2IndicatorSize.normal,
                        indicatorHeight: 3.0,
                        indicatorColor: Colors.orange,
                      ),
                      onTap: (value) async {
                        if (value == 1) {
                          paymentController.searchRequestController.value.text =
                              "";
                          await paymentController.getPaymentRequestDataApi();
                          await paymentController.getPaymentOverview();
                        } else if (value == 2) {
                          paymentController.searchAllController.value.text = "";
                          paymentController.fullyPaidList.clear();
                          await paymentController.getFullyPaidDataApi();
                        } else {
                          paymentController.getStoreCreditRatingPresent();
                        }
                        paymentController.fullyPaidCurrentPage.value = 0;
                        paymentController.fullyPaidTotalPage.value = 0;
                      },
                      tabs: [
                        Tab(
                          child: CommonText(
                            content: "PLR\nRating",
                            textColor: Colors.black,
                            boldNess: FontWeight.w600,
                            textAlign: TextAlign.center,
                            textSize: 15.sp,
                          ),
                        ),
                        Tab(
                          child: CommonText(
                            content: "Payment\nRequest",
                            textColor: Colors.black,
                            boldNess: FontWeight.w600,
                            textAlign: TextAlign.center,
                            textSize: 15.sp,
                          ),
                        ),
                        Tab(
                          child: CommonText(
                            content: "Paid\nBills",
                            textAlign: TextAlign.center,
                            textColor: Colors.black,
                            boldNess: FontWeight.w600,
                            textSize: 15.sp,
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
                  controller: paymentController.controller,
                  children: [
                    CreditRatingTab(),
                    PaymentRequestTab(),
                    AllPaymentTab(),
                  ],
                ),
              ),
            ],
          );
        });
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

  _MD2Painter(this.decoration, VoidCallback onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
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
            topRight: const Radius.circular(8),
            topLeft: const Radius.circular(8)),
        paint);
  }
}
