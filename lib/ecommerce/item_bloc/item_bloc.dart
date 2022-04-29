import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_search_api_demo/ecommerce/api_client/api_client.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitialState());

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if(event is TextChanged){
      final searchText = event.text;

      if(searchText.isEmpty){
        yield ItemInitialState();
      }
      else if(searchText.isNotEmpty){
        print("all good +++++ xxxxx");
        yield ItemLoadingState();
        final item = await APIClient().search(event.text);
        if(item is SuccessFetch){
          yield ItemSuccessLoadState(item.itemModel);
        }
        else if(item is FailureFetch){
          yield ItemErrorLoadState(item.errorCode);
        }
      }
    }
  }
}
