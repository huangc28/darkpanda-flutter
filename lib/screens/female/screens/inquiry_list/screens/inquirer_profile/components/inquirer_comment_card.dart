part of '../inquirer_profile.dart';

class InquirerCommentCard extends StatelessWidget {
  const InquirerCommentCard({Key key}) : super(key: key);

  Widget _buildCommentatorInfoBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            // width: 900,
            child: Row(
              children: [
                UserAvatar(""),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Commentator name.
                      Text(
                        'Jenny',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 10),

                      // Commentator rating.
                      RatingBarIndicator(
                        unratedColor: Colors.grey,
                        rating: 3,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '2020-05-20',
                  style: TextStyle(
                    color: Color.fromRGBO(106, 109, 137, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildcommentText() {
    return Text(
      ' 小姐姐人不錯，身材很好好，服務也不錯，就是希望下次能準時點。',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(31, 30, 56, 1),
          border: Border.all(
            style: BorderStyle.solid,
            width: 0.5,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommentatorInfoBar(),
            SizedBox(height: 12),
            _buildcommentText(),
          ],
        ),
      ),
    );
  }
}
