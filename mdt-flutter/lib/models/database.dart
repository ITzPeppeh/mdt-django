import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mdt/models/constants.dart';

import 'package:http/http.dart' as http;

class MyDatabase {
  static List<Civ> listUsers = [];
  static List<Report> listReports = [];
  static List<Arrested> listCrimReports = [];

  final _myDB = Hive.box(dbName);

  static List getWarrants() {
    List temps = [];
    for (var i = 0; i < listUsers.length; i++) {
      //print(listUsers[i].fullName);
      //print(listUsers[i].isWarant);
      if (listUsers[i].isWarant) {
        temps.add({
          'fullName': listUsers[i].fullName,
          'imageURL': listUsers[i].imageProfileURL,
          'id': listUsers[i].id
        });
      }
    }
    return temps;
  }

  static Civ getFromID(int ID) {
    Civ temp = listUsers.firstWhere((element) => element.id == ID);
    return temp;
  }

  void deleteUserFromId(int ID) {
    int a = listUsers.indexWhere((element) => element.id == ID);
    if (a != -1) {
      listUsers = List.from(listUsers)..removeAt(a);
    }
  }

  void deleteReportFromId(int ID) {
    int a = listReports.indexWhere((element) => element.repId == ID);
    if (a != -1) {
      listReports = List.from(listReports)..removeAt(a);
    }
  }

  void createOrUpdateUser(Civ newuser) {
    int ind = listUsers.indexWhere((element) => element.id == newuser.id);
    if (ind == -1) {
      listUsers.add(newuser); //Increment ID
    } else {
      listUsers[ind] = Civ(
          id: listUsers[ind].id,
          fullName: newuser.fullName,
          isWarant: listUsers[ind].isWarant,
          imageProfileURL: newuser.imageProfileURL,
          detailsProfile: newuser.detailsProfile);
    }
  }

  void createOrUpdateReport(Report newreport) {
    int ind =
        listReports.indexWhere((element) => element.repId == newreport.repId);
    if (ind == -1) {
      int newid = listReports.last.repId + 1;
      listReports.add(Report(
        repId: newid,
        reportName: newreport.reportName,
        dateCreated: newreport.dateCreated,
        detailsReport: newreport.detailsReport,
      )); //FIXME: RELATED UPDATE
    } else {
      listReports[ind] = Report(
        repId: listReports[ind].repId,
        reportName: newreport.reportName,
        detailsReport: newreport.detailsReport,
        dateCreated: listReports[ind].dateCreated,
      );
    }
  }

  void createInitialData() {
    listUsers = [
      Civ(
          detailsProfile: 'suca',
          id: 1,
          fullName: 'Mario Rossi',
          isWarant: false,
          imageProfileURL:
              'https://static.vecteezy.com/ti/vettori-gratis/p3/2158565-avatar-profilo-rosa-neon-icona-muro-mattoni-sfondo-rosa-neon-icona-vettore-vettoriale.jpg'),
      Civ(
          detailsProfile: 'ammazzati',
          id: 2,
          fullName: 'Fabio Neri',
          isWarant: true,
          imageProfileURL:
              'https://static.vecteezy.com/ti/vettori-gratis/p3/2158565-avatar-profilo-rosa-neon-icona-muro-mattoni-sfondo-rosa-neon-icona-vettore-vettoriale.jpg'),
      Civ(
          detailsProfile: 'jay',
          id: 3,
          fullName: 'Jessico Calcetto',
          isWarant: true,
          imageProfileURL: 'https://i.imgur.com/YTnxeEy.gif'),
      Civ(
          detailsProfile: 'ok',
          id: 4,
          fullName: 'Pino Dangelo',
          isWarant: false,
          imageProfileURL:
              'https://static.vecteezy.com/ti/vettori-gratis/p3/2158565-avatar-profilo-rosa-neon-icona-muro-mattoni-sfondo-rosa-neon-icona-vettore-vettoriale.jpg'),
    ];
    listReports = [
      Report(
        repId: 1000,
        reportName: 'A BOOST',
        dateCreated: DateTime.utc(1989, 11, 9),
        detailsReport: 'Suca',
      ),
      Report(
        repId: 1001,
        reportName: 'Karoline Flexx - Evading',
        dateCreated: DateTime.utc(2002, 6, 8),
        detailsReport: 'Ciuccia',
      ),
      Report(
        repId: 1002,
        reportName: 'Futo Boost - Grand Theft Auto',
        dateCreated: DateTime.utc(2015, 9, 5),
        detailsReport: 'Cazzi',
      ),
    ];
  }

  void loadData() {
    listUsers = _myDB.get(tableUsersName);
    listReports = _myDB.get(tableReportsName);
  }

  void updateDatabase() {
    _myDB.put(tableUsersName, listUsers);
    _myDB.put(tableReportsName, listReports);
  }

  static Report getReportFromID(int ID) {
    Report temp = listReports.firstWhere((element) => element.repId == ID);
    return temp;
  }
}

class Civ {
  final int id;
  final String fullName;
  bool isWarant;
  final String imageProfileURL;
  final String detailsProfile;

  Civ({
    required this.id,
    required this.fullName,
    required this.isWarant,
    required this.imageProfileURL,
    required this.detailsProfile,
  });
}

