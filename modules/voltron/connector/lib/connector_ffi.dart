import 'dart:ffi';

import 'package:voltron_ffi/ffi_manager.dart';

import 'define.dart';

class ConnectFFI {
  final DynamicLibrary _library = FfiManager().library;

  static final ConnectFFI _instance = ConnectFFI._internal();

  static ConnectFFI get instance => _instance;
  // 初始化js framework
  late InitJsFrameworkFfiDartType initJsFramework;

  late AddFfiDartType add;

  ConnectFFI._internal() {
    add = _library.lookupFunction<AddFfiNativeType, AddFfiDartType>("AddAdd");
    print(add(1, 2));
    initJsFramework = _library.lookupFunction<InitJsFrameworkFfiNativeType, InitJsFrameworkFfiDartType>(
      "InitJSFrameworkFFI",
    );
  }
}
