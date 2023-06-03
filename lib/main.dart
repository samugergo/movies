import 'package:flutter/material.dart';
import 'package:movies/pages/catalog/catalog_page.dart';
import 'package:movies/states/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/common_util.dart';
import 'package:provider/provider.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  Paint.enableDithering = true;

  await dotenv.load(fileName: ".env");

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => MainAppState();

  static MainAppState of(BuildContext context) => context.findAncestorStateOfType<MainAppState>()!;
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xff343643)),
          extensions: [
            AppColors.theme
          ],
        ),
        localizationsDelegates: [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), 
          Locale('hu'), 
        ],
        home: Scaffold(
          body: _MainContainer(),
        ),
      ),
    );
  }
}

class _MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);

    return SafeArea(
      child: CatalogPage(
        load: appState.loadCatalog
      ),
    );
  }
}