import 'package:flutter/material.dart';
import 'package:money_manager_flutter/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager_flutter/screens/category/category_add_popup.dart';
import 'package:money_manager_flutter/screens/category/screen_category.dart';
import 'package:money_manager_flutter/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager_flutter/screens/transactions/screen_transaction.dart';
class ScreenHome extends StatelessWidget{
   ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const[
     ScreenTransaction(),
     ScreenCategory(),
  ];
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor:Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'MONEY MANAGER'
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: 
      SafeArea(
        child: ValueListenableBuilder(
          builder: (BuildContext context,int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
          valueListenable: selectedIndexNotifier,

        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          if(selectedIndexNotifier.value == 0){
            print('Add Transactions');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);

          }else {
            print('Add catogory');
            showCategoryAddPopup(context);
            // final _sample = CategoryModel(
            //     id: DateTime.now().millisecondsSinceEpoch.toString(),
            //     name: 'Travel',
            //     type: CategoryType.expense,
            // );
            // CategoryDB().insetCategory(_sample);
          }
        },
        child: Icon(Icons.add),


      ),
    );
  }

}