import 'dart:async';
import 'dart:html';

import 'package:angular_router/angular_router.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/routes.dart';
import 'package:atlive/src/site_part.dart';
import 'package:atlive/src/source_component.dart';
import 'package:atlive/src/tile_component.dart';

@Component(
  selector: 'start',
  templateUrl: 'start_component.html',
  directives: [
    coreDirectives,
    materialDirectives,
    NgFor,
    NgIf,
    formDirectives,
    SourceComponent,
    TileComponent
  ],
  providers: const [materialProviders],
)
class StartComponent implements OnInit {
  StartComponent(this.routes, BService this.fbservice);

  final BService fbservice;
  final Routes routes;

  /*List htmlTable = [
*/ /*    ['test'],
    ['test', 'test'],
    ['test'],*/ /*
  ];*/

  bool edit = false;
  SitePart mainPart;

  String test = 'test';

/*  String heroUrl(int id) =>
      paths.hero.toUrl(parameters: {paths.idParam: id.toString()});*/

  /* List<Hero> heroes;

  final HeroService _heroService;

  DashboardComponent(this._heroService);*/
  void _interpreter(String input) {
    bool meta = false;

    String metaData = '';

    int secPointer;

    for (int pointer = 0; pointer < input.length; pointer++) {
      if (input[pointer] == '\\') {
        if (meta) {
          int minForThis = int.tryParse(metaData);
/*
          print(minForThis);
*/
          if (minForThis == null) {
/*
            print('THISCANTBE');
*/
            return;
          } else {
            if (minForThis < availableWidth) {
/*
              print(minForThis);
*/
              secPointer = pointer + 1;

              break;
            }
          }
          metaData = '';
        }
        meta = !meta;
      } else if (meta) {
        metaData += input[pointer];
      }
    }

/*
    print(secPointer);
*/

    String code = '';
    while (secPointer < input.length && input[secPointer] != '\\') {
      code += input[secPointer];
      secPointer++;
    }

/*
    print(code);
*/

    int cascadePointer = -1;
    Map cascadeIndex = new Map();
    Map cascadeType = new Map();

    mainPart = new SitePart();

    bool beforeText = true;
    String text = '';

    for (int pointer = 0; pointer < code.length; pointer++) {
      if (code[pointer] == '<') {
        cascadePointer++;
        cascadeType[cascadePointer] = '<>';
        cascadeIndex[cascadePointer] = 0;
      } else if (code[pointer] == '[') {
        cascadePointer++;
        cascadeType[cascadePointer] = '[]';
        cascadeIndex[cascadePointer] = 0;
      } else if (code[pointer] == '\'') {
        if (beforeText) {
          text = '';
        } else {
          String command = '';
          for (int z = 0; z <= cascadePointer; z++) {
            command += '${cascadeType[z]}${cascadeIndex[z]}';
          }

          /*   print('----');
          print(command);
          print(text);*/

          mainPart.setChildrenDown(command, text);
/*
          print('-END-');
*/
        }

        beforeText = !beforeText;
      } else if (code[pointer] == ',') {
        cascadeIndex[cascadePointer] += 1;
      } else if (code[pointer] == ']') {
        cascadePointer--;
      } else if (code[pointer] == '>') {
        cascadePointer--;
      } else {
        if (!beforeText) {
          text += code[pointer];
        }
      }
    }

/*
    print(mainPart.toString());
*/
/*
    mainPart.value = 'VALUE';*/
  }

  void generate() {}

  String infoText = '';

  int availableWidth;

/*  static void getUserAgent{

    Navigator.;
  }*/

  String siteData = '';

  Future<void> ngOnInit() async {
    siteData = await fbservice.getSite(1);
    _interpreter(siteData);

    /*  Element el = window.document.querySelector('#insert-there');

    var ua = window.navigator.userAgent;
    String template = '''<h1>Hello world.</h1>

Check my bird... <em>it flies</em> !
<img src="https://www.dartlang.org/logos/dart-bird.svg">''';*/
/*
    print(el);
*/

/*
    div.setInnerHtml(template, treeSanitizer: NodeTreeSanitizer.trusted);
*/
    /*  RegExp regExp =
    new RegExp(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
    Regex v = new Regex(
        r"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-");
*/
/*
    print(ua);
*/

    availableWidth = window.innerWidth;

    /*   fs.Firestore firestore = fb.firestore();
    fs.DocumentReference ref =
        firestore.collection("sites").doc('start_sources');

    ref.onSnapshot.listen((querySnapshot) {
      */ /* window.document
          .querySelector('#insert-here')
          .appendHtml('''<material-button raised (trigger)="generate()">
          <glyph icon="lightbulb_outline"></glyph>

          {{infoText}}
          </material-button>''');*/ /*

*/ /*
      print(querySnapshot.get('layout'));
*/ /*
      _interpreter(querySnapshot.get('layout'));
    });*/

    /*
    heroes = (await _heroService.getAll()).skip(1).take(4).toList();*/
  }
}
