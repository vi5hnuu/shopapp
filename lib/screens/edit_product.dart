import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProductScreen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String? pId;
  var isInit=true;
  String? title;
  double? price;
  String? description;
  String? imageUrl;
  final _imageUrlController = TextEditingController();
  //Todo : make input controller for imageUrl and set Icon if url is invalid or show image in container
  //Todo : addListerner on focusNode of imageUlr when its not in focus we can try loanding image if any
  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(isInit){
      Object? data=ModalRoute.of(context)?.settings.arguments;
      if(data!=null)
        pId=data as String;
      Product? product=pId!=null ? Provider.of<Products>(context,listen: false).findById(id: pId!) : null;
      if(product!=null){
       title=product.title;
       price=product.price;
       description=product.description;
       imageUrl=product.imageUrl;
      }
      super.didChangeDependencies();
      isInit=false;
    }
  }

  void _saveForm() {
    final res = _form.currentState?.validate();
    if (res != null && res) {
      // print('saved');
      _form.currentState?.save();
    }
  }

  Future<bool> isImage(url) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
    } catch (err) {
      return false;
    }
    final type = ['image/png', 'image/jpg', 'image/jpeg'];
    if (response.statusCode == 200) {
      final content_type = response.headers['content-type'];
      print(content_type);
      if (type.contains(content_type)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // print('rebuild');
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit/Add products'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Consumer<Products>(
              builder: (BuildContext ctx,Products products,_){
                // print('Only icon rebuuild');
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Processing ...'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                    isImage(_imageUrlController.text).then((ans) {
                      print(ans);
                      if (ans){
                        _saveForm();
                        products.addProduct(Product(id: '', title: title!, description: description!, price: price!, imageUrl: imageUrl!),pId);
                        Navigator.of(context).pop();
                      }
                      else {
                        _imageUrlController.clear();
                        _saveForm();
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    // icon: Icon(Icons.title),
                    prefixIcon: Icon(Icons.title),
                    helperText: 'Enter product title ${title!=null ? '(Old Title :'+title!+')' : ''}',
                    hintText: 'e.g. T-shirt',
                    suffixText: '😊',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (String? val) {
                    title = val;
                  },
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'Please provide a valid title';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    // icon: Icon(Icons.title),
                    prefixIcon: Icon(Icons.payments_outlined),
                    helperText: 'Enter product price ${price!=null ? '(Old price :'+price.toString()+')' : ''}',
                    hintText: 'e.g. 500.0',
                    suffixText: '👌',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (val) {
                    price =double.tryParse(val!);
                  },
                  validator: (val) {
                    final regx = RegExp(r'[0-9]+.[0-9]+', multiLine: false);
                    if (val == null ||
                        double.tryParse(val) == null ||
                        !regx.hasMatch(val)) {
                      return 'Please provide valid price';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(25),
                    // isCollapsed: true,
                    helperText: 'Enter product description..',
                    hintText: 'e.g. long lasting.. ${description!=null ? ('\n\n'+description!):''}',
                    suffixText: '💤',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  focusNode: _descriptionFocusNode,
                  onSaved: (des) {
                    description =des;
                  },
                  validator: (des) {
                    if (des == null || des.trim().isEmpty)
                      return 'Please provide a valid title';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                            borderRadius: BorderRadius.circular(25)),
                        child: CircleAvatar(
                          child: Icon(
                            Icons.person_outline_rounded,
                          ),
                          backgroundColor: Colors.transparent,
                        )),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'ImageUrl',
                          // icon: Icon(Icons.title),
                          hintText: ' ${imageUrl!=null ? imageUrl!: 'e.g. www.gg...'})',
                          suffixText: '📷',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (url) {
                          final errorMsg = 'please provide a valid url';
                          if (url == null || url.isEmpty)
                            return errorMsg;
                          else
                            return null;
                        },
                        onSaved: (val){
                          imageUrl=val;
                        },
                        controller: _imageUrlController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
