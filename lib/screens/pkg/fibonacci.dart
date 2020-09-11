class Fib {
  List<int> numSeries = [0, 1, 1];

  static int genFib(int num) {
    var res = [0, 1];

    if (num <= 1) {
      return res[num];
    }

    for (var i = 2; i <= num; i++) {
      res[i] = res[i - 1] + res[i - 2];
    }

    return res[num];
  }
}
