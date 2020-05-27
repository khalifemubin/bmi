import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  String _bmiResult = "", _bmiVerdict = "";
  final TextEditingController _ageValue = new TextEditingController();
  final TextEditingController _heightValue = new TextEditingController();
  final TextEditingController _weightValue = new TextEditingController();

  bool _validateAge = false;
  bool _validateHeight = false;
  bool _validateWeight = false;

  void _showBMIResult() {
    setState(() {
      bool bProceed = true;

      _validateAge = false;
      _validateHeight = false;
      _validateWeight = false;

      if (_ageValue.text.toString().isEmpty) {
        _validateAge = true;
        bProceed = false;
      } else if (_heightValue.text.toString().isEmpty) {
        _validateHeight = true;
        bProceed = false;
      } else if (_weightValue.text.toString().isEmpty) {
        _validateWeight = true;
        bProceed = false;
      }

      if (bProceed) {
        // print("Sending ${_heightValue.text}, ${_weightValue.text}");
        double _bmiValue = calculateBMI(_heightValue.text, _weightValue.text);

        if (_bmiValue > 0) {
          _bmiResult = "Your BMI: ${_bmiValue.toStringAsFixed(1)}";

          if (_bmiValue < 18.5) {
            _bmiVerdict = "Underweight";
          } else if (_bmiValue >= 18.5 && _bmiValue <= 25) {
            _bmiVerdict = "Normal";
          } else if (_bmiValue > 25) {
            _bmiVerdict = "Overweight";
          }
        } else {
          _bmiResult = "";
          _bmiVerdict = "";
        }

        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });
  }

  double calculateBMI(String height, String weight) {
    if (double.parse(height).toString().isNotEmpty &&
        double.parse(height) > 0 &&
        double.parse(weight).toString().isNotEmpty &&
        double.parse(weight) > 0) {
      // print("Received $height, $weight");
      double denominator = pow(double.parse(height) / 100, 2);
      // print("denominator  $denominator");
      double division = double.parse(weight) / denominator;
      // print("Division  $division");
      return division;
      // return 703 * division;
    } else {
      print("Invalid values");
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("BMI"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.white,
      body: new Container(
        alignment: Alignment.topCenter,
        child: new ListView(
          padding: const EdgeInsets.all(2.5),
          children: <Widget>[
            new Image.asset(
              "images/bmilogo.png",
              height: 120.0,
              width: 200.0,
            ),
            new Container(
              margin: const EdgeInsets.all(3.0),
              alignment: Alignment.center,
              color: Colors.grey.shade300,
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: _ageValue,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Your Age",
                      icon: new Icon(Icons.person_outline),
                      errorText: _validateAge ? 'Enter correct value' : null,
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(1.0)),
                  new TextField(
                    controller: _heightValue,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Your Height",
                      hintText: "In centimeters",
                      icon: new Icon(Icons.insert_chart),
                      errorText: _validateHeight ? 'Enter correct value' : null,
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.all(1.0)),
                  new TextField(
                    controller: _weightValue,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Your Weight",
                      hintText: "In kilogram",
                      icon: new Icon(Icons.line_weight),
                      errorText: _validateWeight ? 'Enter correct value' : null,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(5.0),
                  ),
                  new RaisedButton(
                    onPressed: _showBMIResult,
                    // onPressed: () => print("CLicked"),
                    child: new Text("Calculate"),
                    color: Colors.pinkAccent,
                    textColor: Colors.white70,
                  )
                ],
              ),
            ),
            new Padding(padding: const EdgeInsets.all(5.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  _bmiResult,
                  style: new TextStyle(
                    color: Colors.blue,
                    fontSize: 19.9,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            new Padding(padding: const EdgeInsets.all(2.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  _bmiVerdict,
                  style: new TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 19.9,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
