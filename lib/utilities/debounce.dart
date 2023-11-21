import 'dart:async';

class DebouncerOptionsBuilder<T> {
  final int milliseconds;

  DebouncerOptionsBuilder({required this.milliseconds});

  String? lastSearch;

  Future<Iterable<T>> result(String query,
      Future<Iterable<T>> Function(String query) optionsBuilder) async {
    lastSearch = query;

    await Future.delayed(Duration(milliseconds: milliseconds));

    if (lastSearch == query) {
      return optionsBuilder(query);
    }

    return [];
  }
}
