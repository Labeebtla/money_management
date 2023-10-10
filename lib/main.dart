import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_flutter/modals/category/category_model.dart';
import 'package:money_manager_flutter/modals/transaction/transaction_model.dart';
import 'package:money_manager_flutter/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager_flutter/screens/home/screen_home.dart';
Future<void> main() async{

 WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();

 if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)){
   Hive.registerAdapter(CategoryTypeAdapter());
 }

 if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
   Hive.registerAdapter(CategoryModelAdapter());
 }

 if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
   Hive.registerAdapter(TransactionModelAdapter());
 }
  runApp(const  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenHome(),
      routes:  {
        ScreenAddTransaction.routeName: (ctx) =>const ScreenAddTransaction(),
      },
    );
  }
}