List<Charge> listCharges = [
  Charge(chargeName: 'Criminal Possession of a Firearm'),
  Charge(chargeName: 'Criminal Sale of an illegal weapon'),
  Charge(chargeName: 'Weapons Trafficking'),
  Charge(chargeName: 'Drug Trafficking'),
  Charge(chargeName: 'Human Trafficking'),
  Charge(chargeName: 'Serial Assaults and Killings'),
  Charge(chargeName: 'Murder of a Government Employee'),
  Charge(chargeName: 'Gang Related Shooting'),
  Charge(chargeName: 'Reckless Endangement'),
];

class Civilian {
  final int id;
  final String fullName;
  final String imageProfileURL;
  final String detailsProfile;

  Civilian({
    required this.id,
    required this.fullName,
    required this.imageProfileURL,
    required this.detailsProfile,
  });

  Map toJson() => {
        "civId": id.toString(),
        "fullName": fullName,
        "imageProfileURL": imageProfileURL,
        "detailsProfile": detailsProfile
      };

  factory Civilian.fromJson(Map<String, dynamic> json) {
    return Civilian(
        id: json['civId'],
        fullName: json['fullName'],
        imageProfileURL: json['imageProfileURL'],
        detailsProfile: json['detailsProfile']);
  }
}

class Charge {
  final String chargeName;
  const Charge({required this.chargeName});

  factory Charge.fromJson(Map<String, dynamic> json) {
    return Charge(chargeName: json['chargeName']);
  }
}

class Report {
  final int repId;
  final String reportName;
  final String detailsReport;
  final DateTime dateCreated;

  const Report(
      {required this.repId,
      required this.reportName,
      required this.dateCreated,
      required this.detailsReport});

  Map toJson() => {
        "repId": repId.toString(),
        "reportName": reportName,
        "detailsReport": detailsReport,
        "dateCreated":
            "${dateCreated.year}-${dateCreated.month}-${dateCreated.day}"
      };

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      repId: json['repId'],
      reportName: json['reportName'],
      detailsReport: json['detailsReport'],
      dateCreated: DateTime.parse(json['dateCreated']),
    );
  }
}

class Arrested {
  final int idReport;
  final int idCiv;
  final bool isWarrant;
  Arrested(
      {required this.idReport, required this.idCiv, required this.isWarrant});

  Map toJson() => {
    "repId": idReport.toString(),
    "civId": idCiv.toString(),
    "isWarrant": isWarrant ? "true" : "false",
  };

  factory Arrested.fromJson(Map<String, dynamic> json) {
    return Arrested(
      idReport: json['repId'],
      idCiv: json['civId'],
      isWarrant: json['isWarrant'] == "true" ? true : false
    );
  }
}

class MyDB {
  String baseUrl = "localhost:8000";

  /* Civilians */
  Future<List<Civilian>> getCivilians() async {
    final response = await http.get(Uri.http(baseUrl, 'api/civilians/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Civilian> list = [];

      for (var entry in data) {
        list.add(Civilian.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<Civilian> getCivilianFromID(int tempID) async {
    final response = await http.get(Uri.http(baseUrl, 'api/civilians/$tempID'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final t = Civilian.fromJson(data);
      return t;
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<void> addOrUpdateUser(Civilian newuser) async {
    var i = newuser.id;
    final response = await http.get(Uri.http(baseUrl, 'api/civilians/$i'));

    if (response.statusCode == 200) {
      await http.put(Uri.http(baseUrl, 'api/civilians/$i'),
          body: newuser.toJson());
    } else if (response.statusCode == 404) {
      await http.put(Uri.http(baseUrl, 'api/civilians/'),
          body: newuser.toJson());
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<void> deleteUserFromId(int id) async {
    await http.delete(Uri.http(baseUrl, 'api/civilians/$id'));
  }

  /* Charges */
  Future<List<Charge>> getCharges() async {
    final response = await http.get(Uri.http(baseUrl, 'api/charges/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Charge> list = [];

      for (var entry in data) {
        list.add(Charge.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }

  /* Reports */
  Future<List<Report>> getReports() async {
    final response = await http.get(Uri.http(baseUrl, 'api/reports/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Report> list = [];

      for (var entry in data) {
        list.add(Report.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<Report> getReportFromID(int tempID) async {
    final response = await http.get(Uri.http(baseUrl, 'api/reports/$tempID'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final t = Report.fromJson(data);
      return t;
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<void> addOrUpdateReport(Report newuser) async {
    var i = newuser.repId;
    final response = await http.get(Uri.http(baseUrl, 'api/reports/$i'));

    if (response.statusCode == 200) {
      await http.put(Uri.http(baseUrl, 'api/reports/$i'),
          body: newuser.toJson());
    } else if (response.statusCode == 404) {
      await http.put(Uri.http(baseUrl, 'api/reports/'), body: newuser.toJson());
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<void> deleteReportFromId(int id) async {
    await http.delete(Uri.http(baseUrl, 'api/reports/$id'));
  }

  /* Arrested */
  Future<List<Arrested>> getCrimsFromRepId(int id) async {
    final response = await http.get(Uri.http(baseUrl, 'api/crims/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Arrested> list = [];

      for (var entry in data) {
        list.add(Arrested.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }
}
