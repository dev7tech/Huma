import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required int id,
    String? name,
    String? description,
    String? image,
    @JsonKey(name: "price_coins") required int priceCoins,
  }) = _Item;

  factory Item.fromJson(Map<String, Object?> json) => _$ItemFromJson(json);
}

extension ItemX on Item {
  String get formattedPrice {
    return '\$${priceCoins / 100}';
  }
}
