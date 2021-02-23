import 'package:flutter/material.dart';
import 'package:manage/Widgets/CustomerListView.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';
import '../Others/searchByName.dart';

class CustomersScreen extends StatefulWidget {
  static const routeName = '/customerScreen';

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Customers>(context, listen: false).fetCustomers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer OverView Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchByName(
                        customers:
                            Provider.of<Customers>(context, listen: false)
                                .customers));
              })
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueGrey, Colors.white70])),
          child: CustomerListView()),
      backgroundColor: Colors.white70,
    );
  }
}
