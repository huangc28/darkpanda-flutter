part of 'inquirer_profile.dart';

class InquirerProfileTabBarView extends StatelessWidget {
  const InquirerProfileTabBarView({
    this.userImages,
    this.tabController,
  });

  final List<UserImage> userImages;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final imageTabBarView = userImages.length == 0
        ? _buildEmptyImageTabBarView()
        : _buildScrollableImageTabBarView(userImages);

    return TabBarView(
      controller: tabController,
      children: [
        imageTabBarView,
        Container(
          child: Text('hello world'),
        ),
      ],
    );
  }

  Widget _buildEmptyImageTabBarView() {
    return Container(
      child: Center(
        child: Text('user has no images'),
      ),
    );
  }

  Widget _buildScrollableImageTabBarView(List<UserImage> userImages) {
    return Container(
      child: GridView.builder(
        itemCount: userImages.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Image(
              fit: BoxFit.fill,
              image: NetworkImage(userImages[index].url),
            ),
          );
        },
      ),
    );
  }
}
