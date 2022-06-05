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
  final _formNameKey = GlobalKey<FormFieldState>();
  final _formLastNameKey = GlobalKey<FormFieldState>();
  final _formLevelKey = GlobalKey<FormFieldState>();
  final _formLevelSliderKey = GlobalKey<FormFieldState>();
  final _formLevelController = TextEditingController();

  bool _isFormSaved = false;
  String? _imie;
  String? _nazwisko;
  double _poziom = 0;

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
                key: _formNameKey,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bledne imie';
                  }
                  _imie = value;
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Imię'),
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus && !_formNameKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bledne imie')),
                  );
                }
              },
            ),
            Focus(
              child: TextFormField(
                key: _formLastNameKey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bledne nazwisko';
                  }
                  _nazwisko = value;
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Nazwisko'),
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus && !_formLastNameKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bledne nazwisko')),
                  );
                }
              },
            ),
            Focus(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                controller: _formLevelController,
                key: _formLevelKey,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.parse(value) % 4 != 0) {
                    return 'Bledny poziom';
                  }
                  _poziom = double.parse(value);
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Poziom'),
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus && !_formLevelKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bledny poziom')),
                  );
                }
              },
            ),
            Slider(
              key: _formLevelSliderKey,
              value: _poziom,
              max: 100,
              divisions: 25,
              label: _poziom.round().toString(),
              onChanged: _isFormSaved
                  ? (double value) {
                      setState(() {
                        _formLevelController.value = _formLevelController.value
                            .copyWith(text: value.round().toString());
                        _poziom = value;
                      });
                    }
                  : null,
            ),
            Stack(
              children: [
                Image.asset('resources/cisu.png'),
                Text(_poziom.round().toString()),
              ],
              alignment: Alignment.bottomLeft,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _formKey.currentState?.validate() ?? true
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
