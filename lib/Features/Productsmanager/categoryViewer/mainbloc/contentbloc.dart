import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/Repository/repository.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/contentevent.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/contentstate.dart';
import 'package:bossshopadmin/config/Models/Product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state/consultantsrequeststate.dart';

class contentbloc extends Bloc<contentevent, contentstate> {
  final Repository repo;
  contentbloc(this.repo) : super(contentstate()) {
    //GET CONSULTANTS DATA
    on<ProductsRequested>(
      (event, emit) async {
        try {
          //fetch data here
          emit(state.copyWith(requeststate: consultantsrequest_IN_PROGRESS()));
          List<Product> consultants = await repo.fetchProducts();
          emit(state.copyWith(
              consultants: consultants,
              requeststate:
                  consultantsrequest_SUCCESS(consultants: consultants)));
        } catch (e) {
          emit(state.copyWith(
              requeststate:
                  consultantsrequest_FAILED(exception: e as Exception)));
        }
      },
    );

    on<SelectCategoryEvent>((event, emit) {
      List<Product> list = state.consultants ?? List.empty(growable: true);
      final filteredList = list.where((item) {
        return item.Category == event.selectedCategory;
      }).toList();
      if (event.selectedCategory == 'all') {
        filteredList.clear();
        filteredList.addAll(list);
      }

      emit(state.copyWith(
          requeststate:
              CategorySelectedState(event.selectedCategory, filteredList)));
    });
    on<SearchtextChangedEvent>((event, emit) {
      List<Product> list = state.consultants ?? List.empty(growable: true);
      List<Product> filteredList = list.where((item) {
        return item.Category == event.selectedCategory;
      }).toList();
      if (event.selectedCategory == 'all') {
        filteredList.clear();
        filteredList.addAll(list);
      }
      if (event.text != null && event.text!.isNotEmpty) {
        filteredList = filteredList.where((element) {
          return (element.productName.toLowerCase()).contains((event.text!));
        }).toList();
      }
      emit(state.copyWith(
          requeststate: SearchState(event.selectedCategory, filteredList)));
    });
    on<deleteitem>(
      (event, emit) {
        List<Product> list = state.consultants ?? List.empty(growable: true);
        list.removeWhere((element) => element.productId == event.productid);
        repo.deleteDocument(event.productid);
        emit(state.copyWith(consultants: list));
      },
    );
  }
}
