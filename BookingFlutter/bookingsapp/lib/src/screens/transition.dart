import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final userLogged = StateProvider<User>((ref) => User.defaultUser());

class TransitionScreen extends ConsumerStatefulWidget {
  const TransitionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransitionScreenState();
}

class _TransitionScreenState extends ConsumerState<TransitionScreen> {
  String initialLocation = "";

  Future<void> setLocation() async {
    initialLocation = await getInitialLocation(ref);
    // ignore: use_build_context_synchronously
    context.go(initialLocation);
  }

  @override
  void initState() {
    super.initState();
    setLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("BOOKING\$",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Discover. Book. Enjoy.",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.white)),
              )
            ],
          ),
          centerTitle: true,
          toolbarHeight: 100,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                "Loading...",
                style: Theme.of(context).textTheme.displayMedium!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
