import 'package:flutter/material.dart'; // Mengimpor package flutter material untuk mengembangkan UI.
import 'package:http/http.dart' as http; // Mengimpor package http untuk melakukan HTTP requests.
import 'dart:convert'; // Mengimpor package convert untuk mengonversi data.

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter.
}

// Kelas untuk menampung data hasil pemanggilan API.
class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); // Constructor.

  // Mengonversi JSON ke atribut objek.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan instance MyAppState.
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Menampung hasil aktivitas dari API.
  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API.

  // Inisialisasi futureActivity.
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  // Mengambil data dari API.
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Melakukan HTTP GET request.
    if (response.statusCode == 200) {
      // Jika status code 200 OK,
      // parsing JSON dan mengembalikan objek Activity.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika status code bukan 200 OK, lemparkan exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Inisialisasi futureActivity.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity =
                      fetchData(); // Memuat aktivitas baru saat tombol ditekan.
                });
              },
              child: Text("Saya bosan ..."), // Teks tombol.
            ),
          ),
          // FutureBuilder untuk menampilkan data dari futureActivity.
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika ada data, tampilkan aktivitas dan jenisnya.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Tampilkan aktivitas.
                      Text("Jenis: ${snapshot.data!.jenis}") // Tampilkan jenis.
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error, tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Jika sedang loading, tampilkan CircularProgressIndicator.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
