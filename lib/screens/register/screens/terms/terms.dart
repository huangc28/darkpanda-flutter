import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/routes.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';

// @TODO tabBar underline style should be fixed
class Terms extends StatefulWidget {
  const Terms({
    Key key,
    this.onPush,
  }) : super(key: key);

  final ValueChanged<String> onPush;

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  Widget _buildServiceTerms() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.screenWidth * 0.05,
        SizeConfig.screenHeight * 0.05,
        SizeConfig.screenWidth * 0.05,
        0,
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(106, 109, 137, 1),
            height: 2,
          ),
          children: [
            TextSpan(
              text: '1.條款\n',
              children: [
                TextSpan(
                  text:
                      '通過訪問我們的網站，您同意受這些服務條款，所有適用法律和法規的約束，並同意您有責任遵守任何適用的當地法律。如果您不同意這些條款中的任何一項，則禁止您使用或訪問本網站。本網站所含材料受適用的版權和商標法保護。\n',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextSpan(
              text: '2.使用許可\n',
              children: [
                TextSpan(
                  text:
                      '允許在Bloom Ltd的網站上臨時下載材料（信息或軟件）的一份副本，僅供個人，非商業性的暫時性查看。這是授予許可，而不是所有權的轉讓，根據此許可，您不能：修改或複製材料；將這些材料用於任何商業目的，或用於任何公共展示（商業或非商業用途）；嘗試對Bloom Ltd網站上包含的任何軟件進行反編譯或反向工程；從資料中刪除任何版權或其他專有符號；要么將資料轉移給其他或“鏡像”任何其他服務器上的資料。如果您違反任何這些限制，則該許可將自動終止，並且Bloom Ltd可能會隨時終止該許可。終止查看這些材料或終止本許可後，您必須銷毀所有電子或印刷格式的下載材料',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // The content of this sector is from here: http://www.synct.com.tw/privacy.html
  // Complete it if you got time.
  Widget _buildPrivacyTerms() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.screenWidth * 0.05,
        SizeConfig.screenHeight * 0.05,
        SizeConfig.screenWidth * 0.05,
        0,
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(106, 109, 137, 1),
            height: 2,
          ),
          children: [
            TextSpan(
              text: '1.隱私權保護政策的適用範圍\n',
              children: [
                TextSpan(
                  text:
                      '隱私權保護政策內容，包括本App如何處理在您使用App服務時收集到的個人識別資料。隱私權保護政策不適用於本App以外的相關連結外部網頁，也不適用於非本App所委託或參與管理的人員。\n',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextSpan(
              text: '2.個人資料的蒐集、處理及利用方式\n',
              children: [
                TextSpan(
                  text:
                      '本App將向使用者蒐集以下個人資料。若您拒絕提供，將無法提供您使用本 APP 相關服務： 當您登入使用本App時，根據本App提供服務性質不同，我們會請您提供個人資訊，包括：帳號、密碼、電話、營造業編號、建築師開業證書母號、電子簽名及其他相關必要資料。 於一般連線時，伺服器會自行記錄相關行徑，包括您使用連線設備的IP位址、使用時間、使用的作業系統、瀏覽及點選資料記錄等，做為我們增進App服務的參考依據，此記錄為內部應用，決不對外公佈。',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(
              MainRoutes.login,
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Image.asset(
          'assets/horizontal_logo_banner.png',
          fit: BoxFit.cover,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 16,
            letterSpacing: 0.53,
          ),
          tabs: [
            Tab(text: '服務條款'),
            Tab(text: '隱私政策'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildServiceTerms(),
                  _buildPrivacyTerms(),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.04,
            ),

            /// Use [Expanded] to fill up the rest of the column space
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight * 0.02,
                vertical: 0,
              ),
              child: SizedBox(
                height: SizeConfig.screenHeight * 0.065,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DPTextButton(
                      theme: DPTextButtonThemes.purple,
                      onPressed: () {
                        widget.onPush('/register/choose-gender');
                      },
                      text: '我同意'),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
