import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/layouts/logo.dart' as LoginLayout;

class Login extends StatelessWidget {
	@override
	Widget build (BuildContext context) {
		return Scaffold(
			body: LoginLayout.LogoLayout(
				body: LoginBtnContainer(),
			),
		);
	}
}

class LoginBtnContainer extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.start,
			children: <Widget>[
				Container(
					child: Text(
							'Register',
							style: TextStyle(
									fontWeight: FontWeight.bold,
									fontSize: 44.0,
							),
					),
				),
				SizedBox(height: 60),
				ButtonTheme(
					minWidth: 200.0,
					height: 50.0,
					child:OutlineButton(
						child: Text('Login'),
						onPressed: () {

							Navigator.pushNamed(context, '/register');
							// navigate to login page
							//print('pressed login');
						},
						shape: new RoundedRectangleBorder(
							borderRadius: new BorderRadius.circular(20.0)
						)
					)
				),
			],
		);
	}
}

