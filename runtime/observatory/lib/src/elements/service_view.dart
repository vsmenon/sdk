// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library service_object_view_element;

import 'dart:html';
import 'package:logging/logging.dart';
import 'package:observatory/service.dart';
import 'package:observatory/tracer.dart';
import 'package:observatory/elements.dart';
import 'package:polymer/polymer.dart';
import 'observatory_element.dart';

@CustomTag('service-view')
class ServiceObjectViewElement extends ObservatoryElement {
  @published ServiceObject object;
  @published ObservableMap args;

  ServiceObjectViewElement.created() : super.created();

  ObservatoryElement _constructElementForObject() {
    var type = object.type;
    switch (type) {
      case 'Class':
        ClassViewElement element = new Element.tag('class-view');
        element.cls = object;
        return element;
      case 'Code':
        CodeViewElement element = new Element.tag('code-view');
        element.code = object;
        return element;
      case 'Isolate':
        IsolateViewElement element = new Element.tag('isolate-view');
        element.isolate = object;
        return element;
      case 'VM':
        VMViewElement element = new Element.tag('vm-view');
        element.vm = object;
        return element;
      default:
        JsonViewElement element = new Element.tag('json-view');
        element.map = object;
        return element;
    }
  }

  objectChanged(oldValue) {
    // Remove the current view.
    children.clear();
    if (object == null) {
      Logger.root.info('Viewing null object.');
      return;
    }
    var type = object.vmType;
    var element = _constructElementForObject();
    if (element == null) {
      Logger.root.info('Unable to find a view element for \'${type}\'');
      return;
    }
    children.add(element);
  }
}

@CustomTag('trace-view')
class TraceViewElement extends ObservatoryElement {
  @published Tracer tracer;
  TraceViewElement.created() : super.created();
}

@CustomTag('map-viewer')
class MapViewerElement extends ObservatoryElement {
  @published Map map;
  @published bool expand = false;
  MapViewerElement.created() : super.created();

  bool isMap(var m) {
    return m is Map;
  }

  bool isList(var m) {
    return m is List;
  }

  dynamic expander() {
    return expandEvent;
  }

  void expandEvent(bool exp, var done) {
    expand = exp;
    done();
  }
}

@CustomTag('list-viewer')
class ListViewerElement extends ObservatoryElement {
  @published List list;
  @published bool expand = false;
  ListViewerElement.created() : super.created();

  bool isMap(var m) {
    return m is Map;
  }

  bool isList(var m) {
    return m is List;
  }

  dynamic expander() {
    return expandEvent;
  }

  void expandEvent(bool exp, var done) {
    expand = exp;
    done();
  }
}
