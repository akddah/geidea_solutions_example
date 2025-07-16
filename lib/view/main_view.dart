import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geidea_solutions_example/main.dart';
import 'package:geideapay/geideapay.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _plugin = GeideapayPlugin();

  @override
  void initState() {
    super.initState();
    _plugin.initialize(
      publicKey: "", // form getway
      apiPassword: "", // form getway
      serverEnvironment: ServerEnvironmentModel.KSA_PROD(),
    );
  }

  Address billingAddress = Address(city: "Riyadh", countryCode: "SAU", street: "Street 1", postCode: "1000");
  Address shippingAddress = Address(city: "Riyadh", countryCode: "SAU", street: "Street 1", postCode: "1000");

  late CheckoutOptions checkoutOptions = CheckoutOptions(
    10.0,
    "SAR",
    callbackUrl: "https://website.hook/", //Optional
    returnUrl: "https://returnurl.com",
    lang: "AR", //Optional
    billingAddress: billingAddress, //Optional
    shippingAddress: shippingAddress, //Optional
    customerEmail: "email@noreply.test", //Optional
    merchantReferenceID: "1234", //Optional
    paymentIntentId: null, //Optional
    paymentOperation: "Pay", //Optional
    showAddress: true, //Optional
    showEmail: true, //Optional
    textColor: Colors.white, //Optional
    cardColor: Colors.deepOrange, //Optional
    payButtonColor: Colors.deepOrange, //Optional
    cancelButtonColor: Colors.grey, //Optional
    backgroundColor: Colors.black, //Optional
  );
  String? errMsg;
  checkout() async {
    try {
      OrderApiResponse response = await _plugin.checkout(
        context: context,
        checkoutOptions: checkoutOptions,
      );
      debugPrint('Response = $response');

      // Payment successful, order returned in response
      _updateStatus(response.detailedResponseMessage, response.toString());
    } catch (e) {
      debugPrint(" e.runtimeType ${e.runtimeType}");
      debugPrint("OrderApiResponse Error: $e");
      // An unexpected error due to improper SDK
      // integration or Plugin internal bug
      errMsg = e.toString();
      if (mounted) setState(() {});
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _updateStatus(
    String? detailedResponseMessage,
    String response,
  ) {
    log('message = $detailedResponseMessage');
    log('response = $response');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$errMsg',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: checkout,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
