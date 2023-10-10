import 'package:flutter/material.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transactions/transaction_db.dart';
import 'package:money_manager_flutter/modals/category/category_model.dart';
import 'package:money_manager_flutter/modals/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';

  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;
 final _purposeTextEditingController = TextEditingController();
 final _amountTextEditingController = TextEditingController();
  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  /*
  Purpose
  Date
  Amount
  Income/Expense
  CategoryType
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'purpose',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Amount',
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDateTemp.toString());
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate!.toString()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                          value: CategoryType.income,
                          groupValue: _selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategoryType = CategoryType.income;
                              _categoryID = null;
                            });
                          }),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategoryType = CategoryType.expense;
                              _categoryID = null;
                            });
                          }),
                      Text('Expense'),
                    ],
                  ),
                ],
              ),
              DropdownButton<String>(
                  hint: Text('Select Category'),
                  value: _categoryID,
                  items: (_selectedCategoryType == CategoryType.income
                          ? CategoryDB().incomeCategoryListListener
                          : CategoryDB().expenseCategoryListListener)
                      .value
                      .map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                      onTap: (){
                        _selectedCategoryModel = e;
                      },
                    );
                  }).toList(),
                  onChanged: (selectedValue) {
                    print(selectedValue);
                    setState(() {
                      _categoryID = selectedValue;
                    });
                  },
                onTap: (){

                },
                  ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    addTransaction();
                  },
                  child: Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> addTransaction() async{
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if(_purposeText.isEmpty){
      return;
    }
    if(_amountText.isEmpty){
      return;
    }
    if(_categoryID == null){
      return;
    }
    if( _selectedDate == null){
      return;
    }
   final _parsedAmount =  double.tryParse(_amountText);
    if(_parsedAmount == null){
      return;
    }
    // _selectedDate
    // _selectedCategoryType
    //_categoryID
   final _model =TransactionModel(
     purpose: _purposeText,
     amount: _parsedAmount ,
     date: _selectedDate!,
     type: _selectedCategoryType!,
     category:_selectedCategoryModel!,
   );
   await TransactionDB.instance.addTransaction(_model);
   Navigator.of(context).pop();
   TransactionDB.instance.refresh();
  }
}
