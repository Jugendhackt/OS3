import 'dart:async';

import 'package:angular/angular.dart';

@Component(
  selector: 'home',
  template: '''
  <h1>This is a placeholder</h1>
  
  ''',
  directives: [coreDirectives],
)
class HomeComponent implements OnInit {
  Future<void> ngOnInit() async {}
}
