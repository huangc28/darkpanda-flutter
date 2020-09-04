import 'package:flutter/material.dart';
/// LogoLayout is used by register and login screens.
class LogoLayout extends StatelessWidget {
	final Widget body;

	LogoLayout({ this.body }): super();

	@override
	Widget build (BuildContext context) {
		return Scaffold(
			body: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						UpperContainer(),
						BottomContainer(
							body: this.body,
						),
					]
			)
		);
	}
}

class CompanyLogo extends StatelessWidget {
	@override
	Widget build (BuildContext context) {
		return Image.asset('assets/sample_logo.png');
	}
}

class UpperContainer extends StatelessWidget {
	final Widget body;

	UpperContainer({ this.body }): super();

	@override
	Widget build (BuildContext context) {
		return Expanded(
			flex: 3,
			child: FittedBox(
				fit: BoxFit.none,
				child: CompanyLogo(),
			),
		);
	}
}

class BottomContainer extends StatelessWidget {
	final Widget body;

	BottomContainer({ this.body }): super();

	@override
	Widget build(BuildContext context) {
		return Expanded(
			flex: 7,
			child: Container(
				margin: EdgeInsets.only(top: 25.0),
				child: this.body,
			)
		);
	}
}

