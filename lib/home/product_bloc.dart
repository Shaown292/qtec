import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../model/product_model.dart';
import '../repo/product_repository.dart';

part 'product_state.dart';
part 'product_event.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  List<Product> _allProducts = [];

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>(_onFetch);
    on<SearchProducts>(_onSearch);
    on<SortByPrice>(_onSortPrice);
    on<SortByRating>(_onSortRating);
  }

  void _onFetch(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      _allProducts = await repository.fetchProducts();
      emit(ProductLoaded(_allProducts));
    } catch (e) {
      print("BLoC error: $e");
      emit(ProductError("Failed to load products"));
    }
  }

  void _onSearch(SearchProducts event, Emitter<ProductState> emit) {
    final filtered = _allProducts
        .where((product) =>
        product.title.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(ProductLoaded(filtered));
  }

  void _onSortPrice(SortByPrice event, Emitter<ProductState> emit) {
    final sorted = [..._allProducts]
      ..sort((a, b) => a.price.compareTo(b.price));
    emit(ProductLoaded(sorted));
  }

  void _onSortRating(SortByRating event, Emitter<ProductState> emit) {
    final sorted = [..._allProducts]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    emit(ProductLoaded(sorted));
  }
}