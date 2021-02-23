import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';

import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

import 'EditProduct.dart';

class EditCustomerScreen extends StatefulWidget {
  static const routeName = '/EditCustomerScreen';

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  DateTime scheduledDate;

  void _updateCustomer(BuildContext context, Customer customer, Customers obj) {
    bool isValid = _form.currentState.validate();
    if (isValid) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text('Edit Customer confirmed ?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('confirm')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('cancel'))
              ],
            );
          }).then((value) async {
        if (value) {
          _form.currentState.save();
          customer.due = customer.total - customer.paid;
          if (scheduledDate != null)
            customer.schedulePay =
                DateFormat('dd-MM-yyyy').format(scheduledDate);
          setState(() {
            isLoading = true;
          });
          try {
            await obj.editCustomer(customer);
          } catch (e) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('something went wrong !!!'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('okay'))
                    ],
                  );
                });
          }
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  final _decoration = BoxDecoration(
      color: Colors.white70,
      border: Border.all(color: Colors.black45, width: 1),
      borderRadius: BorderRadius.circular(10));

  String _stringValidator(String value) {
    if (value.isEmpty)
      return 'empty field';
    else if (double.tryParse(value) != null)
      return 'numbers not allowed';
    else
      return null;
  }

  Container dateContainer(
      BuildContext context, Function function, String text, String id) {
    Customers obj = Provider.of<Customers>(context);
    Customer temp = obj.getCustomerById(id);
    return Container(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(onPressed: function, child: Text(text)),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 40,
                alignment: Alignment.centerLeft,
                child: (scheduledDate == null && temp.schedulePay == null)
                    ? Text('no date selected')
                    : (scheduledDate == null && temp.schedulePay != null)
                        ? Text(
                            temp.schedulePay,
                            style: TextStyle(color: Colors.black45),
                          )
                        : Text(
                            DateFormat('dd-MM-yyyy').format(scheduledDate),
                            textAlign: TextAlign.left,
                          ),
                decoration: _decoration),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (scheduledDate != null) scheduledDate = null;
                    if (temp.schedulePay != null) {
                      temp.schedulePay = null;
                    }
                  });
                },
                child: Text('clear date')),
          )
        ],
      ),
    );
  }

  Future<void> _pickDateforSchedule() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (date != null)
      setState(() {
        scheduledDate = date;
      });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    Customer customer = ModalRoute.of(context).settings.arguments;
    Customers obj = Provider.of<Customers>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                height: mediaQuery.height * .7,
                width: mediaQuery.width * .4,
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Container(width: 150, child: Text('Name : ')),
                            Expanded(
                              child: TextFormField(
                                initialValue: customer.name,
                                validator: (value) {
                                  return _stringValidator(value);
                                },
                                decoration: getInputDesign('name'),
                                onSaved: (value) {
                                  customer.name = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: 150, child: Text('Phone number : ')),
                            Expanded(
                              child: TextFormField(
                                initialValue: customer.mobile,
                                decoration: getInputDesign('Phone number'),
                                validator: (value) {
                                  if (int.tryParse(value) != null &&
                                      value.length == 11) {
                                    return null;
                                  }
                                  return 'Invalid number';
                                },
                                onSaved: (value) {
                                  customer.mobile = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: 150, child: Text('Address : ')),
                            Expanded(
                              child: TextFormField(
                                initialValue: customer.address,
                                decoration: getInputDesign('address'),
                                onSaved: (value) {
                                  customer.address = value;
                                },
                                validator: (value) {
                                  return _stringValidator(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: 150, child: Text('Total : ')),
                            Expanded(
                              child: TextFormField(
                                initialValue: customer.total.toStringAsFixed(2),
                                decoration: getInputDesign('total amount'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field is empty';
                                  } else if (double.tryParse(value) == null) {
                                    return 'only numbers are allowed';
                                  } else if (double.parse(value) < 0) {
                                    return 'negetive numbers not allowed';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  customer.total = double.parse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: 150, child: Text('Paid : ')),
                            Expanded(
                              child: TextFormField(
                                initialValue: customer.paid.toStringAsFixed(2),
                                decoration: getInputDesign('paid amount'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field is empty';
                                  } else if (double.tryParse(value) == null) {
                                    return 'only numbers are allowed';
                                  } else if (double.parse(value) < 0) {
                                    return 'negetive numbers not allowed';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  customer.paid = double.parse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        dateContainer(context, _pickDateforSchedule,
                            'scheduled date', customer.id),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  _updateCustomer(context, customer, obj);
                                },
                                child: Text('SUBMIT'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

Container customDesignedContainer(String text) {
  return Container(
    height: 40,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black45, width: 1)),
    child: Text(text),
  );
}
