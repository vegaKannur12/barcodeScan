import 'dart:math';

import 'package:app_install_date/app_install_date_imp.dart';
import 'package:barcodescanner/barcode_dbhelper.dart';
import 'package:barcodescanner/screen/barcode_scanner.dart';
import 'package:barcodescanner/screen/displa_data.dart';
import 'package:barcodescanner/screen/registrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String expiry;
  DateTime now = DateTime.now();
  late DateTime tempDate;
  // late String version;
  late String buildNumber;
  late String installDate;
  var companyId;
  bool isExpired = false;
/////////// instalation date///////////////////
  getDate() async {
// Platform messages may fail, so we use a try/catch
    try {
      final DateTime date = await AppInstallDate().installDate;
      installDate = date.toString();
      print("install date---${installDate}");
    } catch (e) {
      installDate = 'Failed to load install date';
    }
  }

/////////////////// app version ////////////////
  // getVersion() async {
  //   //WidgetsFlutterBinding.ensureInitialized();
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String version = packageInfo.version;

  //   buildNumber = packageInfo.buildNumber;
  // }

  navigate() async {
    await Future.delayed(Duration(milliseconds: 3000), () async {
      var companyDetails = await BarcodeScanlogDB.instance.getCompanyDetails();
      print("osdodjsodks------${companyDetails}");


      if (companyDetails != null && companyDetails.isNotEmpty) {
        for ( var item in companyDetails){
         expiry= item["expiry_date"];
        }
        //expiry = companyDetails[0]["expiry_date"];
        tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(expiry);
        isExpired = tempDate.isBefore(now);

        print("expired---------${isExpired}");


      }

      // DateTime dayDate = DateTime.parse(expiry.split('-').reversed.join());
       //print("jfkdjfid${isExpired}");
      if (isExpired ==true) {
         print("jhdjdjdsj");
        SharedPreferences pref = await SharedPreferences.getInstance();
        companyId = pref.remove('companyId');
      }
     
      SharedPreferences pref = await SharedPreferences.getInstance();
      companyId = pref.getString('companyId');
      
      print(companyId);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  companyId == null ? RegistrationScreen(isExpired: isExpired) : BarcodeScanner()));
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    navigate();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 202, 24, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.35,
            ),
            Container(
              child: Image.asset("asset/Vega_logo.png"),
            ),
            Text(
              "Barcode Scanner",
              style:
                  TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
            FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Text(
                        'Version: ${snapshot.data!.version}',
                      );
                    default:
                      return const SizedBox();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
