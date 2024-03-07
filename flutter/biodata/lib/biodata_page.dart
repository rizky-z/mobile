import 'package:flutter/material.dart';

class BiodataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Biodata',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNLXMjRwxKb32_iBLR5ouRYFiu0DNjYNR_xg&s'),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Nama: Rizky Muhammad Sofyan',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'NIM: 2041018',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Mata Kuliah: Mobile',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Prodi: S1 Teknik Informatika',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Jenis kelamin: Laki-Laki',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'TTL: Bandung, 02 02 2022',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Alamat: JL. KOPO',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
