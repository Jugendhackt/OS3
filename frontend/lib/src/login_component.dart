import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/routes.dart';

@Component(
  selector: 'login',
  template: '''
  <div style="padding: 20px;">
  <table>
  <tr>
    <td><material-input name="username" id="username" autoFocus type="text" required requiredErrorMsg="Please enter a username" [(ngModel)]="username" label="Username" style=" padding-right: 20px"></material-input></td>
    <td><material-input type="password" name="password" id="password" required requiredErrorMsg="Please enter a password" [(ngModel)]="password" label="Password" ></material-input></td> 
  </tr>
    <div *ngIf="showError" style="color: red;">{{error}}</div>
    <div *ngIf="loading">
    <material-spinner style="border-color: #C5002B; margin: 20px;"></material-spinner> Logging in...</div>
    

  <tr>
    <td> <material-button type="submit" (trigger)="login()">
    Login
</material-button></td>
    <td> <material-checkbox style="alignment: center;" [(checked)]="stayLoggedIn">
    Stay logged in
</material-checkbox></td> 
  </tr>
</table>
    
    
    
  

</div>
<!--<material-button (trigger)="fbservice.signInWithGoogle()">
    Google+
</material-button>-->

    

  
  ''',
  directives: [
    coreDirectives,
    materialDirectives,
    materialInputDirectives,
    formDirectives
  ],
  providers: const [materialProviders],
)
class LoginComponent implements OnInit, OnDestroy {
  final BService fbservice;
  @Input()
  String username = '';
  @Input()
  String password = '';

  Future<void> ngOnInit() async {
    showError = false;
  }

  Future<void> ngOnDestroy() async {
    showError = false;
  }

  bool showError = false;
  bool stayLoggedIn = false;
  bool loading = false;

  checkedChange(bool newState) {
    stayLoggedIn = newState;
  }

/*  @Event()
  bool visibleVal;*/

  final Router _router;
  final Routes routes;

  LoginComponent(this.routes, this._router, this.fbservice);

  /* @Input()
  bool loggedIn;*/

  final _loginChange = new StreamController<bool>();

  @Output()
  Stream<bool> get loggedInChange => _loginChange.stream;

  void loginWithGoogle() async {
    /* fb.Auth auth = fb.auth();
    try {
      fb.User user = await auth.(email, password);

      print(user.email);

        auth.currentUser.updateProfile(fb.UserProfile(
          displayName: 'redsolver',
          photoURL:
              'https://yt3.ggpht.com/-4T-7_vJXOG8/AAAAAAAAAAI/AAAAAAAAAAA/K38Aw9bjyxU/s88-c-k-no-mo-rj-c0xffffff/photo.jpg'));
       _loginChange.add(true);
      _router.navigateByUrl(_router.current.toUrl(), reload: true);
    } catch (e) {
      print(e);
    }*/
  }

  String error = "";

  /*
  bool loading = false;*/

  void login() async {
    print(stayLoggedIn);

    loading = true;

/*
    await Future.delayed(const Duration(seconds: 2), () => "2");
*/

    String res = await fbservice.login(username, password, stayLoggedIn);

    if (res.contains('Login unsuccessful.')) {
      error = res;
      showError = true;
    } else if (res.contains('Password wrong.')) {
      error = 'Invalid username or password.';
      showError = true;
    } else {
      /* error=res;*/
      showError = false;
      _loginChange.add(true);
    }

    print(res);

    loading = false;
    /* fb.Auth auth = fb.auth();
    try {
      fb.User user = await auth.signInWithEmailAndPassword(email, password);
      print(user.email);
        auth.currentUser.updateProfile(fb.UserProfile(
          displayName: 'redsolver',
          photoURL:
              'https://yt3.ggpht.com/-4T-7_vJXOG8/AAAAAAAAAAI/AAAAAAAAAAA/K38Aw9bjyxU/s88-c-k-no-mo-rj-c0xffffff/photo.jpg'));
      _loginChange.add(true);
      _router.navigateByUrl(_router.current.toUrl(), reload: true);
    } catch (e) {
      showError = true;
      if (e.toString().contains("badly formatted")) {
        error = "Ungültige E-mail";
      } else if (e.toString().contains(
          "The password is invalid or the user does not have a password")) {
        error = "Ungültiges Passwort";
      } else if (e
          .toString()
          .contains("There is no user record corresponding to this identifi")) {
        error = "Ungültiger Benutzer";
      } else {
        error = "Fehler";
      }

      error = "Hi";


      print(e);
    }*/
  }
}
