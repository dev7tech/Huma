Future<T> asyncExecutor<T>(Future<T> Function() function,
    [Function(Object)? errorFactory]) async {
  try {
    return await function();
  } catch (e) {
    if (errorFactory != null) {
      throw errorFactory(e);
    }
    rethrow;
  }
}
