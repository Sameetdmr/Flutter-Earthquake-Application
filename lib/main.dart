import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://api.orhanaydogdu.com.tr/deprem/live.php";
  List data;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        //Encode the url
        Uri.encodeFull(url),
        //Only accept json response
        headers: {"Accept": "application/json"});

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson['result'];
    });

    return "Success";
  }

  Completer<GoogleMapController> _controller = Completer();


  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Deprem'),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  '${data[index]['lokasyon']}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  '${data[index]['mag']}',
                  style:
                      TextStyle(color: Colors.teal, fontSize: 20.0,fontStyle: FontStyle.italic),
                ),
                leading: Icon(Icons.show_chart),
                contentPadding: EdgeInsets.all(20.0),
                onTap: () {
                  var deger = data[index]['lng'];
                  var deger2 = data[index]['lat'];
                  //LatLng cord=LatLng(data[index]['coordinates'][0],data[index]['coordinates'][1]);
                  //print(deger.runtimeType);

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Stack(
                          children: <Widget>[
                            _googlemap(context, deger2, deger),
                            //_zoomminusfunction(),
                            //_zoomplusfunction(),
                            //_buildContainer(),
                          ],
                        );
                      });
                },
              );
            }),
      ),
    );
  }

  Widget _googlemap(BuildContext context, koordinat1, koordinat2) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(koordinat1, koordinat2), zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          //_controller.complete(controller);
        },
        
      ),
    );
  }
}
