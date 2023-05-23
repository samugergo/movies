import 'package:flutter/material.dart';
import 'package:movies/pages/catalog/catalog_page.dart';
import 'package:movies/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:provider/provider.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  Paint.enableDithering = true;

  await dotenv.load(fileName: ".env");

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xff353443)),
          extensions: [
            AppColors.theme
          ],
        ),
        home: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: CatalogPage(),
        ),
      ),
    );
  }
}