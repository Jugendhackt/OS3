import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/layouts/image.dart';
import 'package:atlive/src/routes.dart';
/*import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;*/

@Component(
  selector: 'content',
  template:
      '''<div id="insert-here"></div><!--<img src="gs://cylos-school.appspot.com/users/xxredsolverxx@gmail.com/fruit.jpg">-->''',
  directives: [
    coreDirectives,
    formDirectives,
    materialDirectives,
    NgFor,
    NgIf,
    ImageComponent
  ],
  providers: const [materialProviders],
)
class ContentTile implements OnInit, OnDestroy {
  String uri = "thisistheuri";

  List htmlTable = [
    ['test'],
    ['test', 'test'],
    ['test'],
  ];

  ContentTile(this.routes, BService this.fbservice);

  final BService fbservice;
  final Routes routes;

  @Input()
  String code;

/*
  String layoutTemp = '';
*/

/*
  fs.DocumentSnapshot sourceSnapTemp;
*/
  String sourceData;
  String layoutData;

  void update() async {
    try {
      //CHANNEL
      if (code.split(';')[0].toLowerCase() == 's') {
        String layout = layoutData;

        /*       print(sourceSnapTemp.id);
        print(sourceSnapTemp.data());
*/
        var pieces = layout.split(':::');
        bool beforeList = true;
        String layoutToUse = '';
        Map lists = {};

        int listIndex = 0;

        for (String p in pieces) {
          if (beforeList) {
            layoutToUse += p;
          } else {
            layoutToUse += '###$listIndex###';
            lists[listIndex] = p;

            listIndex++;
          }
          beforeList = !beforeList;
        }
        Map sourceSnapTemp = json.decode(sourceData);

        for (var key in sourceSnapTemp.keys) {
          print(key);
          print(key.runtimeType);

          if (sourceSnapTemp[key] is String) {
            layoutToUse =
                layoutToUse.replaceAll('{{$key}}', sourceSnapTemp[key]);
          } else {}
        }

        String getField(String k, String field) =>
            k.split('#$field#').length == 3
                ? k.split('#$field#')[1].split('#$field#')[0].trim()
                : null;

        /* print(
            getField('#item# <div>{{title}}<br>{{body}}</div>#item#', 'item'));*/

        for (int i = 0; i < listIndex; i++) {
          String fillIn = '';
          try {
            String nll = lists[i];
            String data = getField(nll, 'data');
/*
            print(data);
*/

/*
            fs.QuerySnapshot dataSnap = await sourceRef.collection(data).get();
*/

            List dataListSnap = json.decode(sourceData)[data];

            List docs;

            String sort = getField(nll, 'sort');

            if (sort == null) {
              docs = dataListSnap;
            } else {
              docs = dataListSnap;

              docs.sort((a, b) {
                /* print(a.keys);
                return 0;*/
                return a[sort].toString().compareTo(b[sort].toString());
              });
            }

            String item = getField(nll, 'item');
            String divider = getField(nll, 'divider');

            int sIndex = 0;
            for (Map listDoc in docs) {
              String oneItem = item;
              for (var key in listDoc.keys) {
                if (listDoc[key] is String) {
                  oneItem = oneItem.replaceAll('{{$key}}', listDoc[key]);
                } else {}
              }
              fillIn = fillIn + oneItem;
              if (sIndex < docs.length - 1 && divider != null) {
                fillIn = fillIn + divider;
              }
              sIndex++;
            }
          } catch (e, st) {
            fillIn = e.toString() + ' - ' + st.toString();
          }
/*
          print('[[$i]] $fillIn');
*/

          layoutToUse = layoutToUse.replaceAll('###$i###', fillIn);
        }

        /*   if (layout.split('***').length == 3) {
          String item = layout.split('#item#')[1].split('#/item#')[0];
          String divider = '';
          if (layout.contains('#divider#')) {
            divider = layout.split('#divider#')[1].split('#/divider#')[0];
          }

          print('---');
          print(layout.split('***')[0].replaceAll('*', ''));

          fs.QuerySnapshot list = await sourceRef
              .collection(layout.split('***')[0].replaceAll('*', ''))
              .get();
          layout = '';

          int sIndex = 0;
          for (fs.DocumentSnapshot listDoc in list.docs) {
            String oneItem = item;
            for (var key in listDoc.data().keys) {
              if (listDoc.data()[key] is String) {
                oneItem = oneItem.replaceAll('{{$key}}', listDoc.data()[key]);
              } else {}
            }
            layout = layout + oneItem;
            if (sIndex < list.docs.length - 1) {
              layout = layout + divider;
            }
            sIndex++;
          }
        }*/

        Element el = window.document.querySelector('#' + key);

        if (code.split(';').length == 4) {
/*
          print(code);
*/
          List<String> meta2 = code.split(';')[3].split('-');
          String style = '';
          if (meta2[0].length > 0) {
            style += 'min-width: ${meta2[0]}px;';
          }
          if (meta2[1].length > 0) {
            style += 'max-width: ${meta2[1]}px;';
          }

          print(style);
          el.setAttribute('style', style);
        }

        /*     Uri url = await fbservice
            .getStorageUrl('users/xxredsolverxx@gmail.com/fruit.jpg');
        print('STORAGEURL');*/

        el.setInnerHtml(layoutToUse /*+ '''<img src="$url">'''*/,
            treeSanitizer: NodeTreeSanitizer.trusted);
      }

      //SOURCE
    } catch (e, st) {
      Element el = window.document.querySelector('#' + key);

      el.setInnerHtml(loadingIndicator,
          treeSanitizer: NodeTreeSanitizer.trusted);
    }
  }

