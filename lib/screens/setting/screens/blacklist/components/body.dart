import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/blacklist.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/bloc/load_blacklist_user_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/bloc/remove_blacklist_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/models/blacklist_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AuthUser _sender;
  List<BlacklistUser> blacklistUserList = [];

  @override
  void initState() {
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    BlocProvider.of<LoadBlacklistUserBloc>(context).add(
      LoadBlacklistUser(uuid: _sender.uuid),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 26, 20, 0),
          child: BlocListener<LoadBlacklistUserBloc, LoadBlacklistUserState>(
            listener: (context, state) {
              if (state.status == AsyncLoadingStatus.done) {
                blacklistUserList = state.blacklistUserList;
              }
            },
            child: BlocBuilder<LoadBlacklistUserBloc, LoadBlacklistUserState>(
              builder: (context, state) {
                if (state.status == AsyncLoadingStatus.done) {
                  return Column(
                      children: List.generate(
                    blacklistUserList.length,
                    (index) {
                      return userList(
                          context: context,
                          blacklistUser: blacklistUserList[index],
                          index: index);
                    },
                  ));
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget userList({BuildContext context, BlacklistUser blacklistUser, index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(255, 255, 255, 0.1),
          border: Border.all(
            style: BorderStyle.solid,
            width: 0.5,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: (blacklistUser.avatarUrl != "")
                          ? NetworkImage(blacklistUser.avatarUrl)
                          : AssetImage('assets/logo.png'),
                    ),
                    SizedBox(width: 15),
                    Text(
                      blacklistUser.userName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // background
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<RemoveBlacklistBloc>(context).add(
                          RemoveBlacklist(
                            blacklistId: blacklistUser.id,
                          ),
                        );
                        setState(() {
                          blacklistUserList.removeWhere(
                              (item) => item.id == blacklistUser.id);
                        });
                      },
                      child: Text(
                        '解除封鎖',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
