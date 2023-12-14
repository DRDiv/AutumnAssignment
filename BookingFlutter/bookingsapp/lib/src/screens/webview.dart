import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  String url = '';
  String oauth_authorize_url = urlRedirect;

  bool finished = false;
  void initState() {
    super.initState();
    String ipAdd = ref.read(ip);
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
              var response = await DatabaseQueriesUser.getUserDetails(
                  url.queryParameters['userId']!);
              ref.read(userLogged.notifier).state = User.set(response.data);

              final storage = new FlutterSecureStorage();
              await storage.write(
                  key: "sessionToken",
                  value: url.queryParameters['sessionToken']);
              await DatabaseQueriesUser.updateSessionToken(
                  ref.read(userLogged).userId,
                  url.queryParameters['sessionToken']!);

              context.go("/home");
            }
          },
        ),
      ),
    );
  }
}
