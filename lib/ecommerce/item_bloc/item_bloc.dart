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
  ItemBloc() : super(ItemInitialState()){
    on<ItemEvent>((event, emit) async {
      if(event is TextChanged){
        final searchText = event.text;

        if(searchText.isEmpty){
          emit(ItemInitialState());
        }
        else if(searchText.isNotEmpty){
          emit(ItemLoadingState(itemName: searchText));
          final item = await APIClient().search(0, event.text);
          if(item is SuccessFetch){
            emit(ItemSuccessLoadState(items: item.itemModel));
          }
          else if(item is FailureFetch){
            emit(ItemErrorLoadState(error: item.errorCode));
          }
        }
      }
      if(event is ScrolledToBottom){
        List<ItemModel> oldItemList = event.oldItemList;
        String itemName = event.itemName;
        print("item name: $itemName");
        final item = await APIClient().search(oldItemList.length, itemName);
        if(item is SuccessFetch){
          List<ItemModel> newList = oldItemList + item.itemModel;
          emit(ItemSuccessLoadState(items: newList));
        }
        else if(item is FailureFetch){
          emit(ItemErrorLoadState(error: item.errorCode));
        }
      }
      if(event is ItemNextPageEvent){
        ItemModel singleItem = event.singleItem;
        emit(ItemDetailState(singleItem: singleItem));
      }
    });
  }
}
