import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/data/repo/in_app_purchase_repo.dart';
import 'buyproducts_barrel.dart';

class BuyConsumableInAppProductsBloc
    extends Bloc<BuyInAppProductsEvents, BuyConsumableStates> {
  final inAppPurchaseRepository = InAppPurchaseRepoImpl();
  BuyConsumableInAppProductsBloc() : super(BuyConsumableInitialState()) {
    on<RequestBuyConsumableProducts>((event, emit) async {
      emit(BuyConsumableLoadingState());
      try {
        final result = await inAppPurchaseRepository.buyConsumable(
            productDetails: event.productDetails);
        emit(BuyConsumableSuccessState(result: result));
      } on SocketException {
        emit(BuyConsumableFailedState(msg: 'No Internet Connection'));
      } catch (e) {
        emit(BuyConsumableFailedState(msg: e.toString()));
        rethrow;
      }
    });
  }

  Stream<BuyConsumableStates> mapEventToState(
      BuyInAppProductsEvents event) async* {
    if (event is RequestBuyConsumableProducts) {
      yield BuyConsumableLoadingState();

      try {
        final result = await inAppPurchaseRepository.buyConsumable(
            productDetails: event.productDetails);
        yield BuyConsumableSuccessState(result: result);
      } on SocketException {
        yield BuyConsumableFailedState(msg: 'No Internet Connection');
      } catch (e) {
        debugPrint(e.toString());
        yield BuyConsumableFailedState(msg: e.toString());
      }
    }
  }
}
