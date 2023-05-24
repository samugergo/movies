import 'package:flutter/material.dart';
import 'package:movies/enums/provider_enum.dart';
import 'package:movies/models/common/providers_model.dart';
import 'package:movies/utils/common_util.dart';
import 'package:movies/widgets/others/image.dart';
import 'package:movies/widgets/sections/common/section.dart';

class ProviderSection extends StatelessWidget {
  ProviderSection({
    required Providers? providers,
  }) :
  _providers = providers;

  final Providers? _providers;

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    return Section(
      title: locale.availability,
      children: _providers!.available.isNotEmpty 
      ? [
        SizedBox(
          height: 73,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _providers!.available.map((provider) => 
              _ProviderSection(
                providerEnum: provider, 
                providers: _providers!
              ),
            ).toList()
          ),
        )
      ]
      : [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _NotAvailable()
            ),
          ],
        )
      ],
    );
  }
}

class _ProviderSection extends StatelessWidget {
  _ProviderSection({
    required ProviderEnum providerEnum,
    required Providers providers,
  }) : 
  _providerEnum = providerEnum,
  _providers = providers;
  

  final ProviderEnum _providerEnum;
  final Providers _providers;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 10),
      elevation: 0,
      color: Colors.white12,
      child: Column(
        children: [
          _ProviderTypeTitle(providerEnum: _providerEnum),
          Padding(
            padding: const EdgeInsets.only(right: 6, left: 6, bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._providers.getByEnum(_providerEnum).map((provider) => 
                  _Provider(provider: provider)
                ).toList()
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _ProviderTypeTitle extends StatelessWidget {
  _ProviderTypeTitle({
    required ProviderEnum providerEnum,
  }) : 
  _providerEnum = providerEnum;

  final ProviderEnum _providerEnum;

  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    getProviderLocale() {
      switch (_providerEnum) {
        case ProviderEnum.rent:
          return locale.rent;
        case ProviderEnum.buy:
          return locale.buy;
        case ProviderEnum.streaming:
          return locale.streaming;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        getProviderLocale(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _Provider extends StatelessWidget {
  _Provider({
    required Provider provider,
  }) : 
  _provider = provider; 

  final Provider _provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: XImage(
        url: _provider.image, 
        width: 35, 
        height: 35,
        radius: 10,
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = getAppLocale(context);

    return SizedBox(
      height: 73,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale.notAvailable,
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}