import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:uuid/uuid.dart';

/*
import 'package:firebase/firestore.dart' as fs;*/

@Injectable()
class BService {
  fb.User user;

  BService() {
/*
    fb.messaging().requestPermission();
*/
    /*   fb.initializeApp(
      apiKey: "AIzaSyDd0ERAp3BnKC1WzhmLut5Q5zkgtcAwEjk",
      name: "Atlive",
      authDomain: "cylos-school.firebaseapp.com",
      databaseURL: "https://cylos-school.firebaseio.com",
      projectId: "cylos-school",
      storageBucket: "cylos-school.appspot.com",
      messagingSenderId: "530500442623",
    );*/

    /*messaging = fb.messaging();
    messaging.usePublicVapidKey(
        "BLwQy2bWPKiyCTbWi5Z-y5LcfeXS9oYG9zdg01RktsGeH5SZjRyNpObvXoZk2q9Py-8FvWs25RhWjDUdnJxxhxo");
*/
/*
    requestPermission();
*/

/*
    firestore.settings(new fs.Settings(timestamps));
*/

    /* _fbGithubAuthProvider = new fb.GithubAuthProvider();
    _fbTwitterAuthProvider = new fb.TwitterAuthProvider();*/
  }

  String token = null;

  login(String username, String password) async {
    token = (new Uuid().v4()).toString();

    HttpRequest reponse = await HttpRequest.postFormData(
        'http://localhost:443/auth/login',
        {'username': username, 'password': password, 'token': token});
    return reponse.response;
  }

  requestPermission() async {
    /*  await messaging.requestPermission();

    print(messaging.getToken());

    messaging.onTokenRefresh.listen((n) {});*/
  }

  Future<Uri> getStorageUrl(String path) async {
    /*   print('STORAGEURLSTART');
    try {
      var ref = storage.ref(path);
      print('STORAGEURLSTAR2T2');
      */ /*  print(ref);
    print('DURL' + (await ref.getDownloadURL()).toString());*/ /*

      */ /*await .catchError(() {}).then((uri) {
        x = uri;
      });*/ /*

      var x = await ref.getDownloadURL();
      print(x);

      return x;
    } catch (e, st) {
      print(e + st);
      return new Uri(scheme: '/assets/forest.jpg');
    }*/
  }

  /* void _authChanged(fb.User fbUser) {
    user = fbUser;
  }*/

  Future signInWithGoogle() async {
    /* try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
    } catch (error) {
      print("$runtimeType::login() -- $error");
    }*/
  }

/*  Future signInWithGithub() async {
    try {
      await _fbAuth.signInWithPopup(_fbGithubAuthProvider);
    } catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }

  Future signInWithTwitter() async {
    try {
      await _fbAuth.signInWithPopup(_fbTwitterAuthProvider);
    } catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }*/

  void signOut() {
/*
    _fbAuth.signOut();
*/
  }
}
