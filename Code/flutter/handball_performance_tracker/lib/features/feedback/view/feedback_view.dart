import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/sidebar/view/sidebar_view.dart';

class FeedbackView extends StatefulWidget {
  @override
  _FeedbackViewState createState() => new _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {

  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: SidebarView(),
        appBar: AppBar(
          title: const Text(StringsGeneral.lFeedback),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? Text(StringsGeneral.lPleaseWait)
                      : Container()),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse("https://forms.gle/nXtVc7q37sGnN1cZ6")),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            )),
                    onWebViewCreated: (InAppWebViewController controller) {
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
