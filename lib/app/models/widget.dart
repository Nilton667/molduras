import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:molduras/app/util/global.dart';
import './../util/theme_config.dart';

//Widgets globais
class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

//Widget de carregamento
Widget getCarregameto() {
  return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              themeData.themeColor,
            ),
          ),
        ],
      ));
}

//Widget nenhum resultado encontrado!
Widget emptyResult() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: Icon(
            LineIcons.fileAlt,
            size: 58.0,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Nenhum resultado encontrado!',
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}

//Lista de artigos vertical
Widget getArtigo(List data, int index) {
  return Card(
    child: InkWell(
      onTap: () {
        Get.toNamed(
          "/ArtigoId?id=${data[index]['id']}&nome=${data[index]['nome']}",
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:
                host + '../../publico/img/artigos/' + data[index]['imagem'],
            imageBuilder: (context, imageProvider) => Container(
              height: 110.0,
              width: Get.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              height: 110.0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    themeData.themeColor,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 110.0,
              color: Color.fromRGBO(0, 0, 0, 0.1),
              child: Center(child: Icon(Icons.error, color: Colors.grey)),
            ),
          ),
          Container(
            height: 65.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    data[index]['nome'],
                    style: TextStyle(fontSize: 14.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0),
                  child: Text(
                    numberFormat(data[index]['preco']),
                    style: TextStyle(fontSize: 12.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
