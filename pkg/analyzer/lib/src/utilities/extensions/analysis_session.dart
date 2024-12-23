// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/src/utilities/extensions/element.dart';
import 'package:analyzer/src/utilities/extensions/library_element.dart';

extension AnalysisSessionExtension on AnalysisSession {
  /// Return the resolved library for the library containing the file with the
  /// given [path].
  Future<ResolvedLibraryResult?> getResolvedContainingLibrary(
    String path,
  ) async {
    var unitElement = await getUnitElement(path);
    if (unitElement is! UnitElementResult) {
      return null;
    }
    var libraryPath = unitElement.element.library.source.fullName;
    var result = await getResolvedLibrary(libraryPath);
    return result is ResolvedLibraryResult ? result : null;
  }

  /// Locates the [Element] that [location] represents.
  ///
  /// Local elements such as variables inside functions cannot be found using
  /// this method.
  ///
  /// Returns `null` if the element cannot be found.
  Future<Element?> locateElement(ElementLocation location) async {
    var components = location.components;
    if (location.components.isEmpty) {
      return null;
    }

    // The first component is the library which we'll use to start the search.
    var libraryUri = components.first;
    var result = await getLibraryByUri(libraryUri);
    return result is LibraryElementResult
        ? result.element.locateElement(location)
        : null;
  }

  /// Returns the element represented by the [location].
  ///
  /// Local elements such as variables inside functions can't be found using
  /// this method.
  ///
  /// Returns `null` if the element cannot be found.
  Future<Element2?> locateElement2(ElementLocation location) async {
    var result = await locateElement(location);
    if (result == null) return null;
    return result.asElement2;
  }
}
