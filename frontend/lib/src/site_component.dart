import 'dart:async';
import 'dart:html';

import 'route_paths.dart' as paths;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:atlive/src/backend_service.dart';
import 'package:atlive/src/routes.dart';
import 'package:atlive/src/site_part.dart';
import 'package:atlive/src/source_component.dart';
import 'package:atlive/src/tile_component.dart';

@Component(
  selector: 'site',
  templateUrl: 'site_component.html',
  directives: [
    coreDirectives,
    materialDirectives,
    NgFor,
    NgIf,
    formDirectives,
    SourceComponent,
    TileComponent,
    MaterialToggleComponent
  ],
  providers: const [materialProviders],
)
class SiteComponent implements OnInit, OnActivate {
  SiteComponent(this.routes, BService this.fbservice);

  @override
  Future<void> onActivate(_, RouterState current) async {
    print('ACTIVATE');
    final id = paths.getSiteId(current.parameters);
    if (id != null) siteId = id;

    availableWidth = window.innerWidth;

    siteData = await fbservice.getSite(siteId);

    document.title = siteData.split('\\')[0].trim();

    _interpreter(siteData);
    /* availableWidth = window.innerWidth;

    siteData = await fbservice.getSite(1);
    _interpreter(siteData);
    */
  }

  final BService fbservice;
  final Routes routes;

  bool edit = false;
  SitePart mainPart;

  String test = 'test';

  @Input()
  String siteId;

  void toggleEdit(bool value) {
    edit = value;

    Element el = window.document.querySelector('#siteId' /*'#' + key*/);
    el.setInnerHtml(
        edit
            ? '''<style type="text/css">
        .container {
    border: 3px solid yellow;
    }

            .row {
        border: 3px solid red;
        }

            .column {
        border: 3px solid blue;
        }

            .tile {
        border: 3px solid green;
        }

        </style>'''
            : '',
        treeSanitizer: NodeTreeSanitizer.trusted);
  }

  void _interpreter(String input) {
    bool meta = false;

    String metaData = '';

    int secPointer;

    for (int pointer = 0; pointer < input.length; pointer++) {
      if (input[pointer] == '\\') {
        if (meta) {
          int minForThis = int.tryParse(metaData);
          if (minForThis == null) {
            return;
          } else {
            if (minForThis < availableWidth) {
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

    String code = '';
    while (secPointer < input.length && input[secPointer] != '\\') {
      code += input[secPointer];
      secPointer++;
    }

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

          mainPart.setChildrenDown(command, text);
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
  }

  void generate() {}

  String infoText = '';

  int availableWidth;

  String siteData = '';

  Future<void> ngOnInit() async {
    print('INIT');
  }
}
