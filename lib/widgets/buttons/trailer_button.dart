import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/utils/common_util.dart';

class TrailerButton extends StatelessWidget {
  TrailerButton({
    required String id,
    required Function onclick,
  })  : _id = id,
        _onClick = onclick;

  final Function _onClick;
  final String _id;

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    const icon = FontAwesomeIcons.play;
    final text = locale.watchTrailer;

    return _id != ''
        ? ElevatedButton.icon(
            onPressed: () => _onClick(),
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(12),
                backgroundColor: Colors.white12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            label: Text(text, style: TextStyle(color: Colors.white)),
            icon: FaIcon(icon, size: 14, color: Colors.white))
        : SizedBox();
  }
}
