import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadButton extends StatelessWidget {

  final Function load;

  LoadButton({
    super.key,
    required this.load,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
      child: ElevatedButton.icon(
        onPressed: () => load(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xff343643)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        icon: FaIcon(FontAwesomeIcons.arrowRotateRight),
        label: Text('Több betöltése'),
      ),
    );
  }
}