part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class TextChanged extends ItemEvent{
  final String text;

  const TextChanged({
    @required this.text,
  });

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'Text Changed {text: $text}';
}

class ScrolledToBottom extends ItemEvent{
  final List<ItemModel> oldItemList;
  final String itemName;

  const ScrolledToBottom({@required this.itemName, @required this.oldItemList});

  @override
  List<Object> get props => [oldItemList];
}