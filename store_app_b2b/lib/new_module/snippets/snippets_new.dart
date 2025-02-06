import 'package:flutter/cupertino.dart';

import 'package:store_app_b2b/widget/app_image_assets_new.dart';

Widget horizontalShimmerListView({
  double shimmerContainerHeight = 200,
  double shimmerContainerWidth = 150,
  double mainContainerHeight = 200,
}) {
  return SizedBox(
    height: mainContainerHeight,
    child: ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          child: AppShimmerEffectView(
            height: shimmerContainerHeight,
            width: shimmerContainerWidth,
          ),
        );
      },
    ),
  );
}

Widget verticalShimmerGridView({
  double shimmerContainerHeight = 200,
  double shimmerContainerWidth = 150,
  double mainContainerHeight = 200,
}) {
  return SizedBox(
    height: mainContainerHeight,
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      itemCount: 10,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 0),
          child: AppShimmerEffectView(
            height: shimmerContainerHeight,
            width: shimmerContainerWidth,
          ),
        );
      },
    ),
  );
}

Widget verticalShimmerListView1({
  double shimmerContainerHeight = 200,
  double shimmerContainerWidth = 380,
  double mainContainerHeight = 200,
}) {
  return SizedBox(
    height: mainContainerHeight,
    child: ListView.builder(
      itemCount: 6,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 0),
          child: AppShimmerEffectView(
            height: shimmerContainerHeight,
            width: shimmerContainerWidth,
          ),
        );
      },
    ),
  );
}

Widget verticalShimmerListView({
  double shimmerContainerHeight = 200,
  double shimmerContainerWidth = 150,
  double mainContainerHeight = 200,
  int itemCount = 4,
}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: itemCount,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: AppShimmerEffectView(
          height: shimmerContainerHeight,
          width: shimmerContainerWidth,
        ),
      );
    },
  );
}
