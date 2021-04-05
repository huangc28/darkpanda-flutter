part of '../inquirer_profile.dart';

class InquirerGalleryImage extends StatelessWidget {
  const InquirerGalleryImage({
    Key key,
    this.src,
  }) : super(key: key);

  final String src;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 133,
      height: 177,
      child: Image.network(
        src,
        fit: BoxFit.fill,
      ),
    );
  }
}
