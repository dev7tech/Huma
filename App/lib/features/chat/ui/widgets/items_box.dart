import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/items_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/purchase_item_bloc.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/chat/domain/models/item.dart';

class ItemsBox extends StatefulWidget {
  final bool isExpanded;
  final Conversation conversation;

  const ItemsBox({super.key, required this.isExpanded, required this.conversation});

  @override
  State<ItemsBox> createState() => _ItemsBoxState();
}

class _ItemsBoxState extends State<ItemsBox> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<ItemsBloc>(context).state is ItemsInitial
        ? context.read<ItemsBloc>().add(LoadItems())
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.of(context).size.width,
      height: widget.isExpanded ? 300.0 : 0.0,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (context, state) {
            if (state is ItemsLoaded) {
              final itemsState = state;

              final profile = context.select((RegistrationBloc bloc) => bloc.state.profile);

              return BlocBuilder<PurchaseItemBloc, PurchaseItemState>(
                builder: (context, state) {
                  if (state is PurchaseItemLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Purchasing item...'),
                          SizedBox(height: 8),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: List.generate(
                            itemsState.items.length,
                            (index) => ItemUi(
                              item: itemsState.items[index],
                              onTap: (item) => BlocProvider.of<PurchaseItemBloc>(context).add(
                                  PurchaseItem(
                                      item: item,
                                      conversation: widget.conversation,
                                      userProfileName: profile.userName ?? 'user')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            if (state is ItemsError) {
              return Column(
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ItemsBloc>().add(LoadItems());
                    },
                    child: const Text('Reload'),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class ItemUi extends StatelessWidget {
  final Item item;
  final Function(Item)? onTap;

  const ItemUi({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(item),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Text(
              item.formattedPrice,
              style: const TextStyle(
                // color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 80,
                  height: 80,
                  child: item.image != null
                      ? CachedNetworkImage(imageUrl: item.image!)
                      : Container(
                          color: Colors.grey.shade800,
                        )),
              Text(item.name ?? ''),
            ],
          ),
        ],
      ),
    );
  }
}
