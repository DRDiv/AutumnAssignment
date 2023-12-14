import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/functions/setters.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  String url = '';
  String oauth_authorize_url = urlRedirect;

  bool finished = false;
  @override
  void initState() {
    super.initState();

    url = urlLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(oauth_authorize_url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              clearCache: true,
            ),
          ),
          onLoadStart: (controller, url) async {
            if (url!.queryParameters.containsKey('state') &&
                url.queryParameters['state'] == 'finished') {
              setState(() {
                finished = true;
              });
              await setUserDetailsAndSessionToken(
                url,
                ref,
              );

              router.go("/home");
            }
          },
        ),
      ),
    );
  }
}
