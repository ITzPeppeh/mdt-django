import 'package:flutter/material.dart';
import 'package:mdt/models/constants.dart';
import 'package:mdt/models/sidebar.dart';
import 'package:mdt/models/database.dart';

class Charges extends StatefulWidget {
  const Charges({super.key});

  @override
  State<Charges> createState() => _ChargesState();
}

class _ChargesState extends State<Charges> {
  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _foundCharges = MyDB().getCharges();
    super.initState();
  }


  late Future<List<Charge>> _foundCharges;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        mySidebar(context, selectIdx: 3),
        Expanded(
            child: Container(
                margin: const EdgeInsets.all(5),
                color: colorBox,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _foundCharges,
                      builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          List data = snapshot.data!;
                          return SearchCharge(chargeName: data[index].chargeName);
                        },
                      );
                    } else if (snapshot.hasError) {
                      Text("ERROR: ${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  }
                  )
                  ],
                )))
      ]),
    );
  }
}

class SearchCharge extends StatefulWidget {
  final String chargeName;

  const SearchCharge({
    super.key,
    required this.chargeName,
  });

  @override
  State<SearchCharge> createState() => _SearchChargeState();
}

class _SearchChargeState extends State<SearchCharge> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: 80,
              color: sideBarColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Text(widget.chargeName,
                      style: const TextStyle(fontSize: 15)),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
