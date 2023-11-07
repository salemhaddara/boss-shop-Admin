// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/Repository/repository.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/contentbloc.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/contentevent.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/contentstate.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/state/consultantsrequeststate.dart';
import 'package:bossshopadmin/config/Models/Product.dart';
import 'package:bossshopadmin/config/Widgets/OrderCheck.dart';
import 'package:bossshopadmin/config/Widgets/searchbar.dart';
import 'package:bossshopadmin/config/Widgets/text400normal.dart';
import 'package:bossshopadmin/config/Widgets/text600normal.dart';
import 'package:bossshopadmin/config/Widgets/text700normal.dart';
import 'package:bossshopadmin/core/localisation/translation.dart';
import 'package:bossshopadmin/core/theme/MyColors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class categoryViewer extends StatefulWidget {
  String category;
  String title;
  categoryViewer({super.key, required this.category, required this.title});

  @override
  State<categoryViewer> createState() => _categoryViewerState();
}

int HIGHEST_PRICE = 1;
int HIGHEST_RATE = 2;
int LOWEST_PRICE = 3;

class _categoryViewerState extends State<categoryViewer> {
  int selectedFilter = 0;
  List<Product>? filteredList;

  final String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: white,
      body: BlocProvider<contentbloc>(
        create: (context) {
          return contentbloc(context.read<Repository>())
            ..add(ProductsRequested())
            ..add(SelectCategoryEvent(widget.category));
        },
        child: Directionality(
          textDirection:
              defaultLang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: white,
                  expandedHeight: size.height * 0.08,
                  centerTitle: true,
                  leading: BlocBuilder<contentbloc, contentstate>(
                      builder: (context, state) {
                    return InkWell(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const ProductForm();
                          },
                        );
                        context.read<contentbloc>()
                          ..add(ProductsRequested())
                          ..add(SelectCategoryEvent(_selectedCategory));
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    );
                  }),
                  title: text700normal(
                    text: widget.title,
                    color: darkblack,
                    fontsize: 22,
                  ),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: SizedBox(),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHomeTopBar(size),
                  ),
                ),
              ];
            },
            body: Column(
              children: [_searchWidget(size), _consultantsList()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchWidget(Size size) {
    return BlocBuilder<contentbloc, contentstate>(
      builder: (context, state) {
        if (state.requeststate is SearchState) {
          filteredList =
              ((state.requeststate) as SearchState).searchedconsultants;
        }
        return Row(children: [
          Expanded(
            child: searchbar(
                hint: language[defaultLang]['searchbyconsultantname'],
                onChanged: (onChanged) {
                  context.read<contentbloc>().add(
                      SearchtextChangedEvent(onChanged, _selectedCategory));
                }),
          ),
          Container(
            height: 34,
            width: 34,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsetsDirectional.only(end: 20),
            child: GestureDetector(
              onTap: () async {
                await _showSorting(size);
                context.read<contentbloc>()
                  ..add(ProductsRequested())
                  ..add(SelectCategoryEvent(_selectedCategory));
              },
              child: SvgPicture.asset(
                'assets/images/iconfilter.svg',
              ),
            ),
          )
        ]);
      },
    );
  }

  Widget _consultantsList() {
    return BlocBuilder<contentbloc, contentstate>(builder: (context, state) {
      if (state.requeststate is consultantsrequest_SUCCESS) {
        context.read<contentbloc>().add(SelectCategoryEvent(_selectedCategory));
      }
      if (state.requeststate is CategorySelectedState) {
        filteredList = sortConsultants(
            ((state.requeststate) as CategorySelectedState).filteredList,
            selectedFilter);

        return _returnListView(filteredList!);
      }
      if (state.requeststate is SearchState) {
        filteredList = sortConsultants(
            ((state.requeststate) as SearchState).searchedconsultants,
            selectedFilter);
        return _returnListView(filteredList!);
      }
      return Container();
    });
  }

  Widget _buildHomeTopBar(Size size) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      width: size.width,
      height: size.height * 0.2,
      child: const ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }

  _showSorting(Size size) async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              defaultLang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(14),
                        topLeft: Radius.circular(14))),
                child: Row(children: [
                  Expanded(
                    child: text400normal(
                      text: language[defaultLang]['filterby'],
                      color: darkblack,
                      fontsize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectedFilter = 0;
                      Navigator.pop(context);
                    },
                    child: text600normal(
                      text: language[defaultLang]['clear'],
                      color: darkblack,
                      fontsize: 14,
                    ),
                  ),
                ]),
              ),
              ListTile(
                title: text400normal(
                  text: language[defaultLang]['highestrating'],
                  color: darkblack,
                  fontsize: 14,
                ),
                leading: Radio(
                  value: HIGHEST_RATE,
                  groupValue: selectedFilter,
                  activeColor: darkblack,
                  onChanged: (value) {
                    selectedFilter = HIGHEST_RATE;
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: text400normal(
                  text: language[defaultLang]['lowestprice'],
                  color: darkblack,
                  fontsize: 14,
                ),
                leading: Radio(
                  value: LOWEST_PRICE,
                  groupValue: selectedFilter,
                  activeColor: darkblack,
                  onChanged: (value) {
                    selectedFilter = LOWEST_PRICE;
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: text400normal(
                  text: language[defaultLang]['highestprice'],
                  color: darkblack,
                  fontsize: 14,
                ),
                leading: Radio(
                  value: HIGHEST_PRICE,
                  groupValue: selectedFilter,
                  activeColor: darkblack,
                  onChanged: (value) {
                    selectedFilter = HIGHEST_PRICE;
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _returnListView(List<Product> products) {
    return Expanded(
        child: ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(16),
                height: 100,
                child: OrderCheck(
                  product: products[index],
                  screenWidth: MediaQuery.of(context).size.width,
                  onDeleteClicked: (productId) {
                    context
                        .read<contentbloc>()
                        .add(deleteitem(products[index].productId));
                    context.read<contentbloc>()
                      ..add(ProductsRequested())
                      ..add(SelectCategoryEvent(_selectedCategory));
                  },
                ),
              );
            }));
  }

  List<Product> sortConsultants(
    List<Product> consultants,
    int filter,
  ) {
    switch (filter) {
      case 3:
        consultants.sort((a, b) => a.price.compareTo(b.price));
        break; // Add this break statement
      case 1:
        consultants.sort((a, b) => b.price.compareTo(a.price));
        break; // Add this break statement
    }
    return consultants;
  }
}

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePathController = TextEditingController();
  String _selectedCategory = 'homeaccessories';

  void addProductToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        imagePath: _imagePathController.text,
        productName: _productNameController.text,
        price: double.parse(_priceController.text),
        productId: '',
        description: _descriptionController.text,
        reviews: [],
        purshases: 0,
        Category: _selectedCategory,
      );

      final DocumentReference productRef = await FirebaseFirestore.instance
          .collection('products')
          .add(newProduct.toMap());

      await productRef.update({'productId': productRef.id});

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product Name is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: [
                DropdownMenuItem<String>(
                  value: 'carbikeaccessories',
                  child: Text(language[defaultLang]['carbikeaccessories']),
                ),
                DropdownMenuItem<String>(
                  value: 'beautyaccessories',
                  child: Text(language[defaultLang]['beautyaccessories']),
                ),
                DropdownMenuItem<String>(
                  value: 'clothingaccessories',
                  child: Text(language[defaultLang]['clothingaccessories']),
                ),
                DropdownMenuItem<String>(
                  value: 'clothing',
                  child: Text(language[defaultLang]['clothing']),
                ),
                DropdownMenuItem<String>(
                  value: 'homeaccessories',
                  child: Text(language[defaultLang]['homeaccessories']),
                ),
                DropdownMenuItem<String>(
                  value: 'electronics',
                  child: Text(language[defaultLang]['electronics']),
                ),
                DropdownMenuItem<String>(
                  value: 'phonecomputeraccessories',
                  child:
                      Text(language[defaultLang]['phonecomputeraccessories']),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value.toString();
                });
              },
            ),
            TextFormField(
              controller: _imagePathController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: addProductToFirestore,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
