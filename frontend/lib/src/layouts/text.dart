import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:atlive/src/firebase_service.dart';
import 'package:atlive/src/layouts/image.dart';
import 'package:atlive/src/routes.dart';
import 'package:atlive/src/site_part.dart';
import 'package:atlive/src/source_component.dart';
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
class ContentTile /*implements OnInit, OnDestroy*/ {
  /* String uri = "thisistheuri";

  */ /*List htmlTable = [
*/ /* */ /*    ['test'],
    ['test', 'test'],
    ['test'],*/ /* */ /*
  ];*/ /*
  ContentTile(this.routes, FBService this.fbservice);

  final FBService fbservice;
  final Routes routes;

  @Input()
  String code;

  String layoutTemp = '';
  fs.DocumentSnapshot sourceSnapTemp;

  void update() async {
    try {
      //CHANNEL
      if (code.split(';')[0].toLowerCase() == 's') {
        String layout = layoutTemp;
        print(sourceSnapTemp.id);
        print(sourceSnapTemp.data());

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

        for (var key in sourceSnapTemp.data().keys) {
          print(key);
          print(key.runtimeType);

          if (sourceSnapTemp.data()[key] is String) {
            layoutToUse =
                layoutToUse.replaceAll('{{$key}}', sourceSnapTemp.data()[key]);
          } else {}
        }

        String getField(String k, String field) =>
            k.split('#$field#').length == 3
                ? k.split('#$field#')[1].split('#$field#')[0].trim()
                : null;

        print(
            getField('#item# <div>{{title}}<br>{{body}}</div>#item#', 'item'));

        for (int i = 0; i < listIndex; i++) {
          String fillIn = '';
          try {
            String nll = lists[i];
            String data = getField(nll, 'data');
            print(data);

            fs.QuerySnapshot dataSnap = await sourceRef.collection(data).get();

            List docs;

            String sort = getField(nll, 'sort');

            if (sort == null) {
              docs = dataSnap.docs;
            } else {
              print(sort);

              docs = dataSnap.docs;
              print(docs);

              docs.sort((a, b) {
                */ /* print(a.keys);
                return 0;*/ /*
                return a
                    .data()[sort]
                    .toString()
                    .compareTo(b.data()[sort].toString());
              });
              print(docs);
            }

            String item = getField(nll, 'item');
            String divider = getField(nll, 'divider');

            int sIndex = 0;
            for (fs.DocumentSnapshot listDoc in docs) {
              String oneItem = item;
              for (var key in listDoc.data().keys) {
                if (listDoc.data()[key] is String) {
                  oneItem = oneItem.replaceAll('{{$key}}', listDoc.data()[key]);
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
          print('[[$i]] $fillIn');

          layoutToUse = layoutToUse.replaceAll('###$i###', fillIn);
        }

        */ /*   if (layout.split('***').length == 3) {
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
        }*/ /*

        Element el = window.document.querySelector('#' + key);

        if (code.split(';').length == 4) {
          print(code);
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

        */ /*     Uri url = await fbservice
            .getStorageUrl('users/xxredsolverxx@gmail.com/fruit.jpg');
        print('STORAGEURL');*/ /*

        el.setInnerHtml(layoutToUse */ /*+ '''<img src="$url">'''*/ /*,
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

  Stream<fs.DocumentSnapshot> layoutStream;
  Stream<fs.DocumentSnapshot> sourceStream;
  var layoutSub;
  var sourceSub;
  fs.DocumentReference layoutRef;
  fs.DocumentReference sourceRef;

  Future<void> ngOnInit() async {
    var rng = new Random();
    key = 'a' + rng.nextInt(99999999).toString();
    Element el = window.document.querySelector('#insert-here');

    print(key);

    el.id = key;

    if (code.split(';')[0].toLowerCase() == 's') {
      el.innerHtml = loadingIndicator;
      fs.Firestore firestore = fbservice.firestore;

      layoutRef = firestore.collection("layouts").doc(code.split(';')[2]);

      sourceRef = firestore.collection("sources").doc(code.split(';')[1]);

      print(layoutRef.path);
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
      });
    } else if (code.split(';')[0].toLowerCase() == 'p') {
      List<String> meta = code.split(';');

      String style = '';

      style += 'min-width: ${meta[1]}px;max-width: ${meta[1]}px;';

      */ /*if (code.split(';').length == 2) {
        if (meta2[0].length > 0) {
        }
        if (meta2[1].length > 0) {
          style += '';
        }

        print(style);
        el.setAttribute('style', style);
      }*/ /*
      el.setAttribute('style', style);

*/ /*
      el.setInnerHtml( , treeSanitizer: NodeTreeSanitizer.trusted);
*/ /*
    }

    */ /* fs.Firestore firestore = fb.firestore();

    fs.DocumentReference layoutRef =
        firestore.collection("layouts").doc(code.split(';')[2]);

    if (code.split(';')[0].toLowerCase() == 's') {



      fs.DocumentSnapshot layoutSnap = await layoutRef.get();

      fs.DocumentReference sourceRef =
          firestore.collection("sources").doc(code.split(';')[1]);
      fs.DocumentSnapshot sourceSnap = await sourceRef.get();

      String layout = layoutSnap.get('layout');

      for (String key in sourceSnap.data().keys) {
        layout = layout.replaceAll('{{$key}}', sourceSnap.data()[key]);
      }

      Element el = window.document.querySelector('#insert-here');

      el.id = 'hello';

      if (code.split(';').length == 4) {
        print(code);
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

      el.setInnerHtml(layout, treeSanitizer: NodeTreeSanitizer.trusted);
    }*/ /*
  }

  @override
  void ngOnDestroy() {
    print('ONDESTROY');
*/ /*
    fs.Firestore firestore = fb.firestore();
*/ /*
    */ /*  fs.DocumentReference layoutRef =
        firestore.collection("layouts").doc(code.split(';')[2]);*/ /*

    try {
      layoutSub.cancel();
    } catch (e) {}
    try {
      sourceSub.cancel();
    } catch (e) {}
  }

*/ /*
  String loadingIndicator = '''<div class="spinner"></div>''';
*/ /*
  String loadingIndicator = '''<div class="sk-cube-grid">
  <div class="sk-cube sk-cube1"></div>
  <div class="sk-cube sk-cube2"></div>
  <div class="sk-cube sk-cube3"></div>
  <div class="sk-cube sk-cube4"></div>
  <div class="sk-cube sk-cube5"></div>
  <div class="sk-cube sk-cube6"></div>
  <div class="sk-cube sk-cube7"></div>
  <div class="sk-cube sk-cube8"></div>
  <div class="sk-cube sk-cube9"></div>
  </div>''';*/
}
