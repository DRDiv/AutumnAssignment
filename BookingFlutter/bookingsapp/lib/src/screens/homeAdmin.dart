import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/components/requestTile.dart';
import 'package:bookingsapp/src/functions/setters.dart';
import 'package:bookingsapp/src/providers/requestAdminProvider.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAdmin extends ConsumerStatefulWidget {
  const HomeAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAdminState();
}

class _HomeAdminState extends ConsumerState<HomeAdmin> {
  bool _isLoading = true;
  Future<void> _loading() async {
    await setRequestData(ref);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "BOOKING\$",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  router.go("/adminProfile");
                },
                icon: const Icon(Icons.person))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true;
              ref.read(requestAdmin).clear();
            });

            await _loading();
          },
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ((ref.read(requestAdmin).isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '😊', // Unicode for a happy face emoji
                            style: const TextStyle(fontSize: 50.0),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No Bookings Found",
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: ref.read(requestAdmin).length,
                      itemBuilder: (context, index) {
                        final request = ref.read(requestAdmin)[index];

                        return requestTile(context, ref, index, request);
                      },
                    )),
        ),
        bottomNavigationBar: BottomAppBarAdmin(context, ref),
      ),
    );
  }
}
