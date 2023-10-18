import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/models/user.dart';
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
  String oauth_authorize_url =
      "https://channeli.in/oauth/authorise/?client_id=1XDTUULqBMBdeIy4GyMEBuAwl8CWTjvzeTpr29Hy&redirect_uri=http%3A%2F%2F10.81.50.27%3A8000%2Fuserlogin%2F&state=done";
  bool finished = false;
  void initState() {
    super.initState();
    String ipAdd = ref.read(ip);
    url = "$ipAdd/userlogin/";
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
            ),
          ),
          onLoadStart: (controller, url) async {
            if (url!.queryParameters.containsKey('state') &&
                url.queryParameters['state'] == 'finished') {
              setState(() {
                finished = true;
              });
              var response = await DatabaseQueries.getUserDetails(
                  url.queryParameters['userId']!);
              ref.read(userLogged.notifier).state = User.set(response.data);

              final storage = new FlutterSecureStorage();
              await storage.write(
                  key: "sessionToken",
                  value: url.queryParameters['sessionToken']);
              await DatabaseQueries.updateSessionToken(
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
