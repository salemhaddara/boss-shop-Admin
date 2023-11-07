import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/state/consultantsrequeststate.dart';
import 'package:bossshopadmin/config/Models/Product.dart';

class contentstate {
  List<Product>? consultants = List.empty(growable: true);
  final Productsrequeststate? requeststate;
  contentstate({
    this.consultants,
    this.requeststate,
  });
  contentstate copyWith({
    List<Product>? consultants,
    Productsrequeststate? requeststate,
  }) {
    return contentstate(
      consultants: consultants ?? this.consultants,
      requeststate: requeststate ?? this.requeststate,
    );
  }
}
