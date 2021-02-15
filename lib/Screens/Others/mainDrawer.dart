import 'package:manage/Screens/Customer/addcustomer.dart';
import 'package:manage/Screens/Customer/customersScreen.dart';
import 'package:manage/Screens/Others/dailycheck.dart';
import 'package:manage/Screens/Others/transaction.dart';
import 'package:manage/Screens/Product/ProductsScreen.dart';
import 'package:manage/Screens/Product/addCategories.dart';
import 'package:manage/Screens/Product/addProductsScreen.dart';

import 'package:manage/Screens/Product/catergoryScreen.dart';

import 'package:flutter/material.dart';
import 'package:manage/Screens/Stock/addStockScreen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildListTile(
              icon: Icons.home,
              text: 'HomePage',
              tapHandler: () {
                print('pressed');
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            BuildListTile(
              icon: Icons.person_search,
              text: 'Customers',
              tapHandler: () {
                Navigator.of(context)
                    .pushReplacementNamed(CustomersScreen.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.money,
              text: 'Transaction History',
              tapHandler: () {
                Navigator.of(context)
                    .pushReplacementNamed(TransactionHistoryScreen.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.scatter_plot_rounded,
              text: 'Products',
              tapHandler: () {
                Navigator.of(context)
                    .pushReplacementNamed(CategoryScreen.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.person_add,
              text: 'Add customer',
              tapHandler: () {
                Navigator.of(context).pushNamed(AddCustomerScreen.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.add_box,
              text: 'Add Products',
              tapHandler: () {
                Navigator.of(context).pushNamed(AddProductsScreen.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.add_box,
              text: 'Add Categories',
              tapHandler: () {
                Navigator.of(context).pushNamed(AddCategoriesScreen.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.notifications,
              text: 'Daily Check',
              tapHandler: () {
                Navigator.of(context)
                    .pushReplacementNamed(DailyCheck.routeName);
              },
            ),
            BuildListTile(
              icon: Icons.add_shopping_cart,
              text: 'Add to Stock',
              tapHandler: () {
                Navigator.of(context).pushNamed(AddToStockScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BuildListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function tapHandler;
  BuildListTile({this.icon, this.text, this.tapHandler});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 20, right: 50),
          leading: Icon(icon),
          trailing: Text(text),
          onTap: tapHandler,
        ),
        Divider(),
      ],
    );
  }
}
