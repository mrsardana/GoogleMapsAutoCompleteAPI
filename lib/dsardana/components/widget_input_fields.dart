import 'package:dsardana_test/dsardana/api/api_call.dart';
import 'package:dsardana_test/dsardana/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TextInputFieldsController {
  void Function()? methodA;
}

class InputFields extends StatefulWidget {
  final TextInputFieldsController controller;
  void Function(dynamic) callback;
  InputFields({required this.callback, super.key, required this.controller});

  @override
  _InputFieldsState createState() => _InputFieldsState(controller);
}

class _InputFieldsState extends State<InputFields> {
  _InputFieldsState(TextInputFieldsController controller) {
    controller.methodA = methodA;
  }

// called on save button pressed
  void methodA() {
    if (streetAddress.text.toString().trim().isNotEmpty) {
      Map<String, String> address = {
        "street": streetAddress.text.toString(),
        "unit": unit.text.toString(),
        "city": city.text.toString(),
        "province": province.toString(),
        "country": country.text.toString(),
        "postalCode": postalCode.text.toString(),
        "intersection": majorIntersection.text.toString(),
      };
      address.removeWhere(
          (key, value) => value.trim() == "" || value == "Province");
      Map<String, String> location = {
        "latitude": latitude.text.toString(),
        "longitude": longitude.text.toString(),
      };
      location.removeWhere((key, value) => value.trim() == "");
      Map<String, dynamic> data = {
        "address": address,
        "phone": storePhoneNumber.text.toString(),
        "location": location,
      };
      data.removeWhere((key, value) => value == "");
      if (data['location'].length == 0) {
        data.remove('location');
      }
      widget.callback(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atleast Street Address must be present')),
      );
    }
  }

  final TextEditingController streetAddress = TextEditingController();
  final TextEditingController unit = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController majorIntersection = TextEditingController();
  final TextEditingController latitude = TextEditingController();
  final TextEditingController longitude = TextEditingController();
  final TextEditingController storePhoneNumber = TextEditingController();

  late String province = "Province";
  late String timezone = 'Timezone';

  Map<String, dynamic>? response;
  late List<dynamic> queryResults;

  void searchAddress(String value) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": value,
      "key": GOOGLE_API_KEY,
    });
    response = await APICall.fetchUrl(uri);

    if (response != null) {
      // print(response['predictions']);
      queryResults = response!['predictions'];
    }
  }

  void fetchLatLong(String value) async {
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/geocode/json", {
      "place_id": value,
      "key": GOOGLE_API_KEY,
    });
    response = await APICall.fetchLatLong(uri);

    if (response != null) {
      // print(response!['results']['geometry']['location']);
      setState(() {
        postalCode.text = response!['results']['address_components']
                [response!['results']['address_components'].length - 1]
            ['long_name'];
        latitude.text =
            response!['results']['geometry']['location']['lat'].toString();
        longitude.text =
            response!['results']['geometry']['location']['lng'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                    width: 250,
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: streetAddress,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: "Street Address",
                        ),
                      ),
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion['description']),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        fetchLatLong(suggestion['place_id']);
                        Map<String, dynamic> selectedAddress =
                            suggestion['structured_formatting'];
                        setState(() {
                          streetAddress.text = selectedAddress['main_text'];
                          var checkPorvience = selectedAddress['secondary_text']
                                      .split(',')
                                      .length <
                                  2
                              ? selectedAddress['secondary_text'].split(',')[0]
                              : selectedAddress['secondary_text']
                                  .split(',')[1]
                                  .trim();
                          // selectedAddress['secondary_text']
                          //     .split(',')[1]
                          //     .trim();
                          if (checkPorvience == "AB" ||
                              checkPorvience == "BC" ||
                              checkPorvience == "MB" ||
                              checkPorvience == "NB" ||
                              checkPorvience == "NL" ||
                              checkPorvience == "NT" ||
                              checkPorvience == "NS" ||
                              checkPorvience == "NU" ||
                              checkPorvience == "ON" ||
                              checkPorvience == "PE" ||
                              checkPorvience == "QC" ||
                              checkPorvience == "SK" ||
                              checkPorvience == "YE") {
                            province = checkPorvience;
                          } else {
                            province = "Other";
                          }
                          city.text =
                              selectedAddress['secondary_text'].split(',')[0];
                          country.text = selectedAddress['secondary_text']
                                      .split(',')
                                      .length <
                                  3
                              ? selectedAddress['secondary_text']
                                          .split(',')
                                          .length <
                                      2
                                  ? selectedAddress['secondary_text']
                                      .split(',')[0]
                                  : selectedAddress['secondary_text']
                                      .split(',')[1]
                                      .trim()
                              // selectedAddress['secondary_text'].split(',')[1]
                              : selectedAddress['secondary_text']
                                  .split(',')[2]
                                  .trim();
                        });
                      },
                      suggestionsCallback: (value) {
                        if (value.length > 1 && value != "   ") {
                          searchAddress(value);
                          return queryResults;
                        } else {
                          queryResults = [];
                          return queryResults;
                        }
                      },
                    )
                    // TextField(
                    //   onChanged: (value) {
                    //     searchAddress(value);
                    //   },
                    //   controller: streetAddress,
                    //   decoration:
                    //       const InputDecoration(labelText: "Street Address"),
                    // ),
                    ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: unit,
                    decoration:
                        const InputDecoration(labelText: "Unit # (optional)"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: postalCode,
                    decoration: const InputDecoration(labelText: "Postal Code"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: city,
                    decoration: const InputDecoration(labelText: "City"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  height: 67,
                  child: DropdownButton<String>(
                    value: province,
                    isExpanded: true,
                    elevation: 16,
                    items: <String>[
                      'Province',
                      'AB',
                      'BC',
                      'MB',
                      'NB',
                      'NL',
                      'NT',
                      'NS',
                      'NU',
                      'ON',
                      'PE',
                      'QC',
                      'SK',
                      'YT',
                      'Other',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        province = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: country,
                    decoration: const InputDecoration(labelText: "Country"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 530,
                  child: TextField(
                    controller: majorIntersection,
                    decoration:
                        const InputDecoration(labelText: "Major Intersection"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  height: 67,
                  child: DropdownButton<String>(
                    value: timezone,
                    isExpanded: true,
                    elevation: 16,
                    items: <String>[
                      'Timezone',
                      'PT',
                      'MT',
                      'CT',
                      'ET',
                      'AT',
                      'NT',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        timezone = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: latitude,
                    decoration: const InputDecoration(labelText: "Latitude"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: longitude,
                    decoration: const InputDecoration(labelText: "Longitude"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: storePhoneNumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration:
                        const InputDecoration(labelText: "Store Phone Number"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
