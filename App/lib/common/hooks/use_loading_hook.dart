import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingState {
  final ValueNotifier<Future<void>?> future;
  final AsyncSnapshot<void> snapshot;
  final bool isLoading;

  LoadingState({
    required this.future,
    required this.snapshot,
    required this.isLoading,
  });
}

LoadingState useLoadingState<T>() {
  final loginFuture = useState<Future<T>?>(null);
  final snapshot = useFuture(loginFuture.value);
  final isLoading = snapshot.connectionState == ConnectionState.waiting;

  return LoadingState(
      future: loginFuture, snapshot: snapshot, isLoading: isLoading);
}
