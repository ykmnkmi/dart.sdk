// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "platform/assert.h"

#include "vm/bootstrap_natives.h"
#include "vm/exceptions.h"
#include "vm/native_entry.h"
#include "vm/object.h"
#include "vm/object_graph_copy.h"

namespace dart {

DEFINE_NATIVE_ENTRY(GrowableList_allocate, 0, 2) {
  const TypeArguments& type_arguments =
      TypeArguments::CheckedHandle(zone, arguments->NativeArgAt(0));
  GET_NON_NULL_NATIVE_ARGUMENT(Array, data, arguments->NativeArgAt(1));
  if (data.Length() < 0) {
    Exceptions::ThrowRangeError("length",
                                Integer::Handle(Integer::New(data.Length())),
                                0,  // This is the limit the user sees.
                                Array::kMaxElements);
  }
  const GrowableObjectArray& new_array =
      GrowableObjectArray::Handle(GrowableObjectArray::New(data));
  new_array.SetTypeArguments(type_arguments);
  return new_array.ptr();
}

DEFINE_NATIVE_ENTRY(GrowableList_setIndexed, 0, 3) {
  const GrowableObjectArray& array =
      GrowableObjectArray::CheckedHandle(zone, arguments->NativeArgAt(0));
  GET_NON_NULL_NATIVE_ARGUMENT(Smi, index, arguments->NativeArgAt(1));
  if ((index.Value() < 0) || (index.Value() >= array.Length())) {
    Exceptions::ThrowRangeError("index", index, 0, array.Length() - 1);
  }
  GET_NON_NULL_NATIVE_ARGUMENT(Instance, value, arguments->NativeArgAt(2));
  array.SetAt(index.Value(), value);
  return Object::null();
}

DEFINE_NATIVE_ENTRY(GrowableList_getLength, 0, 1) {
  const GrowableObjectArray& array =
      GrowableObjectArray::CheckedHandle(zone, arguments->NativeArgAt(0));
  return Smi::New(array.Length());
}

DEFINE_NATIVE_ENTRY(GrowableList_getCapacity, 0, 1) {
  const GrowableObjectArray& array =
      GrowableObjectArray::CheckedHandle(zone, arguments->NativeArgAt(0));
  return Smi::New(array.Capacity());
}

DEFINE_NATIVE_ENTRY(GrowableList_setLength, 0, 2) {
  const GrowableObjectArray& array =
      GrowableObjectArray::CheckedHandle(zone, arguments->NativeArgAt(0));
  GET_NON_NULL_NATIVE_ARGUMENT(Smi, length, arguments->NativeArgAt(1));
  ASSERT((length.Value() >= 0) && (length.Value() <= array.Capacity()));
  array.SetLength(length.Value());
  return Object::null();
}

DEFINE_NATIVE_ENTRY(GrowableList_setData, 0, 2) {
  const GrowableObjectArray& array =
      GrowableObjectArray::CheckedHandle(zone, arguments->NativeArgAt(0));
  GET_NON_NULL_NATIVE_ARGUMENT(Array, data, arguments->NativeArgAt(1));
  ASSERT(data.Length() >= 0);
  array.SetData(data);
  return Object::null();
}

DEFINE_NATIVE_ENTRY(Internal_makeListFixedLength, 0, 1) {
  GET_NON_NULL_NATIVE_ARGUMENT(GrowableObjectArray, array,
                               arguments->NativeArgAt(0));
  return Array::MakeFixedLength(array, /* unique = */ true);
}

DEFINE_NATIVE_ENTRY(Internal_makeFixedListUnmodifiable, 0, 1) {
  GET_NON_NULL_NATIVE_ARGUMENT(Array, array, arguments->NativeArgAt(0));
  array.MakeImmutable();
  return array.ptr();
}

}  // namespace dart
