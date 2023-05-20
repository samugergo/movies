import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/state.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/buttons/load_button.dart';
import 'package:movies/widgets/others/chip_list.dart';
import 'package:movies/widgets/others/image_card.dart';
import 'package:provider/provider.dart';

class CatalogPage extends StatelessWidget {
  CatalogPage({
    required this.scrollController
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(           
        statusBarColor: Colors.black
        .withOpacity(0.6),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _GridView(
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }
}

class _GridView extends StatefulWidget {
  _GridView({
    required this.scrollController
  });

  final ScrollController scrollController;

  @override
  State<_GridView> createState() => _GridViewState();
}

class _GridViewState extends State<_GridView> {
  int _typeValue = 0;
  int _orderValue = 0;  

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = getAppTheme(context);
    final itemCount = appState.itemCount;
    final list = appState.catalogList;
    
    final double width = MediaQuery.of(context).size.width;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final itemWidth = width/itemCount - itemCount * crossSpacing;
    final itemHeight = itemWidth*1.5;

    var type = TypeEnum.values[_typeValue];
    var order = OrderEnum.values[_orderValue];

    load(type, order) {
      appState.loadCatalog(type, order);
    }

    setTypeValue(typeValue) {
      if (typeValue != _typeValue) {
        appState.resetCatalog();
        setState(() {
          _typeValue = typeValue;
        });
        load(TypeEnum.values[typeValue], OrderEnum.values[_orderValue]);
      }
    }

    setOrderValue(orderValue) {
      if (orderValue != _orderValue) {
        appState.resetCatalog();
        setState(() {
          _orderValue = orderValue;
        });
        load(TypeEnum.values[_typeValue], OrderEnum.values[orderValue]);
      }
    }

    return NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { 
        return [
          SliverAppBar(
            backgroundColor: theme.hidable,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 50),
              title: Text(
                'Katalógus',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.hidable,
            titleSpacing: 0,
            title: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChipList(
                    value: _typeValue, 
                    mandatory: true, 
                    setState: setTypeValue,
                    list: TypeEnum.titles(), 
                  ),
                  SizedBox(width: 10),
                  ChipList(
                    value: _orderValue, 
                    mandatory: true, 
                    setState: setOrderValue,
                    list: OrderEnum.titles(), 
                  ),
                ],
              ),
            ),
          )
        ];
      },
      body: ListView(
        children: [
          GridView.count(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: itemCount,
            mainAxisSpacing: mainSpacing,
            crossAxisSpacing: crossSpacing,
            childAspectRatio: itemWidth/itemHeight,
            children: list.map<Widget>((pair) => ImageCard(
              model: pair,
              goTo: (model) {
                final Widget to = TypeEnum.isMovie(model.type)
                  ? MoviePage(id: model.id, color: Colors.black) 
                  : ShowPage(id: model.id, color: Colors.black);
                goTo(context, to);
              },
            )).toList(),
          ),
          SizedBox(height: 10),
          LoadButton(load: () => load(type, order)),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}