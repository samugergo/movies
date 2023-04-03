import 'package:flutter/material.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/main.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';
import 'package:movies/services/service.dart';
import 'package:movies/utils/color_util.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/buttons/load_button.dart';
import 'package:movies/widgets/others/result_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List results = [];
  int page = 0;
  int total = 0;
  int pages = 0;
  String value = "";
  List<String> history = [];
  final TextEditingController controller = TextEditingController();

  _search(value, type, saveHistory) async {
    this.value = value;
    page = 0;
    total = 0;

    if(saveHistory) {
      _saveHistory(value);
    }

    ListResponse lr = await search(page, type, value);

    setResults(lr.list);
    updateTotal(lr.total);
  }

  loadMore(type) async {
    ListResponse lr = await search(page, type, value);

    updateResults(lr.list);
    updateTotal(lr.total);
  }

  _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final sh = prefs.getStringList('searchHistory');
    setState(() {
      history = sh ?? []; 
    });
  }

  _saveHistory(value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if(history.length > 9) {
        history.removeLast();
      } 
      history.insert(0, value);
    });
    prefs.setStringList('searchHistory', history);
  }

  _deleteFromHistory(index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history.removeAt(index);
    });
    prefs.setStringList('searchHistory', history);
  }

  setResults(list) {
    setState(() {
      results = list;
      page++;
    });
  }

  updateResults(list) {
    setState(() {
      results.addAll(list);
      page++;
    });
  }

  updateTotal(total) {
    setState(() {
      this.total = total;
    });
  }

  @override
  void initState() {
    _loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1],
          colors: [Color(0xff292A37), Color(0xff0F1018)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          backgroundColor: Color(0xff343643),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          title: TextField(
            controller: controller,
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
              fillColor: Color(0xff343643),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white24,
              ),
              hintText: '${appState.type.title} keresése',
              hintStyle: TextStyle(
                color: Colors.white24,
                fontWeight: FontWeight.normal
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff343643)),
                borderRadius: BorderRadius.circular(0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff343643)),
                borderRadius: BorderRadius.circular(0),
              ),
              contentPadding: EdgeInsets.only(left: 0),
              constraints: BoxConstraints(
                maxHeight: 50,
              )
            ),
          ),
        ),
        body: results.isNotEmpty 
          ? ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Text(
                'Találatok száma: $total',
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic
                ),
              ),
            ),              
            SizedBox(height: 15),
            ...results.map((e) => 
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16),
                child: InkWell(
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => go(e),
                  child: ResultCard(
                    image: e.image,
                    title: e.title,
                    release: e.release,
                    percent: e.percent,
                    raw: e.raw,
                  ),
                ),
              )
            ),
            total != results.length
            ? LoadButton(load: () => loadMore(appState.type))
            : SizedBox(),
          ],
        )
        : Container(
          color: Colors.white12,
          child: ListView.builder(
            reverse: false,
            shrinkWrap: true,
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  controller.value = TextEditingValue(
                    text: history[index],
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: history[index].length),
                    ),
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                  _search(history[index], appState.type, false);
                },
                leading: Icon(
                  Icons.schedule,
                  color: Colors.white60,
                ),
                title: Text(
                  history[index],
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
                  onPressed: () {
                    _deleteFromHistory(index);
                  },
                ),
              );
            },  
          ),
        )
      ),
    );
  }
}