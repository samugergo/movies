import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:movies/models/base/display_model.dart';
import 'package:movies/pages/catalog/catalog_page.dart';
import 'package:movies/pages/home/home_page.dart';
import 'package:movies/state.dart';
import 'package:movies/theme/app_colors.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  Widget _currentPage() {
    switch (_currentIndex) {
      case 1: return CatalogPage(); 
      default: return HomePage(
        scrollController: _scrollController,
      );
    }
  }

  void _setCurrent(int currentIndex) {
    setState(() {
      _currentIndex = currentIndex; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xff2B2B38),
            modalElevation: 0
          ),
          extensions: [
            AppColors.theme
          ],
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: _currentPage(),
          bottomNavigationBar: _BotttomNavigationBar(
            scrollController: _scrollController,
            currentIndex: _currentIndex,
            setCurrent: _setCurrent,
          ),
        ),
      ),
    );
  }
}

class _BotttomNavigationBar extends StatelessWidget {
  const _BotttomNavigationBar({
    super.key,
    required ScrollController scrollController,
    required int currentIndex,
    required Function(int) setCurrent
  }) : 
  _scrollController = scrollController, 
  _currentIndex = currentIndex,
  _setCurrent = setCurrent;

  final ScrollController _scrollController;
  final int _currentIndex;
  final Function(int) _setCurrent;

  @override
  Widget build(BuildContext context) {
    return Hidable(
      controller: _scrollController,
      child: Wrap(
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.black54,
            unselectedItemColor: Colors.grey[600],
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.film),
                label: 'Catalog',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidUser),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            onTap: _setCurrent
          ),
        ],
      ),
    );
  }
}