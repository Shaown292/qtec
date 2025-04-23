
part of 'product_bloc.dart';




@immutable
sealed class ProductEvent {}

class FetchProducts extends ProductEvent {

}

class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts(this.query);
}

class SortByPrice extends ProductEvent {}

class SortByRating extends ProductEvent {}