part of '../inquirer_profile.dart';

class InquirerProfileImages extends StatelessWidget {
  const InquirerProfileImages({
    this.onLoadMoreImages,
    this.onTapImage,
    this.images,
  });

  final void Function() onLoadMoreImages;
  final ValueChanged<int> onTapImage;
  final List<UserImage> images;

  @override
  Widget build(BuildContext context) => images.length == 0
      ? _buildEmptyImageTabBarView()
      : _buildScrollableImageTabBarView(images);

  Widget _buildEmptyImageTabBarView() => Container(
        child: Center(
          child: Text('user has no images'),
        ),
      );

  Widget _buildScrollableImageTabBarView(List<UserImage> images) {
    return Container(
      child: LoadMoreScrollable(
        onLoadMore: onLoadMoreImages,
        builder: (context, scrollController) {
          return GridView.builder(
            controller: scrollController,
            itemCount: images.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onTapImage(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(images[index].url),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
