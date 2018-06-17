import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'imagec',
  template: '''
  IMAGEC

  ''',
  directives: [coreDirectives, formDirectives, materialDirectives, NgFor, NgIf],
  providers: const [materialProviders],
)
class ImageComponent implements OnInit {
  /*List htmlTable = [
*/ /*    ['test'],
    ['test', 'test'],
    ['test'],*/ /*
  ];*/
  Future<void> ngOnInit() async {
    print(';;;');
    print(uri);
    print(';;;');
    /* fs.Firestore firestore = fb.firestore();
    fs.DocumentReference ref =
    firestore.collection("sites").doc('start_sources');

    ref.onSnapshot.listen((querySnapshot) {
      print(querySnapshot.get('layout'));
      _interpreter(querySnapshot.get('layout'));
    });*/

    /*
    heroes = (await _heroService.getAll()).skip(1).take(4).toList();*/
  }

  @Input()
  String uri;
}
