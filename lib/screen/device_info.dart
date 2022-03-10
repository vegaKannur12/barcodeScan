import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceInfoUI extends StatefulWidget {
  const DeviceInfoUI({Key? key}) : super(key: key);

  @override
  State<DeviceInfoUI> createState() => _DeviceInfoUIState();
}

class _DeviceInfoUIState extends State<DeviceInfoUI> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () async {
 
            final deviceInfoPlugin = DeviceInfoPlugin();
            final deviceInfo = await deviceInfoPlugin.deviceInfo;
            
            final map = deviceInfo.toMap();
            print(map); 
            String id=map["androidId"] ;
            String model=map["model"] ;
            // String uniqId=id + model;

          },
          child: Text("get info")),
    ));
  }
}
