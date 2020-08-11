import 'package:flutter/material.dart';
import 'package:flutter_cook_book/receipt_detail_page.dart';

class CookReceipts extends StatefulWidget {
  @override
  _CookReceiptsState createState() => _CookReceiptsState();
}

class _CookReceiptsState extends State<CookReceipts> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height / 5;
    double myWidth = MediaQuery.of(context).size.width / 2;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      children: [
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: Image.asset(
                          "assets/lahmacun.jpg",
                          height: myHeight,
                          width: myWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Lahmacun assssssss ssssssss ssssss sssss",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        child: Image.asset(
                          "assets/lahmacun.jpg",
                          height: myHeight,
                          width: myWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Lahmacun assssssss ssssssss ssssss sssss",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: Image.asset(
                          "assets/lahmacun.jpg",
                          height: myHeight,
                          width: myWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Lahmacun assssssss ssssssss ssssss sssss",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        child: Image.asset(
                          "assets/lahmacun.jpg",
                          height: myHeight,
                          width: myWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Lahmacun assssssss ssssssss ssssss sssss",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
