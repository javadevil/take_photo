import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Photo',
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
      home: PhotoPage(),
    );
  }
}

class PhotoPage extends StatefulWidget {
  PhotoPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  Future<List<dynamic>> futurePhotos;

  Future<List<dynamic>> fetchPhoto() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1/photos'));
    if (response.statusCode ==  200){
      print(response);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load photo');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhoto();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).padding,
        child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: (){},
                        child: Text('Take Photo')
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<dynamic>>(
                future: futurePhotos,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                  key: Key(index.toString()),
                                  child: ListTile(
                                    title: Image.network(snapshot.data[index]['url'])
                                  ),
                                  onDismissed: (direction) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Delete item at $index')
                                        )
                                    );
                                  },
                              );
                            }
                        )
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              )
            ]
        ),
      )
    );
  }
}
