import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

import 'Global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const Detail());
}

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          if (Platform.isAndroid) {
            await inAppWebViewController!.reload();
          } else if (Platform.isIOS) {
            await inAppWebViewController!.loadUrl(
                urlRequest:
                    URLRequest(url: await inAppWebViewController!.getUrl()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    String data = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      bottomNavigationBar: Container(
        height: 40,
        width: double.infinity,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                if (await inAppWebViewController!.canGoBack()) {
                  await inAppWebViewController!.goBack();
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController!
                    .loadUrl(urlRequest: URLRequest(url: Uri.parse(data)));
              },
              icon: const Icon(Icons.home),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () async {
                if (await inAppWebViewController!.canGoForward()) {
                  await inAppWebViewController!.goForward();
                }
              },
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(data),
        ),
        onWebViewCreated: (val) {
          inAppWebViewController = val;
        },
        pullToRefreshController: pullToRefreshController,
        onLoadStop: (controller, uri) async {
          await pullToRefreshController.endRefreshing();
        },
      ),
    );
  }
}
