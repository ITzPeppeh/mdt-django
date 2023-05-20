import 'dart:convert';
import 'package:http/http.dart' as http;

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
      isWarrant: json['isWarrant'] ? true : false
    );
  }
}

class MyDB {
  String baseUrl = "localhost:8000";

  /* Warrants */
  Future<List<Civilian>> getWarrants() async {
    final response = await http.get(Uri.http(baseUrl, 'api/crims/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Civilian> list = [];

      for (var entry in data) {
        var a = Arrested.fromJson(entry);

        final response = await http.get(Uri.http(baseUrl, 'api/civilians/${a.idCiv}'));

        if (response.statusCode == 200) {
          final data2 = jsonDecode(response.body);
          final t = Civilian.fromJson(data2);
          list.add(t);
        } else {
          throw Exception('HTTP Failed');
        }
      }


      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }

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

  Future<List<Arrested>> getReportsFromCivId(int id) async {
    final response = await http.get(Uri.http(baseUrl, 'api/crims/reps/$id'));

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

  Future<void> addOrUpdateArrested(Arrested newarr) async { //
    var i = newarr.idReport;
    var j = newarr.idCiv;
    final response = await http.get(Uri.http(baseUrl, 'api/crims/$i/$j'));

    if (response.statusCode == 200) {
      await http.put(Uri.http(baseUrl, 'api/crims/$i/$j'),
          body: newarr.toJson());
    } else if (response.statusCode == 404) {
      await http.put(Uri.http(baseUrl, 'api/crims/$i'), body: newarr.toJson());
    } else {
      throw Exception('HTTP Failed');
    }
  }

  Future<void> deleteArrested(Arrested todel) async {
    var i = todel.idReport;
    var j = todel.idCiv;
    await http.delete(Uri.http(baseUrl, 'api/crims/$i/$j'));
  }
}
