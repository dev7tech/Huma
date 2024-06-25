part of 'purchase_item_bloc.dart';

abstract class PurchaseItemEvent extends Equatable {
  const PurchaseItemEvent();

  @override
  List<Object> get props => [];
}

class PurchaseItem extends PurchaseItemEvent {
  final Item item;
  final Conversation conversation;
  final String userProfileName;

  const PurchaseItem(
      {required this.item, required this.conversation, required this.userProfileName});

  @override
  List<Object> get props => [item, conversation];
}
