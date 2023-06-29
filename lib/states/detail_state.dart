import 'package:flutter/material.dart';
import 'package:movies/pages/common/detail_page.dart';
import 'package:movies/states/image_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/others/external_id_model.dart';
import '../models/others/providers_model.dart';
import '../services/service.dart';

abstract class DetailState<T extends DetailPage> extends ImageState<T> {
  /// List of the cast members.
  @protected List? cast;
  /// List of the top 5 images from the movie or show.
  @protected List? images;
  /// Url of the trailer of the movie or show.
  @protected String? trailer;
  /// [Providers] object that manages the watch proveders of the movie or show.
  @protected Providers? providers;
  /// [ExternalIdModel] object that manages the external id of the movie or show (imdb, fb, ista).
  @protected ExternalIdModel? externalIds;

  @protected
  void fetchCommonData() {
    _fetchProviders();
    _fetchCast();
    _fetchExternalIds();
    _fetchTrailer();
    _fetchImages();
  }

  @override
  bool isLoading() {
    return cast == null
      || images == null
      || trailer == null
      || providers == null
      || externalIds == null
      || super.isLoading();
  }

  void launchTrailer() async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$trailer');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _fetchProviders() async {    
    var p = await fetchProviders(widget.id, widget.type);
    setState(() {
      providers = p;
    });
  }
  void _fetchCast() async {
    var c = await fetchCast(widget.id, widget.type);
    setState(() {
      cast = c;
    });
  }
  void _fetchExternalIds() async {
    var e = await fetchExternalIds(widget.id, widget.type);
    setState(() {
      externalIds = e;
    });
  }
  void _fetchTrailer() async {
    var t = await fetchTrailer(widget.id, widget.type);
    setState(() {
      trailer = t;
    });
  }
  void _fetchImages() async {
    var i = await fetchImages(widget.id, widget.type);
    setState(() {
      images = i;
    });
  }
}