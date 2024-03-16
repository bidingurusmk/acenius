import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity/connectivity.dart';

// final webViewKey = GlobalKey<_MyHomePageState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController controller;

  bool konek = false;
  Future check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        konek = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        konek = true;
      });
    } else {
      setState(() {
        konek = false;
      });
    }
  }

  int loadingPercentage = 0;

  web1() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        // Uri.parse('https://youtube.com/'),
        // Uri.parse('https://smktelkom-mlg.sch.id/'),
        Uri.parse('https://google.com/'),
      );
  }

  @override
  void initState() {
    check();
    web1();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Apps"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              check();
              konek == true ? controller.reload() : koneksi_not();
            },
          ),
          Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.all(5),
              color: loadingPercentage == 100
                  ? Colors.green[200]
                  : Colors.blue[200],
              child: Text(loadingPercentage.toString() + " %"))
        ],
      ),
      body: konek == true
          ? WebViewWidget(
              controller: controller,
            )
          : koneksi_not(),
    );
  }

  Widget koneksi_not() {
    return new Center(
        child: Image.asset(
      'assets/Internet-Access-Error.jpg',
      width: MediaQuery.of(context).size.width,
    ));
  }
}
