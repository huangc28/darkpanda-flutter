part of 'inquirer_profile.dart';

abstract class BaseLabel<V> {
  String get label;
  V get val;
}

class AgeLabel<V> extends BaseLabel {
  final String label;
  final V val;

  AgeLabel({
    this.label,
    this.val,
  });
}

class HeightLabel<V> extends BaseLabel {
  final String label;
  final V val;

  HeightLabel({
    this.label,
    this.val,
  });
}

class WeightLabel<V> extends BaseLabel {
  final String label;
  final V val;

  WeightLabel({
    this.label,
    this.val,
  });
}

class InquirerProfileStatusBar extends StatelessWidget {
  const InquirerProfileStatusBar({
    @required this.ageLabel,
    @required this.heightLabel,
    @required this.weightLabel,
  });

  final AgeLabel ageLabel;
  final HeightLabel heightLabel;
  final WeightLabel weightLabel;

  @override
  Widget build(BuildContext context) {
    final labels = [
      ageLabel,
      heightLabel,
      weightLabel,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: labels.map((label) => _buildLabel(label)).toList(),
    );
  }

  Widget _buildLabel(BaseLabel label) {
    return Expanded(
        flex: 1,
        child: Column(
          children: [
            Text(
              label.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              label.val != null ? '${label.val}' : 'unknown',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ));
  }
}
