import 'package:dashbook/dashbook.dart';

import '../send_message_bar.dart';

void chatroomInquiryStories(Dashbook dashbook) {
  dashbook.storiesOf('SendMessageBar').decorator(CenterDecorator()).add(
        'default',
        (context) => SendMessageBar(
          onSend: () {
            print('send');
          },
          onEditInquiry: () {
            print('edit inquiry');
          },
        ),
      );
}
