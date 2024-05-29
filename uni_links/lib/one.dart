import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

class One extends StatefulWidget {
  const One({super.key});

  @override
  State<One> createState() => _OneState();
}

class _OneState extends State<One> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  String url = "https://qsdrthy-d0holnp8o-vishnuairs-projects.vercel.app";
  WebViewController? _myWebViewController;

  double _progress = 0;

  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    initDeepLinks();
    _myWebViewController = initializeController(url);
    setState(() {
      _myWebViewController;
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    print("hello1");
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
    });
  }

  WebViewController initializeController(String url) {
    print("hello2");
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            if (!_disposed) {
              setState(() {
                _progress = progress / 100;
              });
            }
          },
          onPageStarted: (String url) {
            if (!_disposed) {
              setState(() {
                _progress = 0;
              });
            }
          },
          onPageFinished: (String url) {
            if (!_disposed) {
              setState(() {
                _progress = 1.0;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      );

    // Check if URL is not empty before loading the request
    if (url.isNotEmpty) {
      controller.loadRequest(Uri.parse(url));
    }

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Center(child: Text("One")),
        backgroundColor: Colors.white,
      ),
      body: _myWebViewController == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _progress < 1.0
                    ? LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
                    : Container(),
                Expanded(
                  child: WebViewWidget(controller: _myWebViewController!),
                ),
              ],
            ),
    );
  }
}
