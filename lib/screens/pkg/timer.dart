class Timer {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: ticks), (x) => ticks - x - 1)
        .take(ticks);
  }
}
