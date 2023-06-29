import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/enums/resource/param_enum.dart';
import 'package:movies/models/others/external_id_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaSection extends StatelessWidget {
  SocialMediaSection({
    required this.externalIds,
  });

  final ExternalIdModel externalIds;

  @override
  Widget build(BuildContext context) {
    return !externalIds.isNotNull 
    ? SizedBox()
    : Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          externalIds.facebookId != "" 
          ? _SocialMediaButton(
              baseUrlKey: ParamEnum.FACEBOOK_URL,
              id: externalIds.facebookId, 
              icon: FontAwesomeIcons.facebook,
            )
          : SizedBox(),
      
          externalIds.instagramId != ""
          ? _SocialMediaButton(
              baseUrlKey: ParamEnum.INSTAGRAM_URL,
              id: externalIds.instagramId, 
              icon: FontAwesomeIcons.instagram,
            )
          : SizedBox(),
      
          externalIds.twitterId != ""
          ? _SocialMediaButton(
              baseUrlKey: ParamEnum.TWITTER_URL,
              id: externalIds.twitterId, 
              icon: FontAwesomeIcons.twitter,
            )
          : SizedBox(),
      
          externalIds.imdbId != "" 
          ? _SocialMediaButton(
              baseUrlKey: ParamEnum.IMDB_URL,
              id: externalIds.imdbId, 
              icon: FontAwesomeIcons.imdb,
            )
          : SizedBox()
        ],
      ),
    );
  }

}

class _SocialMediaButton extends StatelessWidget {
  _SocialMediaButton({
    required this.baseUrlKey,
    required this.id,
    required this.icon,
  });

  final ParamEnum baseUrlKey;
  final String id;
  final IconData icon; 

  _launchURL() async {
    final Uri url = Uri.parse('${dotenv.env[baseUrlKey.value]}/$id');
    if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _launchURL, 
      icon: FaIcon(
        icon,
        color: Colors.white,
      ),
    );
  }

}