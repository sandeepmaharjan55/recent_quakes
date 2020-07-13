import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJSON();
  List _features = _data['features'];
  // print(_features[0]['properties']['time']);

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: AppBar(
        title: Text("Quakes"),
        backgroundColor: Colors.orangeAccent,
      ),
      // listView builder
      body: ListView.builder(
        itemCount: _features.length,
        padding: const EdgeInsets.all(3.0),
        itemBuilder: (BuildContext context, int position) {
          return Column(children: <Widget>[
            Divider(
              height: 3.4,
            ),
            ListTile(
              title: Text(
                _getDate(_features[position]['properties']['time']),
                style: TextStyle(
                    fontSize: 17.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent),
              ),

              // contentPadding: const EdgeInsets.all(30.0),
              subtitle: Text(
                "${_features[position]['properties']['place']}",
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  "${_features[position]['properties']['mag']}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () => showTapMessage(
                  context, _features[position]['properties']['title']),
            ),
          ]);
        },
      ),
    ),
  ));
}

void showTapMessage(BuildContext context, String titlemessage) {
  var alertDialog = new AlertDialog(
    title: Text("Quakes"),
    content: Text(titlemessage),
    actions: [
      FlatButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("OK"),
      )
    ],
  );
  showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      });
}

String _getDate(featur) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(featur);
  var format = new DateFormat("MMMM dd, yyyy hh:mm aaa");
  var dateString = format.format(date);
  // print(date);
  return dateString;
}

Future<Map> getJSON() async {
  String apiURL =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiURL);
  // print(json.decode(response.body));
  return json.decode(response.body);
}
