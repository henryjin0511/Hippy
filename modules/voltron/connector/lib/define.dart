import 'dart:ffi';

import 'package:ffi/ffi.dart';

/// InitJsFramework
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

/// RunScriptFromUri
typedef RunScriptFromUriFfiNativeType = Int32 Function(
  Int32 engineId,
  Uint32 vfsId,
  Pointer<Utf16> uri,
  Pointer<Utf16> codeCacheDir,
  Int32 canUseCodeCache,
  Int32 isLocalFile,
  Int32 callbackId,
);
typedef RunScriptFromUriFfiDartType = int Function(
  int engineId,
  int vfsId,
  Pointer<Utf16> uri,
  Pointer<Utf16> codeCacheDir,
  int canUseCodeCache,
  int isLocalFile,
  int callbackId,
);

/// LoadInstance
typedef LoadInstanceFfiNativeType = Int64 Function(
  Int32 engineId,
  Pointer<Uint8> params,
  Int32 paramsLength,
);
typedef LoadInstanceFfiDartType = int Function(
  int engineId,
  Pointer<Uint8> params,
  int paramsLength,
);

/// unloadInstance
typedef UnloadInstanceFfiNativeType = Int64 Function(
  Int32 engineId,
  Pointer<Uint8> params,
  Int32 paramsLength,
);
typedef UnloadInstanceFfiDartType = int Function(
  int engineId,
  Pointer<Uint8> params,
  int paramsLength,
);

/// callFunction
typedef CallFunctionFfiNativeType = Void Function(
  Int32 engineId,
  Pointer<Utf16> action,
  Pointer<Uint8> params,
  Int32 paramsLen,
  Int32 callbackId,
);
typedef CallFunctionFfiDartType = void Function(
  int engineId,
  Pointer<Utf16> action,
  Pointer<Uint8> params,
  int paramsLen,
  int callbackId,
);

/// Destroy
typedef DestroyFfiNativeType = Void Function(
  Int32 engineId,
  Int32 callbackId,
  Int32 isReload,
);
typedef DestroyFfiDartType = void Function(
  int engineId,
  int callbackId,
  int isReload,
);

typedef AddFfiNativeType = Int32 Function(Int32 a, Int32 b);

typedef AddFfiDartType = int Function(int a, int b);
