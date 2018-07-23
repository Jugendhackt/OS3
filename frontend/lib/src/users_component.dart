import 'dart:async';

import 'package:angular/angular.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/routes.dart';

@Component(
  selector: 'users',
  template: '''
  <h1>Users</h1>
  <material-button raised *ngFor="let user of users">
    {{user.username}}
</material-button>
  
  ''',
  directives: [coreDirectives],
)
class UsersComponent implements OnInit {
  UsersComponent(this.routes, BService this.fbservice);

  final BService fbservice;
  final Routes routes;

  List<User> users;

  Future<void> ngOnInit() async {
    users = await fbservice.listUsers();
  }
}
