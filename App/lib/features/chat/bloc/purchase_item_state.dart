part of 'purchase_item_bloc.dart';

abstract class PurchaseItemState extends Equatable {
  const PurchaseItemState();

  @override
  List<Object> get props => [];
}

class PurchaseItemInitial extends PurchaseItemState {}

class PurchaseItemLoading extends PurchaseItemState {}

class PurchaseItemSuccess extends PurchaseItemState {}

class PurchaseItemFailure extends PurchaseItemState {
  final String error;

  const PurchaseItemFailure({required this.error});

  @override
  List<Object> get props => [error];
}
