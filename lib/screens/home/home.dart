import 'package:flutter/material.dart';

class Home extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('my first app'),
				centerTitle: true,
				backgroundColor: Colors.red[600],
			),

			body: Center(
				child: Image(
					image: NetworkImage('https://images.unsplash.com/photo-1598866910544-f2345ffca21b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'),
				),
			),

			floatingActionButton: FloatingActionButton(
				child: Text('click me'),
				onPressed: () {},
				backgroundColor: Colors.red[600],
			),
		);
	}
}
