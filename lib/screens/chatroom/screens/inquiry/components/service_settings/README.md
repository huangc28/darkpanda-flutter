How to format duration in the form of **02:10**?

``` dart
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}";
  }
```