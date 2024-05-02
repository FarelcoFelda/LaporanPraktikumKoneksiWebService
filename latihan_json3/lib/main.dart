import 'package:flutter/material.dart'; // Import package flutter material untuk mengembangkan UI.
import 'package:http/http.dart' as http; // Import package http untuk melakukan HTTP requests.
import 'dart:convert'; // Import package convert untuk mengonversi data.

class University {
  String name;
  String website;

  University({required this.name, required this.website}); // Constructor.

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0], // Ambil situs web pertama dari array.
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<List<University>>
      futureUniversities; // Future untuk menampung daftar universitas.

  String url =
      "http://universities.hipolabs.com/search?country=Indonesia"; // URL endpoint API.

  // Method untuk mengambil data dari API.
  Future<List<University>> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Melakukan HTTP GET request.

    if (response.statusCode == 200) {
      // Jika server mengembalikan 200 OK (berhasil),
      // parse json dan buat list dari universitas.
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = [];

      for (var item in data) {
        universities.add(University.fromJson(item));
      }

      return universities;
    } else {
      // Jika gagal (bukan 200 OK),
      // lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchData(); // Memanggil method fetchData saat initState dipanggil.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Universitas di Indonesia'),
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika ada data,
                // tampilkan ListView dengan daftar universitas.
                return Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Lebar Container 80% dari lebar layar.
                  padding: EdgeInsets.all(8.0), // Padding untuk ListView.
                  decoration: BoxDecoration(
                    // Dekorasi untuk ListView.
                    border: Border.all(), // Border untuk ListView.
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          // Dekorasi untuk item dalam ListView.
                          border: Border(
                              bottom:
                                  BorderSide()), // Border bawah untuk setiap item.
                        ),
                        child: ListTile(
                          title: Text(
                              snapshot.data![index].name), // Nama universitas.
                          subtitle: Text(snapshot
                              .data![index].website), // Situs web universitas.
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                // Jika terjadi error,
                // tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Tampilkan indikator loading jika masih memuat data.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
