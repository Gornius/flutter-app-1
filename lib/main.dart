import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Formularz';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key, this.imie, this.nazwisko, this.poziom})
      : super(key: key);
  final imie;
  final nazwisko;
  final poziom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detale"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ),
          Text("imie: $imie"),
          Text("nazwisko: $nazwisko"),
          Text("poziom: $poziom"),
        ],
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  double _currentSliderValue = 0;
  bool _isFormSaved = false;
  bool _isFormOK = false;
  bool _nameOK = false;
  bool _lastnameOK = false;
  bool _levelOK = false;
  String? _imie;
  String? _nazwisko;
  String? _poziom;

  void _checkForm(String s) {
    setState(() {
      _isFormOK = _formKey.currentState!.validate() ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _nameOK = false;
                    return 'Please enter some text';
                  }
                  _nameOK = true;
                  _imie = value;
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Imię'),
              ),
              onFocusChange: (hasFocus) {
                _checkForm('');
                if (!_nameOK && !hasFocus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bledne imie')),
                  );
                }
              },
            ),
            Focus(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _lastnameOK = false;
                    return 'Please enter some text';
                  }
                  _lastnameOK = true;
                  _nazwisko = value;
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Nazwisko'),
              ),
              onFocusChange: (hasFocus) {
                _checkForm('');
                if (!_lastnameOK && !hasFocus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bledne nazwisko')),
                  );
                }
              },
            ),
            Focus(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.parse(value) % 4 != 0) {
                    _levelOK = false;
                    return 'Please enter some text';
                  }
                  _levelOK = true;
                  _poziom = value;
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Poziom'),
              ),
              onFocusChange: (hasFocus) {
                _checkForm('');
                if (!_levelOK && !hasFocus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bledny poziom')),
                  );
                }
              },
            ),
            Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 25,
              label: _currentSliderValue.round().toString(),
              onChanged: _isFormSaved
                  ? (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    }
                  : null,
            ),
            Stack(
              children: [
                Image.asset('resources/cisu.png'),
                Text(_currentSliderValue.round().toString()),
              ],
              alignment: Alignment.bottomLeft,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _isFormOK
                    ? () {
                        setState(() {
                          _isFormSaved = _isFormSaved ? false : true;
                        });
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondRoute(
                                      imie: _imie,
                                      nazwisko: _nazwisko,
                                      poziom: _poziom)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Nieprawidlowe dane)')),
                          );
                        }
                      }
                    : null,
                child: const Text('Zapisz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
