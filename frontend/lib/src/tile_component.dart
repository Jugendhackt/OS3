import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:atlive/src/layouts/content.dart';
import 'package:atlive/src/site_part.dart';

@Component(
  selector: 'tile',
  template: '''
  <tr *ngFor="let part of downPart.trchildren.values" class="row">
  <tile [downPart]="part"></tile>
    </tr>
    <td *ngFor="let part of downPart.tdchildren.values" class="column">
<tile [downPart]="part"></tile>    
</td>
    <div *ngIf="downPart.value!=null" class="tile">
    
      <content [code]="downPart.value"></content>

    </div>
  
  
  ''',
  directives: [
    coreDirectives,
    formDirectives,
    materialDirectives,
    NgFor,
    NgIf,
    TileComponent,
    ContentTile
  ],
  providers: const [materialProviders],
)
class TileComponent implements OnInit {
  /*List htmlTable = [
*/ /*    ['test'],
    ['test', 'test'],
    ['test'],*/ /*
  ];*/
  Future<void> ngOnInit() async {
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
  SitePart downPart;
}
