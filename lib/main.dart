import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Web View Test', home: FirstPage());
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    String url = 'https://www.google.com';
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: Text('Open WebView'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebView(
                            url: url,
                          )),
                );
              },
            ),
            TextButton(
              child: Text('Open Url Launcher'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UrlLauncehr(url: url)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WebView extends StatefulWidget {
  const WebView({super.key, required this.url});
  final String url;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController webcontroller = WebViewController();
  MaterialColor appBarColor = Colors.blue;

  @override
  void initState() {
    super.initState();

    webcontroller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {
          print("WebresourceError occured!");
          setState(() {
            appBarColor = Colors.red;
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );

    webcontroller.loadRequest(Uri.parse(widget.url));
    // webcontroller.loadRequest(Uri.parse('https://www.google.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Telebirr Payment'), backgroundColor: appBarColor),
        body: Container(
          child: WebViewWidget(
            controller: webcontroller,
          ),
        ));
  }
}

class UrlLauncehr extends StatefulWidget {
  const UrlLauncehr({super.key, required this.url});
  final String url;

  @override
  State<UrlLauncehr> createState() => _UrlLauncehrState();
}

class _UrlLauncehrState extends State<UrlLauncehr> {
  late Uri _url = Uri.parse(widget.url);

  Future<void> _launchUrl() async {
    try {
      await launchUrl(_url).then((value) => print(value));

      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  void _launchurl(Uri url) {
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Url Launcher'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: Text('Open Url Launcher'),
              onPressed: () {
                _launchUrl();
              },
            ),
          ],
        ),
      ),
    );
  }
}
