import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:uuid/uuid.dart';
import 'package:http/browser_client.dart';
import 'package:cookie/cookie.dart' as cookie;

/*
import 'package:firebase/firestore.dart' as fs;*/

@Injectable()
class BService {
  /*String pageTitle = 'OS3 Demo';*/

  /*
  final String server = 'https://151.216.10.58:443';*/
  final String server = 'https://localhost:443';

  User user;

  BrowserClient client;

  BService() {
    client = new BrowserClient();
    checkAutoLogin();
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

  Future<String> getSite(String siteId) async {
    document.title = 'Loading...';
/*
    pageTitle = siteId;
*/

    var url = server + '/site/$siteId.oll';
    var res = await client.get(url, headers: {'token': _token});
    /* print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');*/
    print(res.request.headers);
    print(res.headers);
    return res.body;
  }

  Future<String> getLayout(String layoutId) async {
    var url = server + '/layout/$layoutId.html';
    var res = await client.get(url, headers: {'token': _token});
    /*  print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');*/
    return res.body;
  }

  Future<String> getData(String dataId) async {
    var url = server + '/data/$dataId.json';
    var res = await client.get(url, headers: {'token': _token});
    /* print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');*/
    return res.body;
  }

  logout() async {
/*
    await cookie.remove('sessionToken', path: '/');
*/
    print('AutoLoginRemove');

    _token = null;
    await cookie.remove('autoLoginToken', path: '/');
    user = null;
  }

  Future<String> login(String username, String password, bool persist) async {
    _token = (new Uuid().v4()).toString();
    print(_token);
    String autoLoginToken;

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

    var body = {'username': username, 'password': password, 'token': _token};
    if (persist) {
      autoLoginToken = (new Uuid().v4()).toString() +
          (new Uuid().v4()).toString() +
          (new Uuid().v4()).toString();

      body['autoLoginToken'] = autoLoginToken;
    }

    var res = await client.post(url, body: body);
/*    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');*/
    if (res.body.contains('Login successful.')) {
/*
      await cookie.set('sessionToken', _token, path: '/', expires: 0.1);
*/
      user = new User(username);
      if (persist) {
        await cookie.set(
          'autoLoginToken',
          autoLoginToken,
          expires: 30,
          path: '/',
        );
      }
    }

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
/*    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');*/
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

  /*Future<Uri>*/
  getStorageUrl(String path) async {
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

  void checkAutoLogin() async {
    String autoLoginToken = await cookie.get('autoLoginToken');
    if (autoLoginToken != null) {
      print('TRY AUTO LOGIN');
      String token = (new Uuid().v4()).toString();
      var url = server + '/auth/tokenLogin';

      var body = {'autoLoginToken': autoLoginToken, 'token': token};
      var res = await client.post(url, body: body);
      print(res.body);
      if (res.body.startsWith('SUCCESS_')) {
        _token = token;
        user = new User(res.body.substring(8));
      } else {}
    }
  }
}

class User {
  String username;
  String displayName;
  String photoURL;
  String email;

  User(this.username);
}
