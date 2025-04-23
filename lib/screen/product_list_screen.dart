import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtec/const/app_text_style/app_text_style.dart';

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
                contentPadding: EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 16,
                ),
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
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 rows
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7, // width / height
                      ),
                      itemCount:  state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 164,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                    image: NetworkImage(product.thumbnail),
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                            Text(product.title, style: AppTextStyle.inter12w400Black,),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("\$${product.price}", style: AppTextStyle.inter14w600Black,),
                                SizedBox(width: 5,),
                                Text("\$${product.price}", style: AppTextStyle.inter10w500Grey,),
                                SizedBox(width: 5,),
                                Text("10% OFF", style: AppTextStyle.inter10w500Orange,),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // padding: EdgeInsets.all(2),
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Color(0xFFF59E0B)
                                  ),
                                  child: Center(child: Icon(Icons.star, size: 14, color: Colors.white,),),
                                ),
                                SizedBox(width: 4,),
                                Text("${product.rating}", style: AppTextStyle.inter12w500Black,),
                                SizedBox(width: 4,),
                                Text("(41)", style: AppTextStyle.inter12w400Grey,),
                              ],
                            ),
                          ],
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
          ],
        ),
      ),
    );
  }
}
