import 'dart:async';

import 'package:angular/angular.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/routes.dart';

@Component(
  selector: 'state-change',
  template: '''
  <h1>The authentication state is changeing...</h1>
  This site shouldn't be visible :)
  If it is visible, then your connection isn't good enough for using this system
  
  ''',
  directives: [coreDirectives],
)
class StateChangeComponent {
  StateChangeComponent(this.routes, BService this.fbservice);

  final BService fbservice;
  final Routes routes;

/* List<User> users;

  Future<void> ngOnInit() async {
    users = await fbservice.listUsers();
  }*/
}
