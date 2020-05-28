import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  @override
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageURLupdated = FocusNode();
  final _formkey = GlobalKey<FormState>();

  var editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var isLoading = false;

  //focus node image url wali field pr isliye lagaya h jisse ki usme ho rahe changes ko listen karke hum state automatically change kr sken
//initstate bhi ussi k liye lagaya h
  @override
  void initState() {
    _imageURLupdated.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
//to extract id of product to be edited
  @override
  void didChangeDependencies() {
    String productId = ModalRoute.of(context).settings.arguments as String;

    if (productId != null) {
      editedProduct =
          Provider.of<Products>(context, listen: false).findById(productId);

      _initValues['title'] = editedProduct.title;
      _initValues['description'] = editedProduct.description;
      _initValues['price'] = editedProduct.price.toString();
      //_initValues['imageUrl'] =editingProduct.imageUrl;
      _imageController.text = editedProduct.imageUrl;
    }

    super.didChangeDependencies();
    _isInit = false;
  }

//yeh bhi ussi k liye lagaya h
  void _updateImageUrl() {
    if (!_imageURLupdated.hasFocus) {
      if (_imageController.text.isEmpty ||
          !_imageController.text.startsWith('https') &&
              !_imageController.text.startsWith('http') ||
          !_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpeg') &&
              !_imageController.text.endsWith('.jpg')) {
        ///yeh check h jisse ki image update na ho jab url invalid ho
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageURLupdated.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageController.dispose();
    _imageURLupdated.dispose();
    super.dispose();
  }

//key bana..mention kar usse form m...phir state s link kar key ko ..onsave hr field pr chla kr khel ja

  Future<void> _saveForm() async {
    bool isValid = _formkey.currentState.validate();
    if (isValid == false) {
      return;
    }
    _formkey.currentState.save();
     setState(() {
        isLoading = true;
      });

    if (editedProduct.id != null) {
     await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
      
     
       
    } else {
     
      //ab toh future bn gya ....lets use the then functionality

      try{

   await Provider.of<Products>(context, listen: false)
          .addProduct(editedProduct);

      }
      catch (error){
     await  showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error!'),
                content: Text('Something went wrong.Do you want to continue?'),
                actions: <Widget>[FlatButton(onPressed: (){
                  Navigator.of(ctx).pop();
                }, child: Text('OK'))],
              );
            });

      }
     
      //finally{
        
       // setState(() {
     //     isLoading = false;
      //  });

     //   Navigator.of(context).pop();
      

    //  }  
      
      
      
    }
     setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product Screen'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  _saveForm();
                })
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue[50],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formkey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return ('This field an not be empty');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                            title: value,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl,
                            isFavorite: editedProduct.isFavorite,
                            id: editedProduct.id,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return ('Do you want to sell this product for free?,enter a valid price');
                          }
                          if (double.tryParse(value) == null) {
                            return ('Enter a valid number');
                          }
                          if (double.parse(value) <= 0) {
                            return ('Do you want to sell this product for free?,enter a good price');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              isFavorite: editedProduct.isFavorite,
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              price: double.parse(value),
                              imageUrl: editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          focusNode: _descFocusNode,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value.isEmpty) {
                              return ('This field an not be empty,enter a nice description');
                            }
                            if (value.length < 10) {
                              return ('Enter some more lines');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            editedProduct = Product(
                                isFavorite: editedProduct.isFavorite,
                                id: editedProduct.id,
                                title: editedProduct.title,
                                description: value,
                                price: editedProduct.price,
                                imageUrl: editedProduct.imageUrl);
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageController.text.isEmpty
                                ? Text('Image')
                                : FittedBox(
                                    child: Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  )),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'ImageURL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              focusNode: _imageURLupdated,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return ('How will customers see you product?,This field can not be empty');
                                }
                                if (!value.startsWith('https') &&
                                    !value.startsWith('http')) {
                                  return ('This is invalid URL');
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.jpg')) {
                                  return ('No image associated with this URL');
                                }
                                return null;
                              },
                              onSaved: (value) {
                                editedProduct = Product(
                                    isFavorite: editedProduct.isFavorite,
                                    id: editedProduct.id,
                                    title: editedProduct.title,
                                    description: editedProduct.description,
                                    price: editedProduct.price,
                                    imageUrl: value);
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
