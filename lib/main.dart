import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'Details.dart';
import 'Global.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const MyApp(),
      'detail': (context) => const Detail(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WebSites",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: Global.website.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('detail', arguments: Global.website[i]['uri']);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        width: 200,
                        child: Image.asset(
                          Global.website[i]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        "${Global.website[i]['name']}",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
