import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_search_api_demo/constants/color.dart';
import 'package:flutter_search_api_demo/ecommerce/item_bloc/item_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';

import 'package:flutter_search_api_demo/ecommerce/view/my_home_page.dart';
import 'package:flutter_search_api_demo/widgets/SearchBar.dart';
import 'widgets/PersistentHeader.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => ItemBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: Scaffold(
        body: MyHomePage(),
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
