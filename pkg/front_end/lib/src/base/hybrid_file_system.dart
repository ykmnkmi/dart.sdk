// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A memory + physical file system used to mock input for tests but provide
/// sdk sources from disk.
library front_end.src.hybrid_file_system;

import 'dart:typed_data';

import '../api_prototype/file_system.dart';
import '../api_prototype/memory_file_system.dart';
import '../api_prototype/standard_file_system.dart';

/// A file system that mixes files from memory and a physical file system. All
/// memory entities take priority over file system entities.
class HybridFileSystem implements FileSystem {
  final MemoryFileSystem memory;
  final FileSystem physical;

  HybridFileSystem(this.memory, [FileSystem? _physical])
      : physical = _physical ?? // Coverage-ignore(suite): Not run.
            StandardFileSystem.instance;

  @override
  FileSystemEntity entityForUri(Uri uri) =>
      new HybridFileSystemEntity(uri, this);
}

/// Entity that delegates to an underlying memory or physical file system
/// entity.
class HybridFileSystemEntity implements FileSystemEntity {
  @override
  final Uri uri;
  FileSystemEntity? _delegate;
  final HybridFileSystem _fs;

  HybridFileSystemEntity(this.uri, this._fs);

  Future<FileSystemEntity> get delegate async {
    if (_delegate != null) {
      // Coverage-ignore-block(suite): Not run.
      return _delegate!;
    }
    FileSystemEntity entity = _fs.memory.entityForUri(uri);
    if (((!uri.isScheme('file') &&
                // Coverage-ignore(suite): Not run.
                !uri.isScheme('data')) &&
            // Coverage-ignore(suite): Not run.
            _fs.physical is StandardFileSystem) ||
        await entity.exists()) {
      // Coverage-ignore-block(suite): Not run.
      _delegate = entity;
      return _delegate!;
    }
    return _delegate = _fs.physical.entityForUri(uri);
  }

  @override
  // Coverage-ignore(suite): Not run.
  Future<bool> exists() async => (await delegate).exists();

  @override
  // Coverage-ignore(suite): Not run.
  Future<bool> existsAsyncIfPossible() async =>
      (await delegate).existsAsyncIfPossible();

  @override
  Future<Uint8List> readAsBytes() async => (await delegate).readAsBytes();

  @override
  // Coverage-ignore(suite): Not run.
  Future<Uint8List> readAsBytesAsyncIfPossible() async =>
      (await delegate).readAsBytesAsyncIfPossible();

  @override
  // Coverage-ignore(suite): Not run.
  Future<String> readAsString() async => (await delegate).readAsString();
}
