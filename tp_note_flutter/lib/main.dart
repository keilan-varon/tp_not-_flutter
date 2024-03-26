import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}



class Stage {
  final String nom;
  final String ville;
  final String pays;
  final String cpent;
  final String adresse;

  Stage({required this.nom, required this.ville, required this.pays, required this.cpent, required this.adresse});

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      nom: json['noment1'],
      ville: json['ville'],
      pays: json['pays'],
      cpent: json['cpent'],
      adresse: json['adr1'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter stages MC',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StageApp(),
    );
  }
}

class StageApp extends StatefulWidget {
  @override
  _StageAppState createState() => _StageAppState();
}

class _StageAppState extends State<StageApp> {
  final _motclef1Controller = TextEditingController();
  final _motclef2Controller = TextEditingController();
  final _motclef3Controller = TextEditingController();
  List<Stage> stages = [];

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _motclef1Controller.dispose();
    _motclef2Controller.dispose();
    _motclef3Controller.dispose();
    super.dispose();
  }

   void _videChamps() {
    setState(() {
      _motclef1Controller.text = "";
      _motclef2Controller.text = "";
      _motclef3Controller.text = "";  
    });
  }

  

  Future<void> fetchStages(String _motclef1Controller,String _motclef2Controller,String _motclef3Controller) async {
    final response = await http.get(Uri.parse('https://dptinfo.iutmetz.univ-lorraine.fr/applis/flutter_api_s3/api/getByKeywords.php?mc1=$_motclef1Controller&mc2=$_motclef2Controller&mc3=$_motclef3Controller'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        stages = data.map((stage) => Stage.fromJson(stage)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter stages MC'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 9,
                          child: TextField(
                            controller: _motclef1Controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mot-clé 1'),
                          ),
                        ),
                        Flexible(
                          flex: 9,
                          child: TextField(
                            controller: _motclef2Controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mot-clé 2'),
                          ),
                        ),
                        Flexible(
                          flex: 9,
                          child: TextField(
                            controller: _motclef3Controller,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mot-clé 3'),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.lightGreen.shade50)))
                          ),
                              onPressed: _videChamps,   child: const Text("Actualiser")),

                      ],
                      
                    ),
                  ],
                  ),
                ),
              ],
            ),
          ),
Expanded(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Nombre de résultats :',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(width: 10), // Espace entre le texte et le compteur
      Text(
        '${stages.length}',
        style: TextStyle(fontSize: 16),
      ),
    ],
  ),
),

          Expanded(
            child: GridView.builder(
              itemCount: stages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2, // Adjust crossAxisCount based on screen width
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                color: Colors.green;
                return Card(
                  child: Center(
                    
                    child: Text(stages[index].nom),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
