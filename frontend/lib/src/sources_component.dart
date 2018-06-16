import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;

@Component(
  selector: 'sources',
  template: '''
  <h1>Hi!</h1>
  
  ''',
  directives: [coreDirectives],
)
class SourcesComponent implements OnInit {
/*  String heroUrl(int id) =>
      paths.hero.toUrl(parameters: {paths.idParam: id.toString()});*/

  /* List<Hero> heroes;

  final HeroService _heroService;

  DashboardComponent(this._heroService);*/

  Future<void> ngOnInit() async {
    /*
    heroes = (await _heroService.getAll()).skip(1).take(4).toList();*/
  }
}
