import 'package:flutter/material.dart';
import 'package:music/widgets/header.dart';
import 'package:music/provides/counter.dart';
import 'package:music/provides/switcher.dart';
import 'package:provide/provide.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Provide<Counter>(
              builder: (context, child, counter) {
                return Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
            Provide<Switcher>(builder: (context, child, switcher) {
              return Switch(
                value: switcher.status, 
                onChanged: (newVal) {
                  switcher.changeStatus();
                }
              );
            },)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Header())
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}