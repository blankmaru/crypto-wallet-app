import 'dart:convert';
import 'package:cryptowallet/CryptoData.dart';
import 'package:cryptowallet/ui/component/appBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum TabItem {home, explore, notification, settings}

class AppList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppListState();
  }
}

class AppListState extends State<AppList> {
  List<CryptoData> data = [];
  TabItem _currentItem = TabItem.home;
  final List<TabItem> _bottomTabs = [TabItem.home, TabItem.explore, TabItem.notification, TabItem.settings];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: SafeArea(
          child: appBar(
              left: Icon(Icons.notes, color: Colors.black54),
              title: 'Wallets',
              right: Icon(Icons.account_balance_wallet, color: Colors.black54),
          ),
        ),
      ),
      body: _buildScreen(),
      bottomNavigationBar: _bottomNavigationBar(),
      // body: Container(
      //     child: ListView(
      //       children: _buildList(),
      //     )
      // ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.refresh),
      //   onPressed: () => _loadCryptoData(),
      // ),
    );
  }

  Widget _buildScreen() {
    switch(_currentItem) {
      case TabItem.home:
        return Container(
          child: Center(child: Text('Home')),
        );
        break;
      case TabItem.explore:
        return Container(
          child: Center(child: Text('Explore')),
        );
        break;
      case TabItem.notification:
        return Container(
          child: Center(child: Text('Notifications')),
        );
        break;
      case TabItem.settings:
        return Container(
          child: Center(child: Text('Settings')),
        );
        break;
      default:
        return Container(
          child: Center(child: Text('Error')),
        );
        break;
    }
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(items: _bottomTabs.map((tabItem) => _bottomNavigationBarItem(_icon(tabItem), tabItem)).toList(),
    onTap: _onSelectedTab,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
    );
  }

  void _onSelectedTab(int index) {
    TabItem selectedTabItem = _bottomTabs[index];
    setState(() {
      _currentItem = selectedTabItem;
    });
  }

  BottomNavigationBarItem _bottomNavigationBarItem(IconData icon, TabItem item) {
    final Color color = _currentItem == item ? Colors.black54 : Colors.black26;
    return BottomNavigationBarItem(icon: Icon(icon, color: color), label: '');
  }

  IconData _icon(TabItem item) {
    switch (item) {
      case TabItem.home:
        return Icons.account_balance_wallet;
      case TabItem.explore:
        return Icons.explore;
      case TabItem.notification:
        return Icons.notifications;
      case TabItem.settings:
        return Icons.settings;
    }
  }

  _loadCryptoData() async {
    Uri uri = Uri.parse('https://api.coincap.io/v2/assets?limit=10');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var allData = (jsonDecode(response.body) as Map)['data'];
      var cryptoDataList = <CryptoData>[];
      allData.forEach((value) {
        var record = CryptoData(
            name: value['name'],
            price: double.parse(value['priceUsd']),
            rank: int.parse(value['rank']),
            symbol: value['symbol']
        );
        cryptoDataList.add(record);
      });
      setState(() {
        data = cryptoDataList;
      });
    }
  }

  List<Widget> _buildList() {
    return data.map((CryptoData el) => ListTile(
      subtitle: Text(el.symbol),
      title: Text(el.name),
      leading: CircleAvatar(child: Text(el.rank.toString())),
      trailing: Text('\$${el.price.toString()}'),
    )).toList();
  }
}