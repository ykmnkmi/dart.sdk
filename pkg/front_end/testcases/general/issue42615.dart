// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

class Class<T> {
  Class({required FutureOr<List<T>> Function() a});
}

dynamic method() => null;

main() {
  Class(a: () async => method());
}
