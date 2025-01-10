import 'dart:collection';

import 'package:budgy/api/GoalService.dart';
import 'package:budgy/api/IncomeExpenseService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/CategoryService.dart';

class CustomDialog extends StatefulWidget {
  final VoidCallback onSave;
  const CustomDialog({Key? key,required this.onSave}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}


class _CustomDialogState extends State<CustomDialog> {
  String? selectedRadio = "Gelir";
  TextEditingController amountController = TextEditingController();
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  DateTimeRange? selectedDateRange;


  HashMap<String,String> gelirKategoriMap = new HashMap();
  HashMap<String,String> giderKategoriMap = new HashMap();

  void initState() {
    super.initState();
    fetchIncomeData();
    fetchExpenseData();
  }
  // Save function defined inside the dialog
  void handleSave() {
    // You can handle the saving logic here, such as validating fields or sending data to an API.
    String amount = amountController.text;
    String? category = "";
    int expType = 0;
    if(selectedRadio == "Gelir"){
      category = selectedCategory != null ? gelirKategoriMap[selectedCategory]: gelirKategoriMap.keys.first;
      expType = 0;
      IncomeExpenseService.addIncomeExpense(category!, int.parse(amount), expType, descriptionController.text, DateFormat("yyyy-MM-dd").format(selectedDate!))
          .then((bool res){
          widget.onSave();
      });
    }
    else{
      category = selectedCategory != null ? giderKategoriMap[selectedCategory]: giderKategoriMap.keys.first;
      expType = 1;
      if(selectedRadio == "Gider"){
        IncomeExpenseService.addIncomeExpense(category!, int.parse(amount), expType, descriptionController.text, DateFormat("yyyy-MM-dd").format(selectedDate!))
            .then((bool res){
          widget.onSave();
        });
      }
      else{
        GoalService.addGoal(category!, int.parse(amount), expType, descriptionController.text, DateFormat("yyyy-MM-dd").format(selectedDateRange!.start), DateFormat("yyyy-MM-dd").format(selectedDateRange!.end))
            .then((dynamic a){
          widget.onSave();
        }).onError((Error e, StackTrace st){
          widget.onSave();
        });
      }

    }
    String description = descriptionController.text;



    // Example of a simple print, replace it with your actual save logic
    print('Saving: $selectedRadio - $amount - $category - $description');

    // Add any other necessary saving operations here (e.g., storing in a database or API request)

    // After saving, close the dialog
    Navigator.pop(context);
  }

  Future<void> fetchIncomeData() async{
    final data = await CategoryService.getIncomeData();
    HashMap<String,String> catos = new HashMap();
    for(int i = 0; i<data.length;i++){
      Map<String,dynamic> hashData= data[i];
      catos[hashData["name"]] = hashData["id"];
    }
    setState(() {
      gelirKategoriMap = catos;
    });
  }

  Future<void> fetchExpenseData() async{
    final data = await CategoryService.getExpenseData();
    HashMap<String,String> catos = new HashMap();
    for(int i = 0; i<data.length;i++){
      Map<String,dynamic> hashData= data[i];
      catos[hashData["name"]] = hashData["id"];
    }
    setState(() {
      giderKategoriMap = catos;
    });
  }
  @override
  Widget build(BuildContext context) {

    List<String> gelirKatos = gelirKategoriMap.keys.toList();
    List<String> giderKatos = giderKategoriMap.keys.toList();


    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Yeni Kayıt"),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: Colors.black, thickness: 1),

            // Radio buttons (Gelir, Gider, Hedef)
            Row(
              children: [
                Radio<String>(
                  value: "Gelir",
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value;
                    });
                  },
                ),
                Text("Gelir"),
                Radio<String>(
                  value: "Gider",
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value;
                    });
                  },
                ),
                Text("Gider"),
                Radio<String>(
                  value: "Hedef",
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value;
                    });
                  },
                ),
                Text("Hedef"),
              ],
            ),

            // Amount TextField
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Miktar"),
                keyboardType: TextInputType.number,
              ),
            ),

            // Category Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButton<String>(
                hint: Text(
                  "Kategori Seçin",
                  style: TextStyle(color: Colors.black),
                ),
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                isExpanded: true,
                style: TextStyle(fontSize: 16, color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
                items: (selectedRadio == "Gider"||selectedRadio=="Hedef") ? giderKatos.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList() : gelirKatos.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
            value: value,
            child: Text(
            value,
            style: TextStyle(color: Colors.black),
            ),
            );
            }).toList(),
              ),
            ),

            // Date selection (single date or date range)
            if (selectedRadio == "Gelir" || selectedRadio == "Gider") ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? "Tarih Seçin"
                        : selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                  decoration: InputDecoration(
                    labelText: "Tarih",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedDateRange == null
                        ? "Tarih Aralığı Seçin"
                        : "${selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
                  ),
                  decoration: InputDecoration(
                    labelText: "Tarih Aralığı",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTimeRange? pickedRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: DateTimeRange(
                        start: DateTime.now(),
                        end: DateTime.now().add(Duration(days: 1)),
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedRange != null && pickedRange != selectedDateRange) {
                      setState(() {
                        selectedDateRange = pickedRange;
                      });
                    }
                  },
                ),
              ),
            ],

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Açıklama"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: handleSave,
                child: Text("Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
