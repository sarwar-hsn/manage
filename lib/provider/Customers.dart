import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:manage/Screens/Customer/customerDetailScreen.dart';
import '../Model/Customer.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class Customers extends SearchDelegate<String> with ChangeNotifier {
  List<Customer> _customers = [
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'Abdul',
      mobile: '01736524187',
      total: 1000,
      paid: 300,
      due: 700,
      address: 'birampur',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.facebook.com'),
      name: 'Hamid',
      mobile: '0173658967',
      total: 10000,
      paid: 3000,
      due: 7000,
      address: 'Hili',
      schedulePay: DateTime.now(),
    ),
  ];

  void customerByName() {
    _customers.sort((a, b) => a.name.compareTo(b.name));
  }

  List<Customer> scheduledCustomer(DateTime date) {
    List<Customer> temp = [];
    for (int i = 0; i < _customers.length; i++) {
      if (_customers[i].schedulePay != null &&
          DateFormat('dd-MM-yyyy').format(date).toString() ==
              DateFormat('dd-MM-yyyy')
                  .format(_customers[i].schedulePay)
                  .toString()) {
        temp.add(_customers[i]);
      }
    }
    return temp;
  }

  List<Customer> get customers {
    return [..._customers];
  }

  Customer getCustomerById(String id) {
    for (int i = 0; i < _customers.length; i++) {
      if (_customers[i].id == id) return _customers[i];
    }
    return null;
  }

  Map<String, Object> getCustomerPaymentInfoByDate(String id, DateTime date) {
    double total = 0, paid = 0, due = 0;
    Customer customer = getCustomerById(id);
    for (int i = 0; i < customer.products.length; i++) {
      if (DateFormat('dd-MM-yyyy').format(customer.products[i].date) ==
          DateFormat('dd-MM-yyyy').format(date)) {
        for (int j = 0; j < customer.products[i].products.length; j++) {
          total += customer.products[i].products[j].total;
        }
      }
    }
    for (int i = 0; i < customer.paymentDate.length; i++) {
      if (DateFormat('dd-MM-yyyy').format(date) ==
          DateFormat('dd-MM-yyyy').format(customer.paymentDate[i]['date'])) {
        paid += customer.paymentDate[i]['paid'];
      }
    }
    due = total - paid;
    return {
      'total': total,
      'paid': paid,
      'due': due,
    };
  }

  void callListner() {
    notifyListeners();
  }

  void addCustomer(Customer newCustomer) {
    _customers.add(newCustomer);
  }

  List<Customer> recentSearch = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  String getCustomerIdByName(String name) {
    for (int i = 0; i < _customers.length; i++) {
      if (_customers[i].name == name) return _customers[i].id;
    }
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    String id = getCustomerIdByName(query);
    Customer customer = getCustomerById(id);
    return Center(
      child: Text('sorry not found'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearch
        : customers.where((element) {
            return element.name.startsWith(query);
          }).toList();
    if (suggestionList.isEmpty) return Text('no search yet');
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            String id = getCustomerIdByName(suggestionList[index].name);
            Customer customer = getCustomerById(id);
            (customer == null)
                ? showResults(context)
                : Navigator.of(context).pushNamed(
                    CustomerDetailScreen.routeName,
                    arguments: customer.id);
          },
          leading: Icon(Icons.person),
          title: RichText(
              text: TextSpan(
                  text: suggestionList[index].name.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text: suggestionList[index].name.substring(query.length))
              ])),
        );
      },
    );
  }
}
