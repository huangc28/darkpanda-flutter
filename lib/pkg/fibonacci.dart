class Fib {
  static int genFib(int num) {
    var res = [0, 1];

    if (num <= 1) {
      return res[num];
    }

    for (var i = 2; i <= num; i++) {
      res.add(res[i - 1] + res[i - 2]);
    }

    return res[num];
  }
}
