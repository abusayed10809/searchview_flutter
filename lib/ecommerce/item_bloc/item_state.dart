part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitialState extends ItemState{}

class ItemLoadingState extends ItemState{
  final String itemName;

  ItemLoadingState({@required this.itemName});
  @override
  List<Object> get props => [itemName];
}

class ItemSuccessLoadState extends ItemState{
  final List<ItemModel> items;

  const ItemSuccessLoadState({@required this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class ItemErrorLoadState extends ItemState{
  final int error;
  const ItemErrorLoadState({@required this.error});

  @override
  List<Object> get props => [error];
}

class ItemDetailState extends ItemState{
  final ItemModel singleItem;

  ItemDetailState({@required this.singleItem});

  @override
  List<Object> get props => [singleItem];
}
