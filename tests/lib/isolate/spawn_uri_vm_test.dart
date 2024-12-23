// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Example of spawning an isolate from a URI
library spawn_tests;

import 'dart:isolate';
import 'package:expect/legacy/async_minitest.dart'; // ignore: deprecated_member_use

main() {
  test('isolate fromUri - send and reply', () {
    ReceivePort port = new ReceivePort();
    port.first.then(expectAsync((msg) {
      expect(msg, equals('re: hi'));
    }));

    Isolate.spawnUri(
        Uri.parse('spawn_uri_child_isolate.dart'), ['hi'], port.sendPort);
  });
}
