import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies/enums/grid_enum.dart';
import 'package:movies/enums/order_enum.dart';
import 'package:movies/enums/type_enum.dart';
import 'package:movies/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  List catalogList = [];

  int catalogPage = 0;

  TypeEnum type = TypeEnum.movie;
  OrderEnum order = OrderEnum.popular;
  GridEnum grid = GridEnum.Nx3;

  bool _loading = false;

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

  setTypeString(String? type) {
    if (this.type.value != type) {
      this.type = TypeEnum.fromValue(type!);
      resetCatalog();
      loadCatalog();
      notifyListeners();
    }
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
  setGrid(grid) async {
    this.grid = grid;
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('grid', grid.value);

    notifyListeners();
  }
  // --- update functions ---
  updateCatalog(catalog) {
    catalogList.addAll(catalog);
    catalogPage++;
    notifyListeners();
  }

  // --- load functions ---

  /// Load the preferences from disk
  /// 
  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final ic = prefs.get('grid');

    int val = ic != null ? int.parse(ic.toString()) : 3;
    setGrid(GridEnum.from(val));
  }

  loadCatalog() async {
    if (!_loading) {
      _loading = true;
      final list = await get(catalogPage, type, order);
      updateCatalog(list);
      _loading = false;
    }
  }

  @protected
  resetCatalog() {
    catalogList.clear();
    catalogPage = 0;
  }
}