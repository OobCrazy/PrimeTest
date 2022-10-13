import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  TextEditingController textEditingController = TextEditingController();
  String result = 'Please input number.';
  bool isCalculating = false;

  onCalculatePrime() {
    if(isCalculating){
      return;
    }
    setState(() {
      isCalculating = true;
      result = 'Calculating...';
    });
    Future.delayed(const Duration(milliseconds: 500), (){
      try{
        double number = double.parse(textEditingController.text);
        isPrime(number).then((value){
          if(value){
            setState(() {
              isCalculating = false;
              result = 'The closest prime is ${getNumber(number)}';
            });
          } else {
            checkClosestPrime(number-1, number+1);
          }
        });
      }catch(e){
        setState(() {
          isCalculating = false;
          result = e.toString();
        });
      }
    });
  }

  checkClosestPrime(double lowerNumber, double upperNumber) async {
    bool isLowerPrime = await isPrime(lowerNumber);
    bool isUpperPrime = await isPrime(upperNumber);
    if(isLowerPrime && isUpperPrime){
      setState(() {
        isCalculating = false;
        result = 'The closest prime is ${getNumber(lowerNumber)} and ${getNumber(upperNumber)}';
      });
      return;
    }
    if(isLowerPrime){
      setState(() {
        isCalculating = false;
        result = 'The closest prime is ${getNumber(lowerNumber)}';
      });
      return;
    }
    if(isUpperPrime){
      setState(() {
        isCalculating = false;
        result = 'The closest prime is ${getNumber(upperNumber)}';
      });
      return;
    }
    checkClosestPrime(lowerNumber-1, upperNumber+1);
  }

  Future<bool> isPrime(double number) async {
    if(number == 2){
      return true;
    }
    if(number < 2){
      return false;
    }
    if(number%2==0){
      return false;
    }
    for(int i = 3; i <= number~/i; i += 2){
      if(number%i==0){
        return false;
      }
    }
    return true;
  }

  String getNumber(double number){
    try{
      return NumberFormat.currency(symbol: '', decimalDigits: 0).format(number);
    }catch(e){
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(result),
              TextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (text) => onCalculatePrime(),
              ),
              const SizedBox(height: 10),
              !isCalculating?MaterialButton(
                color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => onCalculatePrime(),
                  child: const Text('Calculate')
              ):const SizedBox(height: 0)
            ],
          ),
        ),
      )
    );
  }
}
