import 'package:flutter/material.dart';
import 'dart:convert';
import './models/ApiModel.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(child: ListView_JSON()),
        ));
  }
}

class ListView_JSON extends StatefulWidget {
  ApiManager createState() => ApiManager();
}

class ApiManager extends State<ListView_JSON> {
  final String apiURL = 'https://gorest.co.in/public/v2/users';

  Future<List<ApiModel>> fetchJSON() async {
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

      List<ApiModel> tempList = jsonItems.map<ApiModel>((json) {
        return ApiModel.fromJson(json);
      }).toList();

      return tempList;
    } else {
      throw Exception('Failed To Load Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<ApiModel>>(
        future: fetchJSON(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            var items = data.data as List<ApiModel>;
            return ListView.builder(
                itemCount: items == null ? 0 : items.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                        title: Text(
                          items[index].name.toString(),
                        ),
                        onTap: () {
                          print(
                            items[index].name.toString(),
                          );
                        },
                        subtitle: Text(
                          items[index].email.toString(),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(items[index].name.toString()[0],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21.0,
                              )),
                        ),
                      ));
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}