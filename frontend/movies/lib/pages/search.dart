import 'package:flutter/material.dart';
import 'package:movies/main.dart';
import 'package:movies/models/base/list_response.dart';
import 'package:movies/services/service.dart';
import 'package:movies/widgets/image.dart';
import 'package:movies/widgets/load_button.dart';
import 'package:provider/provider.dart';

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

  _search(value, type) async {
    this.value = value;
    page = 0;
    total = 0;

    ListResponse lr = await search(page, type, value);

    setResults(lr.list);
    updateTotal(lr.total);
  }

  loadMore(type) async {
    ListResponse lr = await search(page, type, value);

    updateResults(lr.list);
    updateTotal(lr.total);
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
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();

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
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff292A37),
          title: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              _search(value, appState.type);
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
                borderSide: BorderSide(color: Color(0xff292A37)),
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff292A37)),
                borderRadius: BorderRadius.circular(50.0),
              ),
              contentPadding: EdgeInsets.only(left: 20.0),
              constraints: BoxConstraints(
                maxHeight: 50,
              )
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              results.isNotEmpty 
              ? Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Text(
                  'Találatok száma: $total',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic
                  ),
                ),
              )
              : SizedBox(),
              SizedBox(height: 15),
              ...results.map((e) => 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    XImage(
                      url: e.image,
                      width: 100,
                      height: 150,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              e.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              e.release,
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            elevation: 0,
                            color: Colors.black.withAlpha(50),
                            shape: CircleBorder(),
                            child: Stack(
                              children: [
                                CircularProgressIndicator(
                                  value: e.raw / 10,
                                  color: Color.lerp(Colors.red, Colors.green, e.raw / 10),
                                  strokeWidth: 2,
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      e.percent,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
              total != results.length
              ? LoadButton(load: () => loadMore(appState.type))
              : SizedBox(),
            ],
          ),
        )
      ),
    );
  }
}