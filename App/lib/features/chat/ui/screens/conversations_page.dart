import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/conversation_bloc.dart';
import 'package:hookup4u2/features/chat/ui/widgets/conversation/chat_list_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    final profile = context.read<RegistrationBloc>().state.profile;

    supabaseClient
        .channel('public:conversations')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'conversations',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'profiles_id',
              value: profile.id,
            ),
            callback: (payload) {
              if (payload.newRecord['id'] != null) {
                print('convoo updated ${payload.newRecord['id']}');
                context
                    .read<ConversationBloc>()
                    .add(UpsertConversationEvent(payload.newRecord['id']));
              }
            })
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is ConversationLoading) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) => const ChatListItemSkeleton(),
          );
        } else if (state is ConversationLoaded) {
          final conversations = [...state.conversations];
          conversations.sort(
            (a, b) => (b.lastMessageAt ?? DateTime.now()).compareTo(
              a.lastMessageAt ?? DateTime.now(),
            ),
          );

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) => ChatListItem(conversation: conversations[index]),
          );
        } else if (state is ConversationError) {
          return Center(child: Text(state.errorMessage));
        }

        return Container();
      },
    );
  }
}
