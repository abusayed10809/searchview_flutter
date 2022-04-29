import 'package:flutter/material.dart';
import 'package:flutter_search_api_demo/ecommerce/item_bloc/item_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onSubmitted: _onSubmitted,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onSubmitted(String itemName) {
    BlocProvider.of<ItemBloc>(context).add(TextChanged(text: itemName));
  }

  void _onClearTapped(){
    _textController.text = '';
    BlocProvider.of<ItemBloc>(context).add(TextChanged(text: ""));
  }
}