import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

/*
import 'package:firebase/firestore.dart' as fs;*/

@Injectable()
class BService {
  fb.User user;

  BrowserClient client;

  BService() {
    client = new BrowserClient();
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

  String _token = null;
  final String server = 'https://151.216.10.58:443';

  Future<String> getSite(int siteId) async {
    var url = server + '/site/$siteId';
    var res = await client.get(url, headers: {'token': _token});
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');
    return res.body;
  }

  Future<String> getLayout(int layoutId) async {
    var url = server + '/layout/$layoutId';
    var res = await client.get(url, headers: {'token': _token});
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');
    return res.body;
  }

  Future<String> getData(int datadId) async {
    var url = server + '/datad/$datadId';
    var res = await client.get(url, headers: {'token': _token});
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');
    return res.body;
  }

  Future<String> login(String username, String password) async {
    _token = (new Uuid().v4()).toString();
    print(_token);
    /* var url = server + '/auth/login';
    var client = new BrowserClient();

    var request = new http.Request('POST', Uri.parse(url));
    var body = {'username': username, 'password': password, 'token': _token};
//  request.headers[HttpHeaders.CONTENT_TYPE] = 'application/json; charset=utf-8';
*/ /*
    request.headers[HttpHeaders.authorizationHeader] = 'Basic 021215421fbe4b0d27f:e74b71bbce';
*/ /*
    request.bodyFields = body;
    String res = '';

    await client
        .send(request)
        .then((response) => response.stream
            .bytesToString()
            .then((value) => res = value.toString()))
        .catchError((error) => print(error.toString()));*/
    var url = server + '/auth/login';
    var res = await client.post(url,
        body: {'username': username, 'password': password, 'token': _token});
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    /*  HttpRequest req = await HttpRequest.postFormData(server + '/auth/login',
        {'username': username, 'password': password, 'token': _token});
    print(req.response);*/

    return res.body;
  }

  Future<String> register(String username, String password, String displayname,
      String email) async {
    _token = (new Uuid().v4()).toString();

    var url = server + '/auth/register';
    var res = await client.post(url, body: {
      'username': username,
      'password': password,
      'email': email,
      'displayname': displayname,
      'token': _token
    });
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');
    return res.body;

    /* HttpRequest reponse = await HttpRequest.postFormData(
        server + '/auth/register',
        {'username': username, 'password': password, 'token': _token});
    return reponse.response;*/
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
