// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Super {
  void method1(num n) {}
  void method2(num n) {}
  void method3(num n) {}

  void method4(covariant num i) {}
  void method5(covariant int i) {}
}

class Interface {
  void method1(covariant int i) {}
  void method2(covariant int i) {}

  void method4(int i) {}
  void method5(int i) {}
}

class Class extends Super implements Interface {
  void method1(int i);
  void method2(String i);
  void method3(int i);

  void method4(int i);
  void method5(num n);
}

main() {}
