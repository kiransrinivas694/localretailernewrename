import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';

class PaginationLayout extends StatelessWidget {
  final num pageNumber;
  final num totalPages;
  final bool isDoubleArrowsPresent;
  final Function(num) onPageClick;

  PaginationLayout({
    required this.pageNumber,
    required this.totalPages,
    required this.isDoubleArrowsPresent,
    required this.onPageClick,
  });

  List<num> getNumbersToShow() {
    num noOfBoxesToShow = totalPages < 6 ? totalPages : 5;
    List<num> numbersToShow = [];

    if (noOfBoxesToShow == 5) {
      if (pageNumber < 3) {
        numbersToShow = [1, 2, 3, 4, 5];
      } else if (pageNumber > totalPages - 4) {
        numbersToShow = [
          totalPages - 4,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages,
        ];
      } else {
        numbersToShow = [
          pageNumber - 1,
          pageNumber,
          pageNumber + 1,
          pageNumber + 2,
          pageNumber + 3,
        ];
      }
    } else {
      for (int i = 0; i < noOfBoxesToShow; i++) {
        numbersToShow.add(i + 1);
      }
    }

    return numbersToShow;
  }

  // List<num> getNumbersToShow1() {
  //   return
  // }

  void handleRightPaginationClick(String value) {
    num newPageNumber;
    if (value == "isDoubleClick") {
      onPageClick(totalPages - 1);
      return;
    }
    if (pageNumber == totalPages - 1) {
      newPageNumber = pageNumber;
    } else {
      newPageNumber = pageNumber + 1;
    }

    onPageClick(newPageNumber);
  }

  void handleLeftPaginationClick(String value) {
    num newPageNumber;
    if (value == "isDoubleClick") {
      onPageClick(0);
      print("double arrow");
      return;
    }
    if (pageNumber == 0) {
      newPageNumber = pageNumber;
    } else {
      newPageNumber = pageNumber - 1;
    }

    onPageClick(newPageNumber);
  }

  void handleNumberClick(num number) {
    onPageClick(number - 1);
  }

  @override
  Widget build(BuildContext context) {
    List<num> numbersToShow = getNumbersToShow();
    // bool a = true;
    // if (a == true) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       IconButton(
    //         icon: Icon(Icons.arrow_back_ios_new),
    //         iconSize: 20,
    //         onPressed: () => handleLeftPaginationClick(""),
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.arrow_forward_ios),
    //         onPressed: () => handleRightPaginationClick(""),
    //         iconSize: 20,
    //       ),
    //     ],
    //   );
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isDoubleArrowsPresent)
          IconButton(
            icon: Icon(Icons.double_arrow),
            onPressed: () => handleLeftPaginationClick("isDoubleClick"),
          ),
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
          onPressed: () => handleLeftPaginationClick(""),
        ),
        Row(
          children: numbersToShow.map((each) {
            return GestureDetector(
              onTap: () => handleNumberClick(each),
              child: Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: pageNumber + 1 == each
                        ? Colors.grey[300]!
                        : Colors.transparent,
                  ),
                  color: pageNumber + 1 == each
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    each.toString(),
                    style: TextStyle(
                      color: pageNumber + 1 == each
                          ? Colors.white
                          : Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () => handleRightPaginationClick(""),
          iconSize: 20,
        ),
        if (isDoubleArrowsPresent)
          IconButton(
            icon: Icon(Icons.double_arrow),
            onPressed: () => handleRightPaginationClick("isDoubleClick"),
          ),
      ],
    );
  }
}
