import 'dart:ffi';

import 'package:voltron_ffi/ffi_manager.dart';

import 'define.dart';

class ConnectFFI {
  final DynamicLibrary _library = FfiManager().library;

  static final ConnectFFI _instance = ConnectFFI._internal();

  static ConnectFFI get instance => _instance;

  // 初始化js framework
  late InitJsFrameworkFfiDartType initJsFramework;

  /// 执行js
  late RunScriptFromUriFfiDartType runScriptFromUri;

  /// 初始化native dom
  late LoadInstanceFfiDartType loadInstance;

  /// 销毁native dom
  late UnloadInstanceFfiDartType unloadInstance;

  late CallFunctionFfiDartType callFunction;

  /// 销毁
  late DestroyFfiDartType destroy;

  late AddFfiDartType add;

  ConnectFFI._internal() {
    add = _library.lookupFunction<AddFfiNativeType, AddFfiDartType>("AddAdd");

    initJsFramework =
        _library.lookupFunction<InitJsFrameworkFfiNativeType, InitJsFrameworkFfiDartType>(
      "InitJSFrameworkFFI",
    );

    runScriptFromUri =
        _library.lookupFunction<RunScriptFromUriFfiNativeType, RunScriptFromUriFfiDartType>(
      "RunScriptFromUriFFI",
    );

    loadInstance = _library.lookupFunction<LoadInstanceFfiNativeType, LoadInstanceFfiDartType>(
      "LoadInstanceFFI",
    );

    unloadInstance =
        _library.lookupFunction<UnloadInstanceFfiNativeType, UnloadInstanceFfiDartType>(
      "UnloadInstanceFFI",
    );

    callFunction = _library.lookupFunction<CallFunctionFfiNativeType, CallFunctionFfiDartType>(
      "CallFunctionFFI",
    );

    destroy = _library.lookupFunction<DestroyFfiNativeType, DestroyFfiDartType>(
      "DestroyFFI",
    );
  }
}
