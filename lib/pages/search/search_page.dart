import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:movies/enums/type_enum.dart';
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
import 'package:movies/widgets/others/chip_list.dart';
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
  int _typeValue = 0;
  String _value = "";
  List<String> _history = [];
  final TextEditingController _controller = TextEditingController();

  _search(value, saveHistory) async {
    _searchWithType(value, TypeEnum.values[_typeValue], saveHistory);
  }

  _searchWithType(value, type, saveHistory) async {
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

  loadMore() async {
    ListResponse lr = await search(_page, TypeEnum.values[_typeValue], _value);

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

  _setTypeValue(typeValue) {
    if (_typeValue != typeValue) {
      setState(() {
        _typeValue = typeValue;
      });
      if (_value != '') {
        _searchWithType(_value, TypeEnum.values[typeValue], false);
      }
    }
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
    ScrollController sc = ScrollController();

    goColor(id, color) {
      final Widget to = TypeEnum.isMovie(TypeEnum.values[_typeValue])
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1],
          colors: [
            theme.primary!, 
            theme.primaryLight!
          ],
        ),
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   scrolledUnderElevation: 0,
        //   titleSpacing: 0,
        //   backgroundColor: theme.hidable,
        //   automaticallyImplyLeading: false,          
        //   title: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SearchField(
        //       controller: _controller,
        //       search: _search,
        //     ),
        //   ),
        //   bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(50), // here the desired height
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: Row(
        //         children: [
        //           ChipList(
        //             value: _typeValue, 
        //             mandatory: true, 
        //             setState: _setTypeValue,
        //             list: TypeEnum.titles(), 
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // body: _results.isNotEmpty 
        // ? ResultList(
        //   results: _results, 
        //   total: _total, 
        //   load: loadMore, 
        //   goTo: go,
        //   horizontalPadding: horizontalPadding, 
        //   scrollController: widget._scrollController, 
        // )
        // : HistoryList(
        //   history: _history, 
        //   controller: _controller, 
        //   search: _search, 
        //   delete: _deleteFromHistory
        // )
        body: NestedScrollView(     
          controller: widget._scrollController,     
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { 
            return [
                SliverAppBar(
                  backgroundColor: theme.hidable,
                  expandedHeight: 160,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.only(bottom: 50),
                    title: Text(
                      'Keresés',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                SliverAppBar(
                  backgroundColor: theme.hidable,
                  titleSpacing: 10,                  
                  scrolledUnderElevation: 0,
                  elevation: 0,
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: 100,
                  title: SearchField(
                    controller: _controller, 
                    search: _search
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    expandedTitleScale: 1,
                    centerTitle: true,
                    title: ChipList(
                      value: _typeValue, 
                      mandatory: true, 
                      setState: _setTypeValue,
                      list: TypeEnum.titles(), 
                    ),
                  ),
                )
            ];
          },
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
      )
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({
    required TextEditingController controller,
    required Function(String, bool) search,
  }) :
  _controller = controller,
  _search = search;

  final TextEditingController _controller;
  final Function(String, bool) _search;

  @override
  Widget build(BuildContext context) {
    final appState = getAppState(context);
    final theme = getAppTheme(context);

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      autofocus: true,
      onSubmitted: (value) {
        _search(value, true);
      },
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff222222),
        suffixIcon: Icon(
          Icons.search,
          color: theme.unselected!,
        ),
        hintText: '${appState.type.title} keresése',
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.normal
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
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
    required Function load,
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
  final Function _load;
  final Function _goTo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // controller: _scrollController,
      children: [
        Padding(
          padding: EdgeInsets.only(left: _horizontalPadding),
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
        ? LoadButton(load: () => _load())
        : SizedBox(),
      ],
    );
  }

}

class HistoryList extends StatelessWidget {
  HistoryList({
    required List history,
    required TextEditingController controller,
    required Function(String, bool) search,
    required Function(int) delete,
  }) : 
  _history = history,
  _controller = controller,
  _search = search,
  _delete = delete; 

  final List _history;
  final TextEditingController _controller;
  final Function(String, bool) _search;
  final Function(int) _delete;

  @override
  Widget build(BuildContext context) {
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
              _search(_history[index], false);
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