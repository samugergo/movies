import 'package:flutter/material.dart';
import 'package:movies/models/common/cast_model.dart';
import 'package:movies/pages/common/person_page.dart';
import 'package:movies/utils/navigation_util.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/sections/common/section.dart';

class CastSection extends StatelessWidget {
  final List cast;

  CastSection({
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    return cast.isEmpty 
    ? SizedBox()
    : Section(
      title: 'Szereplők', 
      children: [
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cast.map((c) => _CastMember(model: c)).toList(),
          ),
        )
      ]
    );
  }

}

class _CastMember extends StatelessWidget {
  final CastModel model;

  _CastMember({
    required this.model
  });

  @override
  Widget build(BuildContext context) {
    go(id) {
      final to = PersonPage(id: id);
      goTo(context, to);
    } 

    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => go(model.id),
          child: model.image != '' 
          ? _CastImage(model: model)
          : _CastNoImage(model: model),
        ),
      ),
    );
  }
}

class _CastImage extends StatelessWidget {
  _CastImage({
    required this.model,
  });

  final CastModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(model.image),
          radius: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
          child: Text(
            model.name,
            overflow: TextOverflow.ellipsis,      
            style: TextStyle(
              fontSize: 10, 
              color: Colors.white
            ),
          ),
        ),
        SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            model.role,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white30
            ),
          ),
        ),
      ],
    );
  }
}

class _CastNoImage extends StatelessWidget {
  _CastNoImage({
    required this.model,
  });

  final CastModel model;

  _getSign() {
    final splitted = model.name.split(' ');
    
    if(splitted.isEmpty) return 'A';
    if(splitted.length < 2) return splitted[0][0];
    if(splitted[1].isEmpty) return splitted[0][0].toUpperCase();

    return splitted[0][0].toUpperCase() + splitted[1][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white30,
          radius: 30,
          child: Text(_getSign()),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
          child: Text(
            model.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10, 
              color: Colors.white
            ),
          ),
        ),
        SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            model.role,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white30
            ),
          ),
        ),
      ],
    );
  }
}