import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/state.dart';
import 'package:movies/theme/app_colors.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/buttons/load_button.dart';
import 'package:movies/widgets/others/result_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    required ScrollController scrollController
  }) : 
  _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _results = [];
  int _page = 0;
  int _total = 0;
  int _pages = 0;
  String _value = "";
  List<String> _history = [];
  final TextEditingController _controller = TextEditingController();

  _search(value, type, saveHistory) async {
    _value = value;
    _page = 0;
    _total = 0;

    if(saveHistory) {
      _saveHistory(value);
    }

    ListResponse lr = await search(_page, type, value);

    setResults(lr.list);
    updateTotal(lr.total);
  }

  loadMore(type) async {
    ListResponse lr = await search(_page, type, _value);

    updateResults(lr.list);
    updateTotal(lr.total);
  }

  _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final sh = prefs.getStringList('searchHistory');
    setState(() {
      _history = sh ?? []; 
    });
  }

  _saveHistory(value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if(_history.length > 9) {
        _history.removeLast();
      } 
      _history.insert(0, value);
    });
    prefs.setStringList('searchHistory', _history);
  }

  _deleteFromHistory(index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.removeAt(index);
    });
    prefs.setStringList('searchHistory', _history);
  }

  setResults(list) {
    setState(() {
      _results = list;
      _page++;
    });
  }

  updateResults(list) {
    setState(() {
      _results.addAll(list);
      _page++;
    });
  }

  updateTotal(total) {
    setState(() {
      _total = total;
    });
  }

  @override
  void initState() {
    _loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context).extension<AppColors>()!;
    const double horizontalPadding = 15;

    goColor(id, color) {
      final Widget to = appState.type == TypeEnum.movie 
        ? MoviePage(id: id, color: color) 
        : ShowPage(id: id, color: color);
      goTo(context, to);
    }

    go(model){
      getColorFromImage(
        lowImageLink(model.cover), 
        (color) => goColor(model.id, color)
      );
    } 

    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     stops: [0.5, 1],
      //     colors: [
      //       theme.primary!, 
      //       theme.secondary!
      //     ],
      //   ),
      // ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          backgroundColor: Colors.black54,
          automaticallyImplyLeading: false,          
          title: SearchField(
            controller: _controller,
            search: _search,
          )
        ),
        body: _results.isNotEmpty 
        ? ResultList(
          results: _results, 
          total: _total, 
          load: loadMore, 
          goTo: go,
          horizontalPadding: horizontalPadding, 
          scrollController: widget._scrollController, 
        )
        : HistoryList(
          history: _history, 
          controller: _controller, 
          search: _search, 
          delete: _deleteFromHistory
        )
      )
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({
    required TextEditingController controller,
    required Function(String, TypeEnum, bool) search,
  }) :
  _controller = controller,
  _search = search;

  final TextEditingController _controller;
  final Function(String, TypeEnum, bool) _search;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      autofocus: true,
      onSubmitted: (value) {
        _search(value, appState.type, true);
      },
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        suffixIcon: Icon(
          Icons.search,
          color: Colors.grey[600],
        ),
        hintText: '${appState.type.title} keresése',
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.normal
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(0),
        ),
        contentPadding: EdgeInsets.only(left: 15),
        constraints: BoxConstraints(
          maxHeight: 50,
        )
      ),
    );
  }
}

class ResultList extends StatelessWidget {
  ResultList({
    required List results,
    required int total,
    required double horizontalPadding,
    required ScrollController scrollController,
    required Function(TypeEnum) load,
    required Function goTo,
  }) : 
  _results = results,
  _total = total,
  _horizontalPadding = horizontalPadding,
  _scrollController = scrollController,
  _load = load,
  _goTo = goTo;

  final List _results;
  final int _total;
  final double _horizontalPadding;
  final ScrollController _scrollController;
  final Function(TypeEnum) _load;
  final Function _goTo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        Padding(
          padding: EdgeInsets.only(left: _horizontalPadding, top: 10),
          child: Text(
            'Találatok száma: $_total',
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic
            ),
          ),
        ),              
        SizedBox(height: 15),
        ..._results.map((e) => 
          Padding(
            padding: EdgeInsets.only(left: _horizontalPadding, right: _horizontalPadding, bottom: 16),
            child: InkWell(
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              onTap: () => _goTo(e),
              child: ResultCard(
                image: e.image,
                title: e.title,
                release: e.release,
                percent: e.percent,
              ),
            ),
          )
        ),
        _total != _results.length
        ? LoadButton(load: () => _load(TypeEnum.movie))
        : SizedBox(),
      ],
    );
  }

}

class HistoryList extends StatelessWidget {
  HistoryList({
    required List history,
    required TextEditingController controller,
    required Function(String, TypeEnum, bool) search,
    required Function(int) delete,
  }) : 
  _history = history,
  _controller = controller,
  _search = search,
  _delete = delete; 

  final List _history;
  final TextEditingController _controller;
  final Function(String, TypeEnum, bool) _search;
  final Function(int) _delete;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        reverse: false,
        shrinkWrap: true,
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _controller.value = TextEditingValue(
                text: _history[index],
                selection: TextSelection.fromPosition(
                  TextPosition(offset: _history[index].length),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
              _search(_history[index], appState.type, false);
            },
            leading: Icon(
              Icons.schedule,
              color: Colors.white60,
            ),
            title: Text(
              _history[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.normal
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white12,
                size: 18,
              ),
              onPressed: () => _delete(index),
            ),
          );
        },  
      ),
    );
  }
}