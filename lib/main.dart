import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/pages/catalog/catalog_page.dart';
import 'package:movies/pages/home/home_page.dart';
import 'package:movies/pages/search/search_page.dart';
import 'package:movies/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/common_util.dart';
import 'package:provider/provider.dart'; 
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/services/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black87),
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