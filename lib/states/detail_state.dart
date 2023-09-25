import 'package:flutter/material.dart';
import 'package:movies/pages/common/detail_page.dart';
import 'package:movies/states/image_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/others/external_id_model.dart';
import '../models/others/providers_model.dart';
import '../services/service.dart';

abstract class DetailState<T extends DetailPage> extends ImageState<T> {
  /// [Providers] object that manages the watch proveders of the movie or show.
  @protected
  Providers? providers;

  @protected
  void fetchCommonData() {
    _fetchProviders();
  }

  @override
  bool isLoading() {
    return providers == null || super.isLoading();
  }

  void launchTrailer(String trailer) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$trailer');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _fetchProviders() async {
    var p = await getProviders(widget.id, widget.type);
    setState(() {
      providers = p;
    });
  }
}
