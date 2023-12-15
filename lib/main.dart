import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:manifest/pages/auth_page.dart';
import 'package:manifest/pages/home_page.dart';
import 'package:manifest/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manifest/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:manifest/src/features/auth/data/datasources/auth_remote_datasource_firebase.dart';
import 'package:manifest/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:manifest/src/shared/app/app.dart';
import 'package:manifest/utils.dart';
import 'firebase_options.dart';

typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(await builder());
}

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  bootstrap(
    () async {
      AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();
      AuthRemoteDataSource authRemoteDataSource =
          AuthRemoteDataSourceFirebase();

      AuthRepository authRepository = AuthRepositoryImpl(
        localDataSource: authLocalDataSource,
        remoteDataSource: authRemoteDataSource,
      );

      return App(
        authRepository: authRepository,
        authUser: await authRepository.authUser.first,
      );
    },
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key, required this.authRepository, this.authUser});

//   final AuthRepository authRepository;
//   final AuthUser? authUser;

//   static const String title = 'Manifest';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: Utils.messengerKey,
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: title,
//       theme: ThemeData.light().copyWith(
//         scaffoldBackgroundColor: Color(0xffF5F5DC),
//         colorScheme: ColorScheme.fromSwatch(
//                 primarySwatch: createMaterialColor(Color(0xffD64045)))
//             .copyWith(secondary: Color(0xff27213C)),
//       ),
//       home: MainPage(),
//     );
//   }
// }

// class MainPage extends StatelessWidget {
//   const MainPage({super.key});

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       body: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Something went wrong!'));
//             } else if (snapshot.hasData) {
//               return HomePage();
//             } else {
//               return AuthPage();
//             }
//           }));
// }

// MaterialColor createMaterialColor(Color color) {
//   List strengths = <double>[.05];
//   Map<int, Color> swatch = {};
//   final int r = color.red, g = color.green, b = color.blue;

//   for (int i = 1; i < 10; i++) {
//     strengths.add(0.1 * i);
//   }
//   for (var strength in strengths) {
//     final double ds = 0.5 - strength;
//     swatch[(strength * 1000).round()] = Color.fromRGBO(
//       r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//       g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//       b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//       1,
//     );
//   }
//   return MaterialColor(color.value, swatch);
// }
