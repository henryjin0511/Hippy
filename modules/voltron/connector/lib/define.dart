import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef InitJsFrameworkFfiNativeType = Int64 Function(
  Pointer<Utf16> globalConfig,
  Int32 singleThreadMode,
  Int32 bridgeParamJson,
  Int32 isDevModule,
  Int64 groupId,
  Uint32 workManagerId,
  Uint32 domManagerId,
  Int32 engineId,
  Int32 callbackId,
  Uint32 devtoolsId,
);
typedef InitJsFrameworkFfiDartType = int Function(
  Pointer<Utf16> globalConfig,
  int singleThreadMode,
  int bridgeParamJson,
  int isDevModule,
  int groupId,
  int workManagerId,
  int domManagerId,
  int engineId,
  int callbackId,
  int devtoolsId,
);

typedef AddFfiNativeType = Int32 Function(
    Int32 a,
    Int32 b
);

typedef AddFfiDartType = int Function(
    int a,
    int b
);
