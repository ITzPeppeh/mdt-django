import 'package:flutter/material.dart';
import 'package:mdt/models/constants.dart';
import 'package:mdt/models/database.dart';
import 'package:mdt/models/sidebar.dart';
import 'package:mdt/models/warrantbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    futureWarrants = MyDB().getWarrants();
    super.initState();
  }
  
  late Future<List<Civilian>> futureWarrants;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        mySidebar(context, selectIdx: 0),
        Expanded(
            // Warrant Box
            child: Container(
          width: 150,
          color: colorBox,
          margin: const EdgeInsets.only(top: 6, bottom: 6, left: 6),
          child: Column(children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Warrants',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
              ],
            ),
            FutureBuilder<List<Civilian>>(
              future: futureWarrants,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          List data = snapshot.data!;
                          return WarrantBox(
                              civID: data[index].id,
                              civName: data[index].fullName,
                              civImage: data[index].imageProfileURL);
                        },
                      );
                    } else if (snapshot.hasError) {
                      Text("ERROR: ${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
              },
            )
          ]),
        )),
        Expanded(
          // Notepad Box
          child: Container(
            width: 150,
            color: colorBox,
            margin: const EdgeInsets.all(6),
            child: const Column(children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bulletin Board',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration:
                      InputDecoration(filled: true, fillColor: sideBarColor),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                ),
              )
            ]),
          ),
        )
      ],
    ));
  }
}
