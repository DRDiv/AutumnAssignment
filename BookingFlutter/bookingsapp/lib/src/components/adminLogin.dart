import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminLoginCard extends ConsumerStatefulWidget {
  const AdminLoginCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminLoginCardState();
}

class _AdminLoginCardState extends ConsumerState<AdminLoginCard> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
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
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
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
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var admin = await DatabaseQueriesUser.adminLogin(
                  _username.text,
                  _password.text,
                );

                if (admin.statusCode == 200) {
                  var response = await DatabaseQueriesUser.getUserDetails(
                    admin.data['userId']!,
                  );
                  ref.read(userLogged.notifier).state = User.set(response.data);

                  const storage = FlutterSecureStorage();

                  await storage.write(
                    key: "sessionToken",
                    value: admin.data['sessionToken'],
                  );
                  await DatabaseQueriesUser.updateSessionToken(
                    ref.read(userLogged).userId,
                    admin.data['sessionToken']!,
                  );

                  router.go("/homeAdmin");
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(admin.data['message'].toString()),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
