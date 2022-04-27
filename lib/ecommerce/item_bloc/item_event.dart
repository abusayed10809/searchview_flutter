part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class TextChanged extends ItemEvent{
  final String text;

  const TextChanged({
    @required this.text
  });

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'Text Changed {text: $text}';
}
