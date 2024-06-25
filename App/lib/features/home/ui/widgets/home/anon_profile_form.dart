import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/home/bloc/anon_profile_bloc.dart';
import 'package:uuid/uuid.dart';

class AnonProfileForm extends StatefulWidget {
  const AnonProfileForm({super.key});

  @override
  State<AnonProfileForm> createState() => _AnonProfileFormState();
}

class _AnonProfileFormState extends State<AnonProfileForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // align 1 /3 from top
    return BlocBuilder<AnonProfileBloc, AnonProfileState>(
      builder: (context, state) {
        return Center(
          child: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                const Text(
                  'Lets get you set up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'What\'s your name?',
                    // border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  maxLength: 20,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: state is AnonProfileCreating
                      ? null
                      : () {
                          if (_nameController.text.isEmpty) {
                            context.showError('Name is required');
                            return;
                          }
                          context.read<AnonProfileBloc>().add(
                                CreateAnonProfile(Uuid().v4(), _nameController.text),
                              );
                        },
                  child: state is AnonProfileCreating
                      ? SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          ))
                      : const Text('Create profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
