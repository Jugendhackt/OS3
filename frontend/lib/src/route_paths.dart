import 'package:angular_router/angular_router.dart';

final start = new RoutePath(path: '/start');
final home = new RoutePath(path: '/home');
final files = new RoutePath(path: '/files');
final messages = new RoutePath(path: '/messages');
final groups = new RoutePath(path: '/groups');

final sources = new RoutePath(path: '/sources');

final sites = new RoutePath(path: '/site');

const sourceParam = 'sourceId';
final source = new RoutePath(path: '/${sources.path}/:$sourceParam');

const siteParam = 'siteId';
final site = new RoutePath(path: '/${sites.path}/:$siteParam');

String getSiteId(Map<String, String> parameters) {
  final id = parameters[siteParam];
  return id == null ? null : id;
}

String getId(Map<String, String> parameters) {
  final id = parameters[sourceParam];
  return id == null ? null : id;
}
