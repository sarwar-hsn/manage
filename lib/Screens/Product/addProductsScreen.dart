import 'package:flutter/material.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/Widgets/errorContainer.dart';
import 'package:provider/provider.dart';
import '../../provider/products.dart';

class AddProductsScreen extends StatefulWidget {
  static const routeName = '/addProductsScreen';

  @override
  _AddProductsScreenState createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final _form = GlobalKey<FormState>();
  Product temp = new Product();
  String dropDownValue;
  double errorContainerHeight = 0;
  String errorText = '';

  InputDecoration getInputDesign(String hintText) {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.white70,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black38));
  }

  void _saveform(Products obj, BuildContext context) {
    bool isValid = _form.currentState.validate();
    if (dropDownValue == null) {
      setState(() {
        errorContainerHeight = 20;
        errorText = 'no categories selected';
      });
    } else if (obj.categories.isEmpty) {
      setState(() {
        errorContainerHeight = 20;
        errorText = 'no categories found !!! try adding one';
      });
    } else {
      if (isValid) {
        _form.currentState.save();
        print(temp.name);
        print(temp.unitPrice);
        print(temp.unitName);
        print(temp.availableAmount);
        temp.category = dropDownValue;
        obj.addProduct(temp);

        setState(() {
          dropDownValue = null;
          errorContainerHeight = 0;
          errorText = '';
        });
        //Provider.of<Products>(context, listen: false).addProduct(temp);
        _form.currentState.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    List<String> categories = products.categories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.blueGrey.withOpacity(.2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey.withOpacity(.5)),
            alignment: Alignment.topCenter,
            height: 550,
            width: 500,
            child: Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      decoration: getInputDesign('name'),
                      onSaved: (value) {
                        temp.name = value;
                      },
                      validator: (value) {
                        if (double.tryParse(value) != null)
                          return 'Expects unit name';
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: getInputDesign('unit price'),
                      validator: (value) {
                        if (double.tryParse(value) == null)
                          return 'Expects amount in number';
                        if (double.parse(value) < 0)
                          return 'number can\'t be less than 0';
                        return null;
                      },
                      onSaved: (value) {
                        temp.unitPrice = double.parse(value);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.black45, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                          dropdownColor: Colors.white,
                          underline: Container(
                            height: 0,
                            width: 0,
                          ),
                          isExpanded: true,
                          value: dropDownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          hint: Text('Select Category'),
                          onChanged: (newValue) {
                            setState(() {
                              dropDownValue = newValue;
                            });
                          },
                          items: categories.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList()),
                    ),
                    (categories.isEmpty)
                        ? ErrorContainer(
                            errorContainerHeight: 20,
                            errorText:
                                'you have no category yet !!! Try adding some categories first',
                          )
                        : ErrorContainer(
                            errorContainerHeight: errorContainerHeight,
                            errorText: 'category is not selected'),
                    TextFormField(
                      decoration: getInputDesign('unit name'),
                      onSaved: (value) {
                        temp.unitName = value;
                      },
                      validator: (value) {
                        if (double.tryParse(value) != null)
                          return 'Expects name';
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: getInputDesign('available amount'),
                      validator: (value) {
                        if (double.tryParse(value) == null)
                          return 'Expects amount in number';
                        if (double.parse(value) < 0)
                          return 'number can\'t be less than 0';
                        return null;
                      },
                      onSaved: (value) {
                        temp.availableAmount = double.parse(value);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveform(products, context);
                      },
                      child: Container(
                        height: 40,
                        width: 200,
                        child: Center(
                          child: Text(
                            'SUBMIT',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}