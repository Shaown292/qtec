import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/product_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String searchQuery = "";
  String sortOption = "None";

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              onChanged: (val) {
                setState(() => searchQuery = val);
                context.read<ProductBloc>().add(SearchProducts(val));
              },
              decoration: InputDecoration(
                hintText: 'Search Anything...',
                contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
                prefixIcon: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/search.png"),
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                ),
              ),
            ),

            // Sort Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<String>(
                value: sortOption,
                isExpanded: true,
                items:
                    ["None", "Price: Low to High", "Rating: High to Low"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => sortOption = value);
                  if (value == "Price: Low to High") {
                    context.read<ProductBloc>().add(SortByPrice());
                  } else if (value == "Rating: High to Low") {
                    context.read<ProductBloc>().add(SortByRating());
                  } else {
                    context.read<ProductBloc>().add(FetchProducts());
                  }
                },
              ),
            ),

            // Product List
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text("No products found."));
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: Image.network(
                              product.thumbnail,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.title),
                            subtitle: Text(
                              "Price: \$${product.price}\nRating: ${product.rating}",
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
