import 'package:barcodescanner/controller/registration_controller.dart';
import 'package:barcodescanner/model/registration_model.dart';
import 'package:barcodescanner/screen/barcode_scanner.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  bool isExpired;
  RegistrationScreen({required this.isExpired});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = new GlobalKey<FormState>();
  RegistrationController registrationController = RegistrationController();
  TextEditingController codeController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String uniqId;

  getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();

    //String id = map["androidId"];
    String model = map["model"];
    String id=map["id"];
    String manufacturer=map["manufacturer"];
    uniqId = id + model + manufacturer;
    //print(uniqId);
  }

  //////////////////snackbar///////////////////
  _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 143, 17, 8),
        duration: const Duration(seconds: 1),
        content: Text('Expired!!!!'),
        action: SnackBarAction(
          label: 'Dissmiss',
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
  // }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   if (widget.isExpired) {
  //     Future<Null>.delayed(Duration.zero, () {
  //       _showSnackbar();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpired) {
      Future<Null>.delayed(Duration.zero, () {
        _showSnackbar(context);
      });
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.business),
                      // hintText: 'What do people call you?',
                      labelText: 'Company Code',
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Company code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    height: size.height * 0.05,
                    width: size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Navigator.of(context).pop();
                        if (_formKey.currentState!.validate()) {
                          print(uniqId);
                          RegistrationModel? result =
                              await registrationController.postRegistration(
                                  codeController.text, uniqId, "1");
                          if (result != null) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('companyId', result.companyId!);
                          }
                          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.of(context).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BarcodeScanner(
                                    // companyName: result!.companyName.toString(),
                                    )),
                          );
                        }
                      },
                      child:
                          Text(widget.isExpired ? "Re-Register" : "Register"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
