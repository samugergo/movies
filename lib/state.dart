import 'package:flutter/material.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  List catalogList = [];

  int catalogPage = 0;
  int itemCount = 3;

  TypeEnum type = TypeEnum.movie;
  OrderEnum order = OrderEnum.popular;

  AppState() {
    init();
    loadPreferences();
  }

  init() async {
    loadCatalog();
  }

  setCatalogList(List catalogList) {
    this.catalogList = catalogList;
    catalogPage = 1;
    notifyListeners();
  }


  setType(type) {
    if (this.type != type) {
      this.type = type;
      resetCatalog();
      loadCatalog();
      notifyListeners();
    }
  }
  setOrder(order) {
    if (this.order != order) {
      this.order = order;
      resetCatalog();
      loadCatalog();
      notifyListeners();
    }
  }
  setItemCount(itemCount) async {
    this.itemCount = itemCount;
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('itemCount', itemCount);

    notifyListeners();
  }
  // --- update functions ---
  updateCatalog(catalog) {
    catalogList.addAll(catalog);
    catalogPage++;
    notifyListeners();
  }

  // --- load fuctions ---

  /// Load the preferences from disk
  /// 
  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final ic = prefs.get('itemCount');
    setItemCount(ic ?? 3);
  }

  loadCatalog() async {
    final list = await fetch(catalogPage, type, order);
    updateCatalog(list);
  }

  @protected
  resetCatalog() {
    catalogList.clear();
    catalogPage = 0;
  }
}