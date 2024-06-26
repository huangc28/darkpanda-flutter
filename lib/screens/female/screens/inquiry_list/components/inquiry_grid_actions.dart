part of 'inquiry_grid.dart';

// @Issue: https://stackoverflow.com/questions/58812778/a-borderradius-can-only-be-given-for-uniform-borders
class InquiryGridActions extends StatelessWidget {
  const InquiryGridActions({
    @required this.onTapPickup,
    @required this.inquiry,
    @required this.onTapClear,
    @required this.onTapCheckProfile,
    @required this.onTapStartChat,
    this.isLoading = false,
    this.inquiryUuid = "",
  });

  final ValueChanged<String> onTapPickup;
  final ValueChanged<String> onTapClear;
  final ValueChanged<String> onTapCheckProfile;
  final ValueChanged<Inquiry> onTapStartChat;
  final Inquiry inquiry;
  final bool isLoading;
  final String inquiryUuid;

  Widget _buildChatButton() {
    String btnText = ' ';
    Icon icon = null;
    Function btnHandler = () => {};
    DPTextButtonThemes theme = DPTextButtonThemes.purple;

    if (inquiry.inquiryStatus == InquiryStatus.inquiring) {
      btnText = '立即洽談';
      btnHandler = () {
        onTapPickup(inquiry.uuid);
      };
    }

    if (inquiry.inquiryStatus == InquiryStatus.asking) {
      btnText = '等待回應';
      icon = Icon(
        Icons.schedule,
        size: 14,
        color: Colors.white,
      );
      btnHandler = () => {};
      theme = DPTextButtonThemes.grey;
    }

    return Expanded(
      child: SizedBox(
        height: 44,
        child: DPTextButton(
          disabled: inquiryUuid == inquiry.uuid && isLoading,
          loading: inquiryUuid == inquiry.uuid && isLoading,
          theme: theme,
          onPressed: btnHandler,
          text: btnText,
          icon: icon,
        ),
      ),
    );
  }

  Widget _buildThreeButtonActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Hide button
        // Expanded(
        //   child: SizedBox(
        //     height: 44, //SizeConfig.screenHeight * 0.05, //44,
        //     child: DPTextButton(
        //       theme: DPTextButtonThemes.grey,
        //       onPressed: () {
        //         print('DEBUG trigger hide');
        //       },
        //       text: '隱藏',
        //     ),
        //   ),
        // ),

        // Check profile button
        Expanded(
          child: SizedBox(
            height: 44,
            child: DPTextButton(
              theme: DPTextButtonThemes.grey,
              onPressed: () {
                onTapCheckProfile(inquiry.inquirer.uuid);
              },
              text: '看他檔案',
            ),
          ),
        ),

        SizedBox(
          width: SizeConfig.screenWidth * 0.03, //11,
        ),

        // Chat now button
        _buildChatButton(),
      ],
    );
  }

  Widget _buildDeniedAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text(
            '對方已回絕',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          width: 77,
          child: DPTextButton(
            theme: DPTextButtonThemes.grey,
            text: '清除',
            onPressed: () {
              onTapClear(inquiry.uuid);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text(
            '對方已同意洽談',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          width: 77,
          child: DPTextButton(
            theme: DPTextButtonThemes.purple,
            text: '開始洽談',
            onPressed: () {
              onTapStartChat(inquiry);
            },
          ),
        ),
      ],
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
        // If inquiry status is canceled, we display denied action bar.
        child: Builder(builder: (BuildContext context) {
          if (inquiry.inquiryStatus == InquiryStatus.canceled) {
            return _buildDeniedAction();
          }

          if (inquiry.inquiryStatus == InquiryStatus.chatting) {
            return _buildChatAction();
          }

          return _buildThreeButtonActions();
        }),
      ),
    );
  }
}
