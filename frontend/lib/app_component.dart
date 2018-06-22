import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/login_component.dart';
import 'package:atlive/src/register_component.dart';
import 'package:atlive/src/routes.dart';

import 'package:angular_router/angular_router.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'atlive-shell',
  styleUrls: [
    'app_component.css',
    'package:angular_components/app_layout/layout.scss.css',
  ],
  templateUrl: 'app_component.html',
  directives: [
    routerDirectives,
    materialDirectives,
    LoginComponent,
    RegisterComponent,
    formDirectives,
    NgIf,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
    MaterialToggleComponent,
  ],
  providers: const [
    /*
    const ClassProvider(HeroService),*/
    const ClassProvider(Routes),
    materialProviders,
    BService
  ],
)
class AppComponent implements OnInit {
  AppComponent(this.routes, BService this.fbservice);

  final BService fbservice;

  String imageUrl = 'assets/profile_picture.png';

  /* bool customWidth = false;
  bool end = false;
  bool overlay = false;*/

  void pop() {
    showPopup = false;
  }

  int availableWidth;

  bool loggedIn = false;

  bool mobile = false;

  RelativePosition get popupPosition => RelativePosition.AdjacentBottomRight;

  bool showPopup = false;
  bool showRegister = false;

  final title = 'OS3 Demo';

  void logout() async {
    print('Login Start');
    await fbservice.signOut();
    loggedIn = false;
    showPopup = false;
  }

  void loginChange(bool change) {
    loggedIn = change;
    showPopup = false;
/*
    print(change);
*/
  }

  final Routes routes;

  void ngOnInit() {
    getImage();
    availableWidth = window.innerWidth;
/*    print(window.innerWidth);
    print(window.screen.width);*/
/*
    print(window.screen.pix);
*/

    mobile = availableWidth < 750 ? true : false;

    loggedIn = fbservice.user == null ? false : true;

    /* fs.Firestore firestore = fb.firestore();

    auth = fb.auth();
    _login();

    fs.CollectionReference ref = firestore.collection("messages");

    ref.onSnapshot.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (change.type == "added") {
          print(change.doc.data().toString());
        }
      });
    });*/
  }

  void getImage() async {
    // call the web server asynchronously
    /*   var request = await HttpRequest.getString(url);*/

    /*   print(request);*/
    /*   Element el = window.document.querySelector('#ItemPreview');

    var str = "Hello world";
    var base64 = window.btoa(json.decode(request)['data']);

    el.setAttribute('src', 'data:image/png;base64,' + base64);*/
  }
}
