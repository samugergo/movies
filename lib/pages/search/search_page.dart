import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/locale_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/containers/gradient_container.dart';
import 'package:movies/widgets/others/result_card.dart';
import 'package:movies/widgets/sheets/search_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  /// It contains the current search page (used for load more search results).
  int page = 0;
  /// It contains the total number of results to the search.
  int total = 0;
  /// History list state, it contains maximum number of 10 history items.
  List<String> history = [];
  /// It contains the loaded search results.
  List results = [];
  /// The value of the search field (it must not be null).
  String searchValue = "";
  /// The type of the search, it is independent from the [appState.type].
  TypeEnum typeValue = TypeEnum.movie;  
  /// It defines that the 'scrollUpButton' should be visible or not.
  bool _showBtn = false;
  /// It defines on offset to the scroll, when should be the 'scrollUpButton' visible.
  double showoffset = 200;
  /// A custom [TextEditingController] to manage the search value.
  late TextEditingController _controller;
  /// A custom [ScrollController] to create a custom scroll behaviour. (e.g. display the 'scrollUpButton' on scroll).
  late ScrollController _scrollController;

  /// Load the 10 last search values from mobile to display in the history list view 
  /// whern the user click on the search field.
  ///
  loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final sh = prefs.getStringList('searchHistory');
    setState(() {
      history = sh ?? []; 
    });
  }
  /// Save the last search ir the mobile preferences to the load historoy function. 
  /// It must be called when the user search for a new film or show!
  /// And shouldn't when clik on a history item!
  /// 
  /// [String] value of the search field, the value of the search query
  /// 
  saveHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if(history.length > 9) {
        history.removeLast();
      } 
      history.insert(0, value);
    });
    prefs.setStringList('searchHistory', history);
  }
  /// Delete an element from the history, and saves the new history list in the mobile [SharedPreferences].
  /// It must be called only when the user clicks on the remove icon in the history list!
  /// 
  /// [int] index of the elemnt the user clicked on in the history list
  /// 
  deleteFromHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history.removeAt(index);
    });
    prefs.setStringList('searchHistory', history);
  }

  /// It is a function to search in the DB for movies or shows (it is determined by the [typeValue] variable).
  /// It calls the [saveHistory] function if needed.
  /// This function must be called only when you want to reset the history list as well.
  /// This function is called only when the user changed the type value and we need to search with the new type value
  /// otherwise use the [searchWithoutType].
  /// 
  /// [String] value of the search field
  /// [TypeEnum] the type value of the search (movie or show).
  /// [bool] It determines that we want to save the history or not.
  /// 
  searchWithType(String value, TypeEnum type, bool needSave) async {
    searchValue = value;
    page = 0;
    total = 0;
    if(needSave) {
      saveHistory(value);
    }
    ListResponse response = await search(page, type, value);
    setResults(response);
  }
  /// This function is a 'subType' of the [searchWithType] function.
  /// It uses the the value of the [typeValue] variable as default.
  /// So if the value of the [typeValue] variable did not change this function should be used.
  /// 
  /// [String] value of the search field
  /// [bool] It determines that we want to save the history or not.
  /// 
  searchWithoutType(String value, bool needSave) async {
    if (value != "") {
      searchWithType(value, typeValue, needSave);
    }
  }
  /// This function is load more results from the DB using the [searchValue] variable and the [typeValue] variable.
  /// THis function must be called only on the pagination.
  /// 
  loadMore() async {
    if (total != results.length) {
      final response = await search(page, typeValue, searchValue);
      updateResults(response);
    }
  }
  /// Set the [typeValue] variable value and if the searchValue has a value then make a search with this value.
  /// And automatically closes the bottom sheet after selection.
  /// 
  /// [TypeEnum] the new typeValue (movie or show) the user selected.
  /// 
  setTypeValue(type) {
    if (typeValue != type) {
      setState(() {
        typeValue = type;
      });
      if (searchValue != '') {
        searchWithType(searchValue, typeValue, false);
      }
    }
    Navigator.pop(context);
  }
  /// Set the values of the [results], [total] and [page] variables.
  /// It replaces the value of the [results] variable list so this function must be called when we 
  /// want ot reset the pagination as well.
  /// 
  /// [ListResponse] the response of the [search] function
  /// 
  setResults(ListResponse response) {
    setState(() {
      results = response.list;
      total = response.total;
      page++;
    });
  }
  /// Update the value of the [results] variable list so this function must be called when we 
  /// don't want to reset the pagination.
  /// 
  /// [ListResponse] the response of the [search] function
  /// 
  updateResults(ListResponse response) {
    setState(() {
      results.addAll(response.list);
      total = response.total;
      page++;
    });
  }

  /// Initialize the [TextEditController] which is responsible for the search field and set
  /// the its value when the user clicks on a history search element.
  /// 
  initTextController() {
    _controller = TextEditingController();
  } 
  /// Initilaze the [ScrollController] which is responsible for a custom scroll behaviour
  /// (the scoll up button and the pagination).
  /// 
  initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_showBtn && _scrollController.position.pixels < showoffset) {
        setState(() {
          _showBtn = false; 
        });
      }
      if (!_showBtn && _scrollController.position.pixels > showoffset) {
        setState(() {
          _showBtn = true; 
        });
      }
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        await loadMore();
      }
    });
  }

  @override
  void initState() {
    loadHistory();

    initTextController();
    initScrollController();
   
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// This variable contains the app theme.
    final theme = getAppTheme(context);
    /// This variable contains the universal app horizontal padding.
    // TODO: make it universal.
    const double horizontalPadding = 15;

    /// This function toggles the seach sheet on the screen when the user clicks on 
    /// the 'changeType' icon.
    ///  
    showSearchSheet() {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => SearchSheet(
          type: typeValue,
          function: setTypeValue,
        ),
      );
    }
    /// This function determines which [Widget] needs to be rendered on the screen.
    /// /// If there was with no results then the [NoResults] widget will be rendered.
    /// If there was a search and it has results then it will render the [ResultList] widget.
    /// Otherwise the [HistoryList].
    /// 
    renderBody() {
      final searched = searchValue != "";
      final hasResults = results.isNotEmpty;

      if (searched && !hasResults) {
        return NoResult();
      } else if (searched && !hasResults) {
        return ResultList(
          controller: _scrollController,
          results: results, 
          total: total,
          goTo: (model) {
            final Widget to = TypeEnum.isMovie(model.type)
              ? MoviePage(id: model.id) 
              : ShowPage(id: model.id);
            goTo(context, to);
          },
          horizontalPadding: horizontalPadding,
        );
      } else {
        return HistoryList(
          history: history, 
          controller: _controller, 
          search: searchWithoutType, 
          delete: deleteFromHistory
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
            search: searchWithoutType,
            type: typeValue,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings,
              color: Colors.white,),
              onPressed: showSearchSheet
            ),
            SizedBox(width: 10),
          ],
        ),
        body: renderBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _showBtn ? 1.0 : 0.0, 
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              mini: true,
              backgroundColor: theme.primary,
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
      ),
    );
  }
}

