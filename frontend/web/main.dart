import 'package:angular/angular.dart';
import 'package:atlive/app_component.dart';
import 'package:atlive/app_component.template.dart' as ng;

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

import 'package:angular_router/angular_router.dart';
import 'main.template.dart' as self;
import 'package:http/browser_client.dart';

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

void main() {
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

  runApp(ng.AppComponentNgFactory, createInjector: injector);
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
