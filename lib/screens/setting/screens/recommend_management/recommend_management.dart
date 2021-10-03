import 'package:flutter/material.dart';

import 'components/body.dart';

class RecommendManagement extends StatefulWidget {
  @override
  _RecommendManagementState createState() => _RecommendManagementState();
}

class _RecommendManagementState extends State<RecommendManagement>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('推薦管理'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(),
    );
  }
}
