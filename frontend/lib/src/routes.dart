import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;

/*import 'hero_list_component.template.dart' as hlct;
import 'hero_component.template.dart' as hct;
import 'dashboard_component.template.dart' as dct;*/
import 'start_component.template.dart' as start_ct;
import 'home_component.template.dart' as home_ct;

import 'source_component.template.dart' as source_ct;
import 'sources_component.template.dart' as sources_ct;

import 'site_component.template.dart' as site_ct;

@Injectable()
class Routes {
  static final _start = new RouteDefinition(
    routePath: paths.start,
    component: start_ct.StartComponentNgFactory,
  );
  static final _home = new RouteDefinition(
    routePath: paths.home,
    component: home_ct.HomeComponentNgFactory,
  );
  static final _sources = new RouteDefinition(
    routePath: paths.sources,
    component: sources_ct.SourcesComponentNgFactory,
  );
  static final _source = new RouteDefinition(
    routePath: paths.source,
    component: source_ct.SourceComponentNgFactory,
  );

/*   static final _dashboard = new RouteDefinition(
    routePath: paths.dashboard,
    component: dct.DashboardComponentNgFactory,
  );*/

  static final _site = new RouteDefinition(
    routePath: paths.site,
    component: site_ct.SiteComponentNgFactory,
  );

  RouteDefinition get start => _start;

  RouteDefinition get home => _home;

  RouteDefinition get source => _source;

  RouteDefinition get sources => _sources;

  RouteDefinition get site => _site;

  /* RouteDefinition get dashboard => _dashboard;

  RouteDefinition get hero => _hero;*/

  final List<RouteDefinition> all = [
    new RouteDefinition.redirect(path: '', redirectTo: paths.start.toUrl()),
    _start,
    _home,
    _source,
    _sources,
    _site

    /*  _hero,
    _heroes,*/
  ];
}
