part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitialState extends ItemState{}

class ItemLoadingState extends ItemState{}

class ItemSuccessLoadState extends ItemState{
  final List<ItemModel> items;

  const ItemSuccessLoadState(this.items);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class ItemErrorLoadState extends ItemState{
  final int error;
  const ItemErrorLoadState(this.error);

  @override
  List<Object> get props => [error];
}
