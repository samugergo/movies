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
import 'package:movies/utils/locale_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/buttons/load_button.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/others/chip_list.dart';
import 'package:movies/widgets/others/result_card.dart';
import 'package:movies/widgets/sheets/search_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _results = [];
  int _page = 0;
  int _total = 0;
  String _value = "";
  List<String> _history = [];
  final TextEditingController _controller = TextEditingController();

  var _typeValue = TypeEnum.movie;

  _setTypeValue(typeValue) {
    if (_typeValue != typeValue) {
      setState(() {
        _typeValue = typeValue;
      });
      if (_value != '') {
        _searchWithType(_value, typeValue, false);
      }
    }
    Navigator.pop(context);
  }

  _search(value, saveHistory) async {
    if (value != "") {
      _searchWithType(value, _typeValue, saveHistory);
    }
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
    ListResponse lr = await search(_page, _typeValue, _value);

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
    final theme = Theme.of(context).extension<AppColors>()!;
    const double horizontalPadding = 15;

    show() {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => SearchSheet(
          type: _typeValue,
          function: _setTypeValue,
        ),
      );
    }

    body() {
      final searched = _value != "";
      final hasResults = _results.isNotEmpty;

      if (searched && hasResults) {
        return ResultList(
          results: _results, 
          total: _total, 
          load: loadMore, 
          goTo: (model) {
            final Widget to = TypeEnum.isMovie(model.type)
              ? MoviePage(id: model.id, color: Colors.black) 
              : ShowPage(id: model.id, color: Colors.black);
            goTo(context, to);
          },
          horizontalPadding: horizontalPadding,
        );
      } else if (searched && !hasResults) {
        return NoResult();
      } else {
        return HistoryList(
          history: _history, 
          controller: _controller, 
          search: _search, 
          delete: _deleteFromHistory
        );
      }
    }

    return GradientContainer(
      color: theme.primaryLight,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          backgroundColor: theme.primaryLight,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),       
          title: SearchField(
            controller: _controller,
            search: _search,
            type: _typeValue,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings,
              color: Colors.white,),
              onPressed: show
            ),
            SizedBox(width: 10),
          ],
        ),
        body: body()
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({
    required TextEditingController controller,
    required Function(String, bool) search,
    required TypeEnum type,
  }) :
  _controller = controller,
  _search = search,
  _type = type;

  final TextEditingController _controller;
  final Function(String, bool) _search;
  final TypeEnum _type;

  @override
  Widget build(BuildContext context) {
    final theme = getAppTheme(context);
    final locale = getAppLocale(context);

    hint() {
      final type = getTypeLocale(_type, locale).toLowerCase();
      return locale.searchType(type);
    }

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
        fillColor: Colors.transparent,
        prefixIcon: Icon(
          Icons.search,
          color: theme.unselected!,
        ),
        hintText: hint(),
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
    required Function load,
    required Function goTo,
  }) : 
  _results = results,
  _total = total,
  _horizontalPadding = horizontalPadding,
  _load = load,
  _goTo = goTo;

  final List _results;
  final int _total;
  final double _horizontalPadding;
  final Function _load;
  final Function _goTo;

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    return ListView(
      shrinkWrap: true,
      // controller: _scrollController,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: _horizontalPadding),
          child: Text(
            locale.results(_total),
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

class NoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              color: Colors.grey,
              size: 100,
            ),
            Wrap(
              children: [
                Text(
                  locale.noResult,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}