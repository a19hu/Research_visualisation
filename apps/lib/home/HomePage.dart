import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
   late WebViewController controller;

@override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse("https://research-visualisation.vercel.app"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: const Color.fromARGB(255, 28, 149, 205),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: Text('website'),
            icon: Icon(Icons.arrow_forward_ios_sharp),
            backgroundColor: Colors.blue,
            onPressed: () async {
              Uri _url = Uri.parse('https://research-visualisation.vercel.app/');
              if (await launchUrl(_url)) {
              } else {}
            }),
        body: Stack(
          children: [
            !isLoading
                ? Container(
                    child: WebViewWidget(controller: controller),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        )
        );
  }
}
