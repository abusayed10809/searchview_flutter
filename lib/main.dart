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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
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
              color: Colors.red,
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (BuildContext context, ItemState itemState) {
                  if (itemState is ItemInitialState) {
                    return _indicatorPage();
                  }
                  if (itemState is ItemLoadingState) {
                    return _loadingPage();
                  } else if (itemState is ItemSuccessLoadState) {
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
        "Enter name of product",
      ),
    );
  }

  Widget _loadingPage() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _itemListView(List<ItemModel> itemList, double width, double height) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        ItemModel singleItem = itemList[index];
        return Container(
          width: 100,
          height: 100,
          child: img.Image.network(
            singleItem.image,
          ),
        );
      },
      itemCount: itemList.length,
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
