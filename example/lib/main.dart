import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_environments.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _livenessFlutterSdkPlugin = LivenessFlutterSdk();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  String _result = "N/A";

  Color primaryColor = const Color(0xFFFF4800);
  Color secondaryColor = const Color(0xFFFF4800);
  Color titleColor = const Color(0xFF283785);
  Color paragraphColor = const Color(0xFF353840);

  bool vocalGuidance = false;
  bool usePrd = false;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> callCSLivenessSDK(
      {String? accessToken,
      String? transactionId,
      bool? vocalGuidance = false,
      Color? primaryColor,
      Color? secondaryColor,
      Color? titleColor,
      Color? paragraphColor,
      LivenessEnvironments? environments}) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    String result;
    try {
      var sdkResponse = await _livenessFlutterSdkPlugin.openCSLiveness(
          accessToken: accessToken,
          transactionId: transactionId,
          vocalGuidance: vocalGuidance,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          titleColor: titleColor,
          paragraphColor: paragraphColor,
          environment: environments);

      result = jsonEncode(sdkResponse);
    } on PlatformException catch (e) {
      result = "Error: $e";
    } catch (e) {
      result = "Error: $e";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('CSLiveness'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (String? accessTokenValue) =>
                              _formValues["accessToken"] = accessTokenValue!,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter accessToken',
                              label: Text("AccessToken *")),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onSaved: (String? transactionIdValue) =>
                              _formValues["transactionId"] =
                                  transactionIdValue!,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter transactionId',
                              label: Text("TransactionId *")),
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text("Vocal Guidance"),
                          value: vocalGuidance,
                          onChanged: (bool? newValue) {
                            setState(() {
                              vocalGuidance = newValue == true;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text("Use PRD"),
                          value: usePrd,
                          onChanged: (bool? newValue) {
                            setState(() {
                              usePrd = newValue == true;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text("Primary Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              enableAlpha: false,
                                              pickerColor: primaryColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  primaryColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(primaryColor.toHexString(
                                        enableAlpha: false))),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Secondary Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              enableAlpha: false,
                                              pickerColor: secondaryColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  secondaryColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(secondaryColor.toHexString(
                                        enableAlpha: false))),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text("Title Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              enableAlpha: false,
                                              pickerColor: titleColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  titleColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(titleColor.toHexString(
                                        enableAlpha: false))),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Paragraph Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              enableAlpha: false,
                                              pickerColor: paragraphColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  paragraphColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(paragraphColor.toHexString(
                                        enableAlpha: false))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() == true) {
                                _formKey.currentState!.save();

                                await callCSLivenessSDK(
                                    accessToken: _formValues["accessToken"],
                                    transactionId: _formValues["transactionId"],
                                    vocalGuidance: vocalGuidance,
                                    primaryColor: primaryColor,
                                    secondaryColor: secondaryColor,
                                    titleColor: titleColor,
                                    paragraphColor: paragraphColor);
                              }
                            },
                            child: const Text('Open CSLiveness'))
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Result is: $_result"),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
