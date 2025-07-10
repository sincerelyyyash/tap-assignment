import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/injection.dart';
import 'blocs/company_search/company_search_bloc.dart';
import 'pages/home_page.dart';

void main() {
  // Only configure dependencies if GetIt is not already configured
  if (!GetIt.instance.isRegistered<CompanySearchBloc>()) {
    configureDependencies();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Invest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: BlocProvider(
        create: (context) => getIt<CompanySearchBloc>(),
        child: const HomePage(),
      ),
    );
  }
}
