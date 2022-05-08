import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_api_demo/constants/color.dart';
import 'package:flutter_search_api_demo/ecommerce/item_bloc/item_bloc.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';
import 'package:flutter/src/widgets/image.dart' as img;

class ItemDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ItemBloc>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(

        child: Container(
          color: colorCustom,
          alignment: Alignment.center,
          child: BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemDetailState) {
                ItemModel singleItem = state.singleItem;
                return _itemDetailCard(singleItem, width, height);
              } else {
                return _itemFetchFailedCard();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _itemDetailCard(ItemModel singleItem, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: height * 0.5,
            width: width * 0.6,
            margin: EdgeInsets.symmetric(vertical: height * 0.025),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(width * 0.05),
                  topLeft: Radius.circular(width * 0.05),
                  bottomLeft: Radius.circular(width * 0.05),
                  bottomRight: Radius.circular(width * 0.05),
                )),
            child: img.Image.network(
              singleItem.image,
            ),
          ),
        ),
        Text(
          singleItem.productName,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          children: [
            Text("ব্র্যান্ড: ${singleItem.brand.name} | "),
            Text("ডিস্ট্রিবিউটর: ${singleItem.seller}"),
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Stack(
          children: [
          Container(
            height: height * 0.2,
            width: width,
            alignment: Alignment.topCenter,
            child: Container(
              height: height * 0.14,
              width: width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(width * 0.05),
                    topLeft: Radius.circular(width * 0.05),
                    bottomLeft: Radius.circular(width * 0.05),
                    bottomRight: Radius.circular(width * 0.05),
                  )),
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025, vertical: height * 0.01),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ক্রয় মূল্য:"),
                        Text("৳ ${singleItem.charge.sellingPrice}"),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("বিক্রয় মূল্য:"),
                        Text("৳ ${singleItem.charge.currentCharge}"),
                      ],
                    ),
                    Divider(
                      thickness: height * 0.002,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("লাভ:"),
                        Text("৳ ${singleItem.charge.profit}"),
                      ],
                    ),
                  ],
              ),
            ),
          ),
          Positioned(
            left: width*0.43,
            top: height*0.1,
            child: Container(
              width: width*0.15,
              height: height*0.08,
              child: Stack(
                children: [
                  Icon(
                  Icons.hexagon,
                  size: width*0.15,
                  color: Colors.deepPurpleAccent,
                ),
                  Positioned(
                    left: width*0.043,
                    top: height*0.025,
                    child: Text(
                      "Buy",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Text(
          "বিস্তারিত"
        ),
        Text(
          singleItem.description,
          softWrap: true,
        ),
      ],
    );
  }

  Widget _itemFetchFailedCard() {}
}
