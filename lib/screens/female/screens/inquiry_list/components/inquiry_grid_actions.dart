part of 'inquiry_grid.dart';

// @Issue: https://stackoverflow.com/questions/58812778/a-borderradius-can-only-be-given-for-uniform-borders
class InquiryGridActions extends StatelessWidget {
  const InquiryGridActions({
    @required this.onTapChat,
    @required this.inquiry,
  });

  final ValueChanged<String> onTapChat;
  final Inquiry inquiry;

  Widget _buildChatButton() {
    String btnText = '';
    Icon icon = null;
    Function btnHandler = () => {};

    print('DEBUG _buildChatButton ${inquiry.inquiryStatus}');

    if (inquiry.inquiryStatus == InquiryStatus.inquiring) {
      btnText = '立即洽談';
      btnHandler = () {
        onTapChat(inquiry.uuid);
      };
    }

    if (inquiry.inquiryStatus == InquiryStatus.asking) {
      btnText = '等待回應';
      icon = Icon(
        Icons.schedule,
        size: 14,
        color: Color.fromRGBO(31, 30, 56, 1),
      );
      btnHandler = () => {};
    }

    return Expanded(
      child: DPTextButton(
        theme: DPTextButtonThemes.lightGrey,
        onPressed: btnHandler,
        text: btnText,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(106, 109, 137, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        margin: const EdgeInsetsDirectional.only(
          start: 0.5,
          end: 0.5,
          top: 1,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(6.0),
            topRight: const Radius.circular(6.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Hide button
            Expanded(
              child: DPTextButton(
                theme: DPTextButtonThemes.grey,
                onPressed: () {
                  print('DEBUG trigger hide');
                },
                text: '隱藏',
              ),
            ),

            SizedBox(
              width: 11,
            ),

            // Check profile button
            Expanded(
              child: SizedBox(
                height: 44,
                child: DPTextButton(
                  theme: DPTextButtonThemes.grey,
                  onPressed: () {
                    print('DEBUG trigger hide');
                  },
                  text: '看他檔案',
                ),
              ),
            ),

            SizedBox(
              width: 11,
            ),

            // Chat now button
            _buildChatButton(),
          ],
        ),
      ),
    );
  }
}
