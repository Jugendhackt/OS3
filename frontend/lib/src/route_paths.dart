import 'package:angular_router/angular_router.dart';

final start = new RoutePath(path: '/start');
final home = new RoutePath(path: '/home');
final sources = new RoutePath(path: '/sources');

const sourceParam = 'sourceId';
final source = new RoutePath(path: '/${sources.path}/:$sourceParam');

String getId(Map<String, String> parameters) {
  final id = parameters[sourceParam];
  return id == null ? null : id;
}
