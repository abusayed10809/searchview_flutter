import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        yield ItemLoadingState(searchText);
        final item = await APIClient().search(0, event.text);
        if(item is SuccessFetch){
          yield ItemSuccessLoadState(item.itemModel);
        }
        else if(item is FailureFetch){
          yield ItemErrorLoadState(item.errorCode);
        }
      }
    }
    if(event is ScrolledToBottom){
      List<ItemModel> oldItemList = event.oldItemList;
      String itemName = event.itemName;
      final item = await APIClient().search(oldItemList.length, itemName);
      if(item is SuccessFetch){
        List<ItemModel> newList = oldItemList + item.itemModel;
        yield ItemSuccessLoadState(newList);
      }
      else if(item is FailureFetch){
        yield ItemErrorLoadState(item.errorCode);
      }
    }
  }
}
