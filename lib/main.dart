import 'package:final_project_ba_char/bd/local_storage.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart';
import 'package:final_project_ba_char/providers/bar_navigation_provider.dart';
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:final_project_ba_char/providers/operators_provider.dart';
import 'package:final_project_ba_char/providers/rates_provider.dart';
import 'package:final_project_ba_char/providers/suppliers_provider.dart';
import 'package:final_project_ba_char/routes/app_router.dart';
import 'package:final_project_ba_char/styles/themes.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalStorage.configurePrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext? authContext;

  final goRouter = AppRouter.goRouter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DBProvider(),
      child: Builder(
        builder: (context) {
          final dbProvider = context.read<DBProvider>();
          return ChangeNotifierProvider(
            create: (BuildContext context) => AuthProvider(dbProvider),
            child: Builder(
              builder: (context) {
                authContext = context;

                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => RatesProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => BarNavigationProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => OperatorsProvider(
                        dbProvider,
                        authContext!.read<AuthProvider>(),
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => SuppliersProvider(
                        dbProvider,
                        authContext!.read<AuthProvider>(),
                      ),
                    ),
                  ],
                  child: MaterialApp.router(
                    title: 'BarrancoSoft',
                    theme: Themes.lightTheme(context),
                    debugShowCheckedModeBanner: false,
                    routerConfig: goRouter,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
