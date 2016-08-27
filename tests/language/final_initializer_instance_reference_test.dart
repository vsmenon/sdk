// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart2js regression test. Error in initializer might be report with the wrong
// current element.

class C {
  const C();

  final x = 1;
  final y = x; /// 01: compile-time error
}

main() {
  const C().y; /// 01: continued
}