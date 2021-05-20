import 'package:intl/intl.dart';
import 'package:covid_tracker/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{

   final result;

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }

  HomeScreen({@required this.result});
}


class _HomeScreenState extends State<HomeScreen>{

  String _NewConfirmed,_TotalConfirmed,_NewDeaths,_TotalDeaths,_NewRecovered,_TotalRecovered;
  String _countryName;
  var searchResult;
  bool _showErrorInvalidCountryName = false;
  Networking networking = Networking();


  void DefaultUpdate(){
    setState(() {
      _NewConfirmed = doSomething(widget.result['Global']['NewConfirmed'].toString());
      _TotalConfirmed = doSomething(widget.result['Global']['TotalConfirmed'].toString());
      _NewDeaths = doSomething(widget.result['Global']['NewDeaths'].toString());
      _TotalDeaths = doSomething(widget.result['Global']['TotalDeaths'].toString());
      _NewRecovered = doSomething(widget.result['Global']['NewRecovered'].toString());
      _TotalRecovered = doSomething(widget.result['Global']['TotalRecovered'].toString());
    });
  }

  // This function is used to format the numbers :)
  String doSomething(String number){
    if(number.length>6 && number.length <10){
      if(number.length == 7){
        number ='${number.substring(0,number.length - 6)}.${number.substring(1,number.length - 4)}M';
        return number;
      }
      number ='${number.substring(0,number.length - 6)}M';
      return number;
    }
    else if(number.length > 5 && number.length <=6){
      number ='${number.substring(0,number.length - 3)}K';
      return number;
    }
    else
      {
        NumberFormat format = NumberFormat.decimalPattern();

        return format.format(num.parse(number));
      }
  }


  Future<void> getData(String countryName) async{
    searchResult = await networking.getDataBySearch(countryName);
    setState(() {
      if(searchResult.toString() == 'Country not found'){
        _showErrorInvalidCountryName = true;
        _NewConfirmed = 'ـــ';
        _TotalConfirmed = 'ـــ';
        _NewDeaths = 'ـــ';
        _TotalDeaths = 'ـــ';
        _NewRecovered = 'ـــ';
        _TotalRecovered = 'ـــ';
      }
      else
        {
          _showErrorInvalidCountryName = false;
          _NewConfirmed = doSomething(searchResult['todayCases'].toString());
          _TotalConfirmed = doSomething(searchResult['cases'].toString());
          _NewDeaths = doSomething(searchResult['todayDeaths'].toString());
          _TotalDeaths = doSomething(searchResult['deaths'].toString());
          _NewRecovered = 'ـــ';
          _TotalRecovered = doSomething(searchResult['recovered'].toString());
        }
    });
  }


  @override
  void initState() {
    super.initState();
    DefaultUpdate();
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF212121),
        elevation: 1.0,
        title: Text(
          'Covid-19 Tracker',
          style: TextStyle(
            fontSize: 30.0,
            color: Color(0xFFDEE1E6),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 70,
              ),
              TextField(
                controller: controller ,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 30.0,

                    ),
                    onPressed: (){
                      setState(() {
                        controller.text= '';
                        _showErrorInvalidCountryName = false;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Search',
                  hintText: 'Type a country name..',
                  errorText: _showErrorInvalidCountryName ? 'Enter a valid country name' : null,
                ),
                keyboardType: TextInputType.text,
                onSubmitted: getData,

              ),
              SizedBox(height: 30),
              MyCard(New: _NewConfirmed, Total: _TotalConfirmed,color:Colors.black,name :'cases'),
              SizedBox(height: 30),
              MyCard(New: _NewRecovered, Total: _TotalRecovered, color: Colors.green, name : 'recovered'),
              SizedBox(height: 30),
              MyCard(New: _NewDeaths, Total: _TotalDeaths, color: Colors.red[900], name : 'deaths'),
              Container(margin: EdgeInsets.all(30.0),child: FloatingActionButton(onPressed: DefaultUpdate, child: Image.asset('images/earth_planet.png'),)),

            ],
          ),
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    Key key,
    @required String New,
    @required String Total,
    @required Color color,
    @required String name
  }) : _new = New, _total = Total,color = color, name = name, super(key: key);

  final String _new;
  final String _total;
  final Color color;
  final String name;




  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFAFAFA),
      shadowColor: Colors.black,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:10.0,top: 10.0),
                child: Text(
                  'New $name:',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:12.0,),
                child: Text(
                  '$_new',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: color,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
          SizedBox(width: 35,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:10.0,top: 10.0),
                child: Text(
                  'Total $name:',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:12.0,),
                child: Text(
                  '$_total',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: color,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ],
      ),
    );
  }
}