/// This class is private class. It renders a custom search field which is used in this page.
/// It hasn't got any borders or bagrounds.
/// 
class SearchField extends StatelessWidget {
  SearchField({
    required TextEditingController controller,
    required Function(String, bool) search,
    required TypeEnum type,
  }) :
  _controller = controller,
  _search = search,
  _type = type;

  /// Contrtoller of the search field.
  final TextEditingController _controller;
  /// A function to make a seach on the api when needed.
  final Function(String, bool) _search;
  /// Type of the search (movie or tv) it is stored on page level.
  final TypeEnum _type;

  @override
  Widget build(BuildContext context) {
    /// Theme of the application.
    final theme = getAppTheme(context);
    // locale of the application.
    final locale = getAppLocale(context);

    /// This function makes the hint of the search field depends on the locale of the application.
    ///
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

/// This class renders a list of the result elements from the api. It can be 
/// paginated and all the result elements are clickable.
/// 
class ResultList extends StatefulWidget {
  ResultList({
    required List results,
    required int total,
    required double horizontalPadding,
    required Function goTo,
    required ScrollController controller,
  }) : 
  _results = results,
  _total = total,
  _horizontalPadding = horizontalPadding,
  _goTo = goTo,
  _controller = controller;

  /// This contains the results from the api it is stored on page level.
  final List _results;
  /// The total number of result elements.
  final int _total;
  /// Universal application horizontal padding.
  final double _horizontalPadding;
  /// The scoll controller of the page to handle the custom scrolling behavior.
  final ScrollController _controller;
  /// A function to call when the user click on a result element.
  final Function _goTo;

  @override
  State<ResultList> createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  @override
  Widget build(BuildContext context) {
    /// Locale of the application.
    final locale = getAppLocale(context);

    return ListView(
      shrinkWrap: true,
      controller: widget._controller,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: widget._horizontalPadding),
          child: Text(
            locale.results(widget._total),
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic
            ),
          ),
        ),              
        SizedBox(height: 15),
        ...widget._results.map((e) => 
          Padding(
            padding: EdgeInsets.only(left: widget._horizontalPadding, right: widget._horizontalPadding, bottom: 16),
            child: InkWell(
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              onTap: () => widget._goTo(e),
              child: ResultCard(
                image: e.image,
                title: e.title,
                release: e.release,
                percent: e.percent,
              ),
            ),
          )
        ),
      ],
    );
  }
}

/// This class renders the history list. The last 10 search value is saved on the 
/// phone with the [SharedPreferences] package.
/// 
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

  /// List of the last 10 history items.
  final List _history;
  /// Controller to change the text field value on click.
  final TextEditingController _controller;
  /// A function to make a search on the api.
  final Function(String, bool) _search;
  /// A function to delete an item from the history list (it deletes it from the phone as well).
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

/// This class renders a 'No Results page' when the user's search returns 
/// with an empty list. 
/// 
class NoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Locale of the application.
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