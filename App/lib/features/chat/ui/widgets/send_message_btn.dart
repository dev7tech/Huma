import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/common/constants/colors.dart';
import 'package:hookup4u2/common/utils/image.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/chat/ui/widgets/typing_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SendMessageBtn extends StatefulWidget {
  final Function(String, String?) onSend;
  final Conversation conversation;
  final VoidCallback onTapGift;
  final bool isGiftOpen;

  const SendMessageBtn({
    super.key,
    required this.onSend,
    required this.conversation,
    required this.onTapGift,
    required this.isGiftOpen,
  });

  @override
  State<SendMessageBtn> createState() => _SendMessageBtnState();
}

class _SendMessageBtnState extends State<SendMessageBtn> {
  final TextEditingController _textController = TextEditingController();
  String? _img;
  bool _imgUploading = false;
  String? aiWaiting;
  RealtimeChannel? subscription;

  @override
  void dispose() {
    _textController.dispose();
    subscription?.unsubscribe();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    subscription = supabaseClient
        .channel('public:conversations')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'conversations',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'id',
              value: widget.conversation.id,
            ),
            callback: (payload) {
              print('new record: ${payload.newRecord['id']}');
              if (payload.newRecord['id'] != null) {
                setState(() {
                  aiWaiting = payload.newRecord['waiting'];
                });
              }
            })
        .subscribe();
  }

  void submitForm() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onSend(_textController.text.trim(), _img);
    }
  }

  late final _focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          submitForm();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    final aiBusy = aiWaiting != null && aiWaiting!.isNotEmpty;

    return BlocConsumer<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state is SendMessageError) {
          context.showError(state.message);
        }
        if (state is SendMessageSuccess) {
          _textController.clear();
          setState(() {
            _img = null;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: 10,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: secondaryColor, width: 1),
                    borderRadius: BorderRadius.circular(40)),
                margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: [
                          if (!widget.isGiftOpen)
                            Container(
                              margin: const EdgeInsets.only(top: 2.0),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4, right: 4),
                                child: InkWell(
                                  onTap: _imgUploading
                                      ? null
                                      : () async {
                                          ImagePicker imagePicker = ImagePicker();

                                          XFile? image = await imagePicker.pickImage(
                                              source: ImageSource.gallery);

                                          if (image == null) return;

                                          handleImgUpload(image);
                                        },
                                  child: _imgUploading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                          ))
                                      : Icon(
                                          Icons.photo_camera,
                                          color: primaryColor,
                                        ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                widget.onTapGift();
                              },
                              child: widget.isGiftOpen
                                  ? Icon(Icons.close, color: Colors.grey.shade300)
                                  : Icon(Icons.redeem_sharp, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextField(
                            focusNode: _focusNode,
                            controller: _textController,
                            maxLines: 4,
                            minLines: 1,
                            autofocus: false,
                            keyboardType: TextInputType.multiline,
                            // onFieldSubmitted: (_) => submitForm(),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                hintStyle: const TextStyle(color: Colors.grey),
                                hintText: "Send a message...".tr().toString()),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: state is SendMessageInProgress
                            ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                child: const SizedBox(
                                    width: 16, height: 16, child: CircularProgressIndicator()))
                            : IconButton(
                                icon: Transform.rotate(
                                  angle: -pi / 9,
                                  child: const Icon(
                                    Icons.send,
                                    size: 25,
                                  ),
                                ),
                                color: primaryColor,
                                onPressed: submitForm,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (aiBusy == true)
              Positioned(
                top: -45,
                left: 0,
                child: TypingIndicator(
                  aiAction:
                      aiWaiting ?? '${widget.conversation.aiProfile.name} is performing an action',
                  showIndicator: true,
                ),
              ),
            if (_img != null)
              Positioned(
                top: -30,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Image attached'),
                      InkWell(
                          onTap: state is SendMessageInProgress
                              ? null
                              : () {
                                  setState(() {
                                    _img = null;
                                  });
                                },
                          child: const Icon(Icons.close)),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  handleImgUpload(XFile image) async {
    setState(() {
      _imgUploading = true;
    });

    try {
      final imgPath = await uploadImage(image);
      setState(() {
        _img = '$kImageBucketBaseUrl/$imgPath';
      });
    } catch (err) {
      debugPrint('Failed to upload image: $err');
      context.showError('Failed to upload image. Please try again. ');
    } finally {
      setState(() {
        _imgUploading = false;
      });
    }
  }
}
