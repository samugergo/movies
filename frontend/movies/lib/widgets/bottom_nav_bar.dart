import 'package:floating_frosted_bottom_bar/floating_frosted_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {

  late int currentPage;
  late TabController tabController;

  var items = [
    '1', '2', '3', '4',
  ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FrostedBottomBar(
      opacity: 0.6,
      sigmaX: 5,
      sigmaY: 5,
      borderRadius: BorderRadius.circular(500),
      duration: const Duration(milliseconds: 100),
      hideOnScroll: true,
      body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: items.map((e) => ListView.builder(
              controller: controller,
              itemBuilder: (context, index) {
                return const Card(child: FittedBox(child: FlutterLogo()));
              },
            ),
          )
          .toList(),
        ),
      child: TabBar(
        indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
        controller: tabController,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.blue, width: 4),
          insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
        ),
        tabs: [
          TabsIcon(
              icons: Icons.home,
              color: currentPage == 0 ? Colors.blue : Colors.white),
          TabsIcon(
              icons: Icons.search,
              color: currentPage == 1 ? Colors.blue : Colors.white),
          TabsIcon(
              icons: Icons.queue_play_next,
              color: currentPage == 2 ? Colors.blue : Colors.white),
          TabsIcon(
              icons: Icons.file_download,
              color: currentPage == 3 ? Colors.blue : Colors.white),
        ],
      ),
    );
  }
}

class TabsIcon extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final IconData icons;

  const TabsIcon(
      {Key? key,
      this.color = Colors.white,
      this.height = 60,
      this.width = 50,
      required this.icons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: Icon(
          icons,
          color: color,
        ),
      ),
    );
  }
}