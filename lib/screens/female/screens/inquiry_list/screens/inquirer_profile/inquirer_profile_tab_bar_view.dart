part of 'inquirer_profile.dart';

class InquirerProfileTabBarView extends StatelessWidget {
  const InquirerProfileTabBarView({
    this.userImages,
    this.tabController,
  });

  final List<UserImage> userImages;
  final TabController tabController;

  // Expanded(
  //   child: TabBarView(
  //     controller: _tabController,
  //     children: [
  //       Container(
  //         //   child: GridView.builder(
  //         //     itemCount: ,

  //         //   ),
  //         child: GridView.count(
  //             scrollDirection: Axis.vertical,
  //             crossAxisCount: 3,
  //             children: List.generate(100, (index) {
  //               return Center(
  //                 child: Text(
  //                   'Item $index',
  //                   style: Theme.of(context).textTheme.headline5,
  //                 ),
  //               );
  //             })),
  //       ),
  //       Container(
  //         child: Text('spot 2'),
  //       ),
  //     ],
  //   ),
  // ),
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        Container(
          child: GridView.builder(
            itemCount: userImages.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
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
        ),
        Container(
          child: Text('hello world'),
        ),
      ],
    );

    // return Container(
    //   child: GridView.builder(
    //     itemCount: userImages.length,
    //     gridDelegate:
    //         new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    //     itemBuilder: (context, index) {
    //       return Center(
    //         child: Text(
    //           'Item $index',
    //           style: Theme.of(context).textTheme.headline5,
    //         ),
    //       );
    //     },
    //   ),
    // child: GridView.count(
    //   scrollDirection: Axis.vertical,
    //   crossAxisCount: 3,
    //   children: List.generate(
    //     100,
    //     (index) {
    //       return Center(
    //         child: Text(
    //           'Item $index',
    //           style: Theme.of(context).textTheme.headline5,
    //         ),
    //       );
    //     },
    //   ),
    // ),
  }
}
