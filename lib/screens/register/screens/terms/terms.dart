import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';

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
        SizeConfig.screenWidth * 0.05, //30,
        SizeConfig.screenHeight * 0.05, //26,
        SizeConfig.screenWidth * 0.05, //30,
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
                      '通过访问我们的网站，您同意受这些服务条款，所有适用法律和法规的约束，并同意您有责任遵守任何适用的当地法律。如果您不同意这些条款中的任何一项，则禁止您使用或访问本网站。本网站所含材料受适用的版权和商标法保护。\n',
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
                      '允许在Bloom Ltd的网站上临时下载材料（信息或软件）的一份副本，仅供个人，非商业性的暂时性查看。这是授予许可，而不是所有权的转让，根据此许可，您不能：修改或复制材料；将这些材料用于任何商业目的，或用于任何公共展示（商业或非商业用途）；尝试对Bloom Ltd网站上包含的任何软件进行反编译或反向工程；从资料中删除任何版权或其他专有符号；要么将资料转移给其他或“镜像”任何其他服务器上的资料。如果您违反任何这些限制，则该许可将自动终止，并且Bloom Ltd可能会随时终止该许可。终止查看这些材料或终止本许可后，您必须销毁所有电子或印刷格式的下载材料',
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
        SizeConfig.screenWidth * 0.05, //30,
        SizeConfig.screenHeight * 0.05, //26,
        SizeConfig.screenWidth * 0.05, //30,
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
                      ' 隱私權保護政策內容，包括本App如何處理在您使用App服務時收集到的個人識別資料。隱私權保護政策不適用於本App以外的相關連結外部網頁，也不適用於非本App所委託或參與管理的人員。\n',
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
              // height: 30,
              height: SizeConfig.screenHeight * 0.04,
            ),

            /// Use [Expanded] to fill up the rest of the column space
            // Expanded(
            //   child:
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight * 0.02, //16.0,
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
            // ),
            SizedBox(
              // height: 30,
              height: SizeConfig.screenHeight * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
