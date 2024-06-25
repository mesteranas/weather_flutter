import 'dart:convert';

import 'settings.dart';
import 'package:flutter/widgets.dart';

import 'language.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'viewText.dart';
import 'app.dart';
import 'contectUs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Language.runTranslation();
  runApp(test());
}
class test extends StatefulWidget{
  const test({Key?key}):super(key:key);
  @override
  State<test> createState()=>_test();
}
class _test extends State<test>{
  TextEditingController city=TextEditingController();
  var results=[];
  var _=Language.translate;
  _test();
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      locale: Locale(Language.languageCode),
      title: App.name,
      themeMode: ThemeMode.system,
      home:Builder(builder:(context) 
    =>Scaffold(
      appBar:AppBar(
        title: const Text(App.name),), 
        drawer: Drawer(
          child:ListView(children: [
          DrawerHeader(child: Text(_("navigation menu"))),
          ListTile(title:Text(_("settings")) ,onTap:() async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) =>SettingsDialog(this._) ));
            setState(() {
              
            });
          } ,),
          ListTile(title: Text(_("contect us")),onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ContectUsDialog(this._)));
          },),
          ListTile(title: Text(_("donate")),onTap: (){
            launch("https://www.paypal.me/AMohammed231");
          },),
  ListTile(title: Text(_("visite project on github")),onTap: (){
    launch("https://github.com/mesteranas/"+App.appName);
  },),
  ListTile(title: Text(_("license")),onTap: ()async{
    String result;
    try{
    http.Response r=await http.get(Uri.parse("https://raw.githubusercontent.com/mesteranas/" + App.appName + "/main/LICENSE"));
    if ((r.statusCode==200)) {
      result=r.body;
    }else{
      result=_("error");
    }
    }catch(error){
      result=_("error");
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewText(_("license"), result)));
  },),
  ListTile(title: Text(_("about")),onTap: (){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: Text(_("about")+" "+App.name),content:Center(child:Column(children: [
        ListTile(title: Text(_("version: ") + App.version.toString())),
        ListTile(title:Text(_("developer:")+" mesteranas")),
        ListTile(title:Text(_("description:") + App.description))
      ],) ,));
    });
  },)
        ],) ,),
        body:Container(alignment: Alignment.center
        ,child: Column(children: [
          TextFormField(controller: city,decoration: InputDecoration(labelText:_("city") ),),
          ElevatedButton(onPressed: () async{
              final Uri url = Uri.parse("http://api.openweathermap.org/data/2.5/weather?q=" + city.text + "&appid=" + App.apiKey);

  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      var temperatureCelsius = (data['main']['temp'] - 273.15).toStringAsFixed(0);
      var weatherConditions = data['weather'][0]['main'];
      var windSpeed = data['wind']['speed'].toString();
      var highTemperatureCelsius = (data['main']['temp_max'] - 273.15).toStringAsFixed(0);
      var lowTemperatureCelsius = (data['main']['temp_min'] - 273.15).toStringAsFixed(0);
      var humidity = data['main']['humidity'].toString();

      results = [
        "Temperature: $temperatureCelsius°C",
        "Weather: $weatherConditions",
        "Wind Speed: $windSpeed m/s",
        "High Temperature: $highTemperatureCelsius°C",
        "Low Temperature: $lowTemperatureCelsius°C",
        "Humidity: $humidity%"
      ];
      setState(() {
        
      });


    } else {
      results=['Failed to load weather data'];
    }
  } catch (e) {
    results=['Error: $e'];
  }
  setState(() {
    
  });
          }, child: Text(_("get result"))),
          for (var result in results)
          ListTile(title: Text(result),)
    ])),)));
  }
}
