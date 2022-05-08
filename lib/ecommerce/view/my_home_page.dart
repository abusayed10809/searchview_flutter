import 'dart:async';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_api_demo/constants/color.dart';
import 'package:flutter_search_api_demo/ecommerce/item_bloc/item_bloc.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';
import 'package:flutter_search_api_demo/ecommerce/view/item_detail_screen.dart';
import 'package:flutter_search_api_demo/widgets/PersistentHeader.dart';
import 'package:flutter_search_api_demo/widgets/SearchBar.dart';

class MyHomePage extends StatelessWidget {

  String itemName;
  List<ItemModel> oldItemList = [];

  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<ItemBloc>(context).add(ScrolledToBottom(oldItemList: oldItemList, itemName: itemName));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    setupScrollController(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Search Page",
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: PersistentHeader(
              minHeight: height * 0.095,
              maxHeight: height * 0.095,
              child: Container(
                  alignment: Alignment.center,
                  color: colorCustom,
                  child: _initialPage()),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: width,
              height: height * 0.8,
              color: colorCustom,
              child: BlocConsumer<ItemBloc, ItemState>(
                buildWhen: (previous, current){
                  if(current is ItemSuccessLoadState){
                    return true;
                  }
                  else if(current is ItemErrorLoadState){
                    return true;
                  }
                  else if(current is ItemLoadingState){
                    return true;
                  }
                  else if(current is ItemInitialState){
                    return true;
                  }
                  else if(previous is ItemDetailState){
                    return true;
                  }
                  return false;
                },
                listener: (context, itemState){
                  return Container();
                },
                builder: (BuildContext context, ItemState itemState) {
                  if (itemState is ItemInitialState) {
                    return _indicatorPage();
                  }
                  else if (itemState is ItemLoadingState) {
                    itemName = itemState.itemName;
                    return _loadingPage();
                  }
                  else if (itemState is ItemSuccessLoadState) {
                    oldItemList = itemState.items;
                    return _itemListView(itemState.items, width, height);
                  } else if (itemState is ItemErrorLoadState) {
                    return _errorPage(itemState.error);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialPage() {
    return SearchBar();
  }

  Widget _indicatorPage() {
    return Center(
      child: Text(
        "Enter product name, press done",
      ),
    );
  }

  Widget _loadingPage() {
    return Center(child: CircularProgressIndicator(color: Colors.black,));
  }

  Widget _itemListView(List<ItemModel> itemList, double width, double height) {
    return GridView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (width)/(height*0.9),
          mainAxisSpacing: width*0.025,
          crossAxisSpacing: width*0.025
      ),
      itemBuilder: (context, index) {
          ItemModel singleItem = itemList[index];
          return GestureDetector(
            onTap: (){
              BlocProvider.of<ItemBloc>(context).add(ItemNextPageEvent(singleItem: singleItem));
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemDetailScreen()));
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: width*0.03, vertical: height*0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  img.Image.network(
                    singleItem.image,
                  ),
                  SizedBox(
                    height: height*0.01,
                  ),
                  Text(
                    singleItem.productName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: height*0.01,
                  ),
                  Text(
                      "৳ ${singleItem.charge.currentCharge.toString()}"
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "৳ ${singleItem.charge.sellingPrice.toString()}",
                      ),
                      Text(
                        "৳ ${singleItem.charge.profit.toString()}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
      },
      itemCount: itemList.length + (isLoading? 1 : 0),
    );
  }

  Widget _errorPage(int errorCode) {
    return Center(
      child: Text(
        "Error $errorCode, can't fetch data",
        style: TextStyle(
            fontSize: 15,
            fontFamily: 'Hind Siliguri Regular'
        ),
      ),
    );
  }
}