import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_search_api_demo/ecommerce/item_bloc/item_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';

import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_search_api_demo/ecommerce/view/PersistentHeader.dart';
import 'package:flutter_search_api_demo/ecommerce/view/SearchBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: BlocProvider(
          create: (_) => ItemBloc(),
          child: MyHomePage(),
        ),
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {

  String itemName;
  List<ItemModel> oldItemList = [];

  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  void setupScrollController(context) {
    print("scroll controller xxxxxxxx +++++");
    _scrollController.addListener(() {
      print("scroll listener xxxxxxxx +++++");
      if (_scrollController.position.atEdge) {
        print("scroll position xxxxxxxx +++++");
        if (_scrollController.position.pixels != 0) {
          print("scroll pixels xxxxxxxx +++++");
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
        title: Text('Search Item'),
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
                  width: width,
                  height: height * 0.05,
                  alignment: Alignment.center,
                  child: _initialPage()),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: width,
              height: height * 0.8,
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (BuildContext context, ItemState itemState) {
                  if (itemState is ItemInitialState) {
                    return _indicatorPage();
                  }
                  if (itemState is ItemLoadingState) {
                    itemName = itemState.itemName;
                    return _loadingPage();
                  } else if (itemState is ItemSuccessLoadState) {
                    oldItemList = itemState.items;
                    return _itemListView(itemState.items, width, height);
                  } else if (itemState is ItemErrorLoadState) {
                    return _errorPage(itemState.error);
                  }
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
    return Center(child: CircularProgressIndicator());
  }

  Widget _itemListView(List<ItemModel> itemList, double width, double height) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        if(index < itemList.length){
          ItemModel singleItem = itemList[index];
          return Container(
            width: 100,
            height: 100,
            child: img.Image.network(
              singleItem.image,
            ),
          );
        }else{
          Timer(Duration(milliseconds: 30),(){
            _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent
            );
          });
          return _loadingPage();
        }

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
        ),
      ),
    );
  }
}
