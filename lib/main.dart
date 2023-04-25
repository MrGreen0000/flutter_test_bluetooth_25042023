import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BLE Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;

            if (state == BluetoothState.on) {
              return const BluetoothOnScreen(state: BluetoothState.on);
            }
            return const BluetoothOnScreen(state: BluetoothState.off);
          },
        ));
  }
}

class BluetoothOnScreen extends StatelessWidget {
  final BluetoothState state;

  const BluetoothOnScreen({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text('Find Devices'),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                onPressed: Platform.isAndroid
                    ? () async {
                        if (!await Permission.bluetoothConnect.isGranted) {
                          await Permission.bluetoothConnect.request();
                        }
                        FlutterBluePlus.instance.turnOff();
                      }
                    : null,
                child: const Text('TURN OFF'))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bluetooth_searching,
                size: 200.00,
                color: Colors.white54,
              ),
              const SizedBox(height: 12),
              Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
                style: Theme.of(context)
                    .primaryTextTheme
                    .labelSmall
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
        ));
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState state;
  const BluetoothOffScreen({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200,
              color: Colors.white54,
            ),
            const SizedBox(height: 12),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white),
                onPressed: Platform.isAndroid
                    ? () async {
                        if (!await Permission.bluetoothConnect.isGranted) {
                          await Permission.bluetoothConnect.request();
                        }
                        FlutterBluePlus.instance.turnOn();
                      }
                    : null,
                child: const Text('TURN ON'))
          ]),
        ));
  }
}
