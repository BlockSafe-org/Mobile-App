import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MarketPlace extends StatelessWidget {
  MarketPlace({super.key});

  TextEditingController searchController = TextEditingController();
  dynamic items = [
    Card(
        color: Colors.orangeAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            const Expanded(
                child: Text("GET UPTO 20% DISCOUNT ON WEEKENDS%!",
                    style: TextStyle(color: Colors.white))),
            Expanded(child: Image.asset("assets/images/shopping.png"))
          ]),
        )),
    Card(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            const Expanded(
                child: Text("ENJOY BLACK FRIDAY DISCOUNTS UP TO 80%!",
                    style: TextStyle(color: Colors.white))),
            Expanded(child: Image.asset("assets/images/celebrate.png"))
          ]),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Icon(Icons.menu),
          Center(child: Image.asset("assets/images/blockly.png", scale: 4)),
          const SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text("Best Sales!")),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: 50,
            child: TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  focusColor: Colors.white,
                  hintText: "Search MarketPlace..."),
              controller: searchController,
            ),
          ),
          const SizedBox(height: 20),
          CarouselSlider(
              items: items,
              options: CarouselOptions(
                height: 150,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              )),
          const SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text("Categories")),
          SizedBox(
            height: 600,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(5),
                    child: const SizedBox(
                        width: 100,
                        height: 200,
                        child: Card(
                          child: Text("Hello World"),
                        ))),
                Container(
                    margin: const EdgeInsets.all(5),
                    child: const SizedBox(
                        width: 100,
                        height: 200,
                        child: Card(
                          child: Text("Hello World"),
                        ))),
                Container(
                    margin: const EdgeInsets.all(5),
                    child: const SizedBox(
                        width: 100,
                        height: 200,
                        child: Card(
                          child: Text("Hello World"),
                        ))),
                Container(
                    margin: const EdgeInsets.all(5),
                    child: const SizedBox(
                        width: 100,
                        height: 200,
                        child: Card(
                          child: Text("Hello World"),
                        ))),
                Container(
                    margin: const EdgeInsets.all(5),
                    child: const SizedBox(
                        width: 100,
                        height: 200,
                        child: Card(
                          child: Text("Hello World"),
                        ))),
                Container(
                    margin: const EdgeInsets.all(5),
                    child: const SizedBox(
                        width: 100,
                        height: 200,
                        child: Card(
                          child: Text("Hello World"),
                        ))),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      )),
    );
  }
}
