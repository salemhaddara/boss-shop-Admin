abstract class contentevent {}

class ProductsRequested extends contentevent {}

class SelectCategoryEvent extends contentevent {
  final String selectedCategory;

  SelectCategoryEvent(this.selectedCategory);
}

class SearchtextChangedEvent extends contentevent {
  final String? text;
  final String selectedCategory;

  SearchtextChangedEvent(this.text, this.selectedCategory);
}

class deleteitem extends contentevent {
  final String productid;
  deleteitem(this.productid);
}
