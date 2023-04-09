import 'package:flutter/material.dart';
import 'package:movies/pages/home/base_container.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/widgets/appbars/main_app_bar.dart';
import 'package:movies/widgets/buttons/hidable_fab.dart';
import 'package:movies/widgets/containers/gradient_container.dart';

class HomePage extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return GradientContainer(
      child: Scaffold(
        // appBar: AppBar(
        //   title: MainAppBar(),
        //   titleSpacing: 20,
        //   centerTitle: true,
        //   elevation: 0,
        //   scrolledUnderElevation: 0,
        //   backgroundColor: theme.primary,
        // ),
        body: BaseConainer(
          controller: scrollController,
        ),
        floatingActionButton: HidableFab(
          controller: scrollController
        ),
      ),
    );
  }
}