  String key = '';

/*  Stream<fs.DocumentSnapshot> layoutStream;
  Stream<fs.DocumentSnapshot> sourceStream;*/
  /*var layoutSub;
  var sourceSub;*/
  String layoutRef;
  String sourceRef;

  Future<void> ngOnInit() async {
    /*   print('-');
    print(code);
    print('-');*/

    var rng = new Random();
    key = 'a' + rng.nextInt(99999999).toString();
    Element el = window.document.querySelector('#insert-here');

    /*  print(key);*/

    el.id = key;

    if (code.split(';')[0].toLowerCase() == 's') {
      el.innerHtml = loadingIndicator;

      layoutRef = code.split(';')[2];

      sourceRef = code.split(';')[1];
      layoutData = await fbservice.getLayout(int.parse(layoutRef));
      sourceData = await fbservice.getData(int.parse(sourceRef));
      update();

      /*print(layoutRef.path);
      layoutStream = layoutRef.onSnapshot;
      layoutSub = layoutStream.listen((querySnapshot) {
        layoutTemp = querySnapshot.get('layout');
        try {
          update();
        } catch (e) {}
      });

      print(sourceRef.path);
      sourceStream = sourceRef.onSnapshot;
      sourceSub = sourceStream.listen((querySnapshot) {
        sourceSnapTemp = querySnapshot;
        try {
          update();
        } catch (e) {}
      });*/
    } else if (code.split(';')[0].toLowerCase() == 'p') {
      List<String> meta = code.split(';');

      String style = '';

      style += 'min-width: ${meta[1]}px;max-width: ${meta[1]}px;';

      /*if (code.split(';').length == 2) {
        if (meta2[0].length > 0) {
        }
        if (meta2[1].length > 0) {
          style += '';
        }

        print(style);
        el.setAttribute('style', style);
      }*/
      el.setAttribute('style', style);

/*
      el.setInnerHtml( , treeSanitizer: NodeTreeSanitizer.trusted);
*/
    }
  }

  @override
  void ngOnDestroy() {
    print('ONDESTROY');

    /*fs.Firestore firestore = fb.firestore();

       fs.DocumentReference layoutRef =
        firestore.collection("layouts").doc(code.split(';')[2]); */

    /* try {
      layoutSub.cancel();
    } catch (e) {}
    try {
      sourceSub.cancel();
    } catch (e) {}*/
  }

  String loadingIndicator = '''<div class="sk-circle">
            <div class="sk-circle1 sk-child"></div>
            <div class="sk-circle2 sk-child"></div>
            <div class="sk-circle3 sk-child"></div>
            <div class="sk-circle4 sk-child"></div>
            <div class="sk-circle5 sk-child"></div>
            <div class="sk-circle6 sk-child"></div>
            <div class="sk-circle7 sk-child"></div>
            <div class="sk-circle8 sk-child"></div>
            <div class="sk-circle9 sk-child"></div>
            <div class="sk-circle10 sk-child"></div>
            <div class="sk-circle11 sk-child"></div>
            <div class="sk-circle12 sk-child"></div>
        </div>''';
}
