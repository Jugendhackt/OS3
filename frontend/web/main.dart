import 'package:angular/angular.dart';
import 'package:atlive/app_component.template.dart' as ng;

import 'package:angular_router/angular_router.dart';
import 'main.template.dart' as self;

/*
import 'package:pwa/client.dart' as pwa;
*/

@GenerateInjector([routerProvidersHash, routerDirectives])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(
    ng.AppComponentNgFactory,
    createInjector: injector,
  );
}
