import 'dart:convert';

import 'package:http/http.dart' as http;
const String url = 'https://api.covid19api.com/summary';
class Networking{


  Future getData() async{

    http.Response response = await http.get(url);
    print(response.statusCode);
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      return result;
    }
    return null;
  }

  Future getDataBySearch(String countryName) async{
    http.Response response = await http.get('https://coronavirus-19-api.herokuapp.com/countries/$countryName');
    print(response.statusCode);

    print(response.statusCode);
    if(response.statusCode == 200){
      if(response.body.toString() == 'Country not found'){
        return response.body;
      }
      var result = jsonDecode(response.body);
      return result;
    }
    else
      return null;
}
}