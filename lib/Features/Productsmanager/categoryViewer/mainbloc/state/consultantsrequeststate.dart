import 'package:bossshopadmin/config/Models/Product.dart';

abstract class Productsrequeststate {}

class consultantsrequest_INITIAL extends Productsrequeststate {}

class consultantsrequest_IN_PROGRESS extends Productsrequeststate {}

class consultantsrequest_SUCCESS extends Productsrequeststate {
  List<Product> consultants;
  consultantsrequest_SUCCESS({required this.consultants});
}

class consultantsrequest_FAILED extends Productsrequeststate {
  Exception exception;
  consultantsrequest_FAILED({required this.exception});
}

class CategorySelectedState extends Productsrequeststate {
  final String selectedCategory;
  final List<Product> filteredList;

  CategorySelectedState(this.selectedCategory, this.filteredList);
}

class SearchState extends Productsrequeststate {
  final String text;
  final List<Product> searchedconsultants;

  SearchState(this.text, this.searchedconsultants);
}
