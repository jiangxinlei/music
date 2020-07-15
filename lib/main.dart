import 'package:flutter/material.dart';
import 'package:music/widgets/home.dart';
import 'package:music/provides/counter.dart';
import 'package:music/provides/switcher.dart';
import 'package:music/views/DiscoveryPage.dart';
import 'package:music/views/MyPage.dart';
import 'package:music/views/VideoPage.dart';
import 'package:music/views/YunPage.dart';
import 'package:provide/provide.dart';

void main() {
  var counter = Counter();
  var switcher = Switcher();

  var providers = Providers();

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<Switcher>.value(switcher));

  runApp(ProviderNode(child: MyApp(), providers: providers));

}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> _homeTabs = [
    {
      'title': '我的',
      'page': MyPage()
    },
    {
      'title': '发现',
      'page': DiscoveryPage()
    },
    {
      'title': '云村',
      'page': YunPage()
    },
    {
      'title': '视频',
      'page': VideoPage()
    }
  ];

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        highlightColor: Colors.transparent,  // Tabbar 点击时的背景
        splashColor: Colors.transparent,
        primaryColorLight: Colors.red
      ),
      home: DefaultTabController(
        length: _homeTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              indicatorColor: Colors.transparent,
              tabs: _homeTabs.map((_tab) => Tab(
                text: _tab['title'],
              )).toList()
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: () {
                  // showSearch(
                  //   context: context, 
                  //   delegate: SearchBarDelegate()
                  // )
                }
              )
            ],
          ),
          drawer: Drawer(
            semanticLabel: 'jxl',
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        child: FlutterLogo(),
                      ),
                    ),
                  )
                ),

                ListTile(
                  leading: Icon(Icons.track_changes),
                  title: Text('change history'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

