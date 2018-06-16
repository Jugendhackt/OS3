import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'source-tile',
  template: '''
  <!--<h1>{{sourceContent}}</h1>-->
  <!--<div style="max-width:100px; height: 200px;">-->
  
<!--  {{idNext}}
-->  

{{idCode}}
<material-button raised *ngFor="let sourceTile of sourceTiles.values">
    <material-icon icon="lightbulb_outline"></material-icon>
    {{sourceTile}}
</material-button>
 <!-- <a style="word-wrap: break-word;margin-top: 22px"  size="medium">&lt;!&ndash;  [class.selected]="hero === selected"
  
        (click)="onSelect(hero)"&ndash;&gt;
        <div style="background-color: green">
        &lt;!&ndash;<>&ndash;&gt;{{sourceTile}}&lt;!&ndash;</a> &ndash;&gt;
   </div>
   </a>
   <a style="word-wrap: break-word;">Hello, whats up? 1234234324324324324234324324234</a>-->
   <!--</div>-->
<!--   <material-button>Simple card</material-button>

<material-button>Simple card</material-button>-->

  ''',
  directives: [
    coreDirectives,
    materialDirectives,
    NgFor,
  ],
  providers: const [materialProviders],
)
class SourceComponent implements /* OnActivate, */ OnInit {
/*  String heroUrl(int id) =>
      paths.hero.toUrl(parameters: {paths.idParam: id.toString()});*/

  Map<String, String> sourceTiles = new Map();

/*
  final HeroService _heroService;

  DashboardComponent(this._heroService);*/

  String sourceContent = null;

/*
  @Input('myId')
*/
  @Input()
  String idCode = 'SETME!';

  Future<void> ngOnInit() async {
    print('NGONINIT');
    print(idCode);

    /*fs.Firestore firestore = fb.firestore();
    fs.CollectionReference ref =
        firestore.collection("sources").doc(idCode).collection('tiles');*/

    /* ref.onSnapshot.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        print(change.type);
        print(change.doc.id);
        if (change.type == "added") {
          sourceTiles[change.doc.id] = (change.doc.data().toString());

          print(change.doc.data().toString());
        }
        if (change.type == "modified") {
          sourceTiles[change.doc.id] = (change.doc.data().toString());

          print(change.doc.data().toString());
        }
      });
    });*/
  }

/*@override
  Future<void> onActivate(_, RouterState current) async {
    print('ACTIVE');

    id = paths.getId(current.parameters);

    fs.Firestore firestore = fb.firestore();
    fs.CollectionReference ref =
        firestore.collection("sources").doc(id).collection('tiles');

    ref.onSnapshot.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        print(change.type);
        print(change.doc.id);
        if (change.type == "added") {
          sourceTiles[change.doc.id] = (change.doc.data().toString());

          print(change.doc.data().toString());
        }
        if (change.type == "modified") {
          sourceTiles[change.doc.id] = (change.doc.data().toString());

          print(change.doc.data().toString());
        }
      });
    });*/
/* ref.onSnapshot.listen((querySnapshot) {
      */ /*
      sourceContent = querySnapshot.data().toString();*/ /*
      print(querySnapshot.data().toString());

        for (fs.DocumentSnapshot k in querySnapshot.) {
        print(k.data());

        sourceTiles.add(k.data().toString());

      }
      */ /*querySnapshot.docChanges.forEach((change) {
        if (change.type == "added") {
          print(change.doc.data().toString());
        }
      });*/ /*
    });*/
}
