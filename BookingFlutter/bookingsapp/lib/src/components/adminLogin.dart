import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class AdminLoginCard extends ConsumerStatefulWidget {
  final VoidCallback onLogin;

  const AdminLoginCard({Key? key, required this.onLogin}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminLoginCardState();
}

class _AdminLoginCardState extends ConsumerState<AdminLoginCard> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'FOR ADMIN',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: screenWidth * 0.7,
              child: TextFormField(
                controller: _username,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: screenWidth * 0.7,
              child: TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var admin = await DatabaseQueries.adminLogin(
                  _username.text,
                  _password.text,
                );

                if (admin.statusCode == 200) {
                  var response = await DatabaseQueries.getUserDetails(
                    admin.data['userId']!,
                  );
                  ref.read(userLogged.notifier).state = User.set(response.data);

                  final storage = new FlutterSecureStorage();
                  await storage.write(
                    key: "sessionToken",
                    value: admin.data['sessionToken'],
                  );
                  await DatabaseQueries.updateSessionToken(
                    ref.read(userLogged).userId,
                    admin.data['sessionToken']!,
                  );

                  context.go("/homeAdmin");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(admin.data['message'].toString()),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
