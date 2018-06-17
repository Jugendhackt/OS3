import 'package:angular/angular.dart';
import 'package:atlive/app_component.template.dart' as ng;

import 'package:angular_router/angular_router.dart';
import 'main.template.dart' as self;

/*
import 'package:pwa/client.dart' as pwa;
*/

@GenerateInjector(
  routerProvidersHash, // Y routerProviders in production
/*
  const ClassProvider(BrowserClient),
*/
)
InjectorFactory injector = self.injector$Injector;
/*
InjectorFactory inj = new Provider('pwa.Client', useValue: new pwa.Client()).inj;
*/

/*void main() {
  bootstrap(AppComponent, [
    provide(Client, useFactory: () => , deps: [])
  ]);
}*/
/*
final String server = 'https://151.216.10.58';
*/

void main() {
  /* var client = new BrowserClient();
  var url = server + '/auth/login';
  var response =
      await client.post(url, body: {'name': 'doodle', 'color': 'blue'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');*/

/*  fb.initializeApp(
      apiKey: "AIzaSyDd0ERAp3BnKC1WzhmLut5Q5zkgtcAwEjk",
      authDomain: "cylos-school.firebaseapp.com",
      databaseURL: "https://cylos-school.firebaseio.com",
      projectId: "cylos-school",
      storageBucket: "");*/

  // ignore: invocation_of_non_function
  /*runAppLegacy(AppComponent, createInjectorFromProviders: [
    injector,
    new Provider('pwa.Client', useValue: new pwa.Client()),
  ]);*/
  /* if (sw.isSupported) {
    sw.register('sw.dart.js');
  } else {
    print('ServiceWorkers are not supported.');
  }*/
/*
  new pwa.Client();
*/
/*
  runApp(pwa.Client());
*/

  runApp(
    ng.AppComponentNgFactory,
    createInjector: injector,
  );
/*  bootstrap(AppComponent, [
    new Provider('pwa.Client', useValue: new pwa.Client()),
  ]);*/

/*
  new Provider(pwa.Client, useValue: new pwa.Client());
*/

/*
  runApp(ng.AppComponentNgFactory, createInjector: injector);
*/
}
