
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qtec/repo/product_repository.dart';
import 'package:qtec/screen/product_list_screen.dart';

import 'home/product_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
    providers: [

      BlocProvider(create: (context) => ProductBloc(ProductRepository())),
    ],
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      //splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Bloc Practice',
          theme: ThemeData(),
          home: ProductListScreen(),
        );
      },
    );
  }
}