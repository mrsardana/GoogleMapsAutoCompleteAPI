import 'dart:io';
import 'dart:convert';
import 'package:dsardana_test/dsardana/components/widget_col_expand.dart';
import 'package:dsardana_test/dsardana/components/widget_input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class SaveIntent extends Intent {}

class AddressTest extends StatefulWidget {
  const AddressTest({super.key});

  @override
  State<AddressTest> createState() => _AddressTestState();
}

class _AddressTestState extends State<AddressTest> {
  final TextInputFieldsController myController = TextInputFieldsController();
  late File jsonFile;
  late Directory dir;
  int counter = 0;
  @override
  void initState() {
    super.initState();
    // Getting current document directory
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      print("File Path");
      print(dir);
    });
  }

  File createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating File!");
    File file = File("${dir.path}/$fileName");
    file.createSync();
    file.writeAsStringSync(jsonEncode(content));
    return file;
  }

  void saveButtonPressed() {
    if (myController.methodA != null) {
      myController.methodA!();
    }
  }

  void onData(dynamic data) {
    counter++;
    String datetime =
        DateFormat("yyyyMMdd-kkmmss").format(DateTime.now()).toString();
    String fileName = "$datetime.$counter-Address.json";
    // print(data);
    createFile(data, dir, fileName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CollapseExpand(
              title: "STORE LOCATION",
              child: InputFields(
                controller: myController,
                callback: onData,
              ),
            ),
            Shortcuts(
              shortcuts: {
                LogicalKeySet(
                        LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                    SaveIntent(),
              },
              child: Actions(
                actions: {
                  SaveIntent: CallbackAction<SaveIntent>(
                      onInvoke: (intent) => saveButtonPressed())
                },
                child: FocusScope(
                  autofocus: true,
                  child: ElevatedButton(
                    onPressed: saveButtonPressed,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
