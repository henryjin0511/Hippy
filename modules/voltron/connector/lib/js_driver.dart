//
// Tencent is pleased to support the open source community by making
// Hippy available.
//
// Copyright (C) 2022 THL A29 Limited, a Tencent company.
// All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:voltron_ffi/voltron_ffi.dart';
import 'package:voltron_renderer/common.dart';
import 'package:voltron_renderer/util.dart';

import 'connector_ffi.dart';

class JsDriver {
  // late int _instanceId;
  static final bool enableVoltronBuffer = (Platform.isIOS || Platform.isMacOS) ? false : true;

  Future<int> initialize({
    String globalConfig = '',
    bool singleThreadMode = false,
    bool isDevModule = false,
    required int groupId,
    required int engineId,
    required int workerManagerId,
    required int domId,
    required CommonCallback callback,
    required int devtoolsId,
  }) async {
    var globalConfigPtr = globalConfig.toNativeUtf16();
    var result = ConnectFFI.instance.initJsFramework(
      globalConfigPtr,
      singleThreadMode ? 1 : 0,
      enableVoltronBuffer ? 0 : 1,
      isDevModule ? 1 : 0,
      groupId,
      workerManagerId,
      domId,
      engineId,
      generateCallback((value) {
        callback(value);
      }),
      devtoolsId,
    );
    free(globalConfigPtr);
    return result;
  }

  Future<bool> runScriptFromUri(
    int engineId,
    int vfsId,
    String uri,
    String codeCacheDir,
    bool canUseCodeCache,
    bool isLocalFile,
    CommonCallback callback,
  ) async {
    var uriPtr = uri.toNativeUtf16();
    var codeCacheDirPtr = codeCacheDir.toNativeUtf16();
    var result = ConnectFFI.instance.runScriptFromUri(
      engineId,
      vfsId,
      uriPtr,
      codeCacheDirPtr,
      canUseCodeCache ? 1 : 0,
      isLocalFile ? 1 : 0,
      generateCallback(
        (value) {
          callback(value);
        },
      ),
    );
    free(uriPtr);
    free(codeCacheDirPtr);
    return result == 1;
  }

  Future loadInstance(
    int engineId,
    VoltronMap params,
  ) async {
    var stopwatch = Stopwatch();
    stopwatch.start();
    var paramsPair = _parseParams(params);
    stopwatch.stop();
    LogUtils.profile("loadInstance parse params", stopwatch.elapsedMilliseconds);
    ConnectFFI.instance.loadInstance(
      engineId,
      paramsPair.left,
      paramsPair.right.length,
    );
    stopwatch.stop();
    LogUtils.profile("loadInstance", stopwatch.elapsedMilliseconds);
    free(paramsPair.left);
  }

  Future unloadInstance(
    int engineId,
    VoltronMap params,
  ) async {
    var stopwatch = Stopwatch();
    stopwatch.start();
    var paramsPair = _parseParams(params);
    stopwatch.stop();
    LogUtils.profile("unloadInstance parse params", stopwatch.elapsedMilliseconds);
    ConnectFFI.instance.unloadInstance(
      engineId,
      paramsPair.left,
      paramsPair.right.length,
    );
    stopwatch.stop();
    LogUtils.profile("unloadInstance", stopwatch.elapsedMilliseconds);
  }

  Future<void> destroy(int engineId, CommonCallback callback, bool isReload) async {
    ConnectFFI.instance.destroy(
      engineId,
      generateCallback(
        (value) {
          callback(value);
        },
      ),
      isReload ? 1 : 0,
    );
  }

  static VoltronPair<Pointer<Uint8>, Uint8List> _parseParams(Object params) {
    if (enableVoltronBuffer) {
      var paramsBuffer = params.encode();
      assert(paramsBuffer.isNotEmpty);
      final paramsPointer = malloc<Uint8>(paramsBuffer.length);
      final nativeParams = paramsPointer.asTypedList(paramsBuffer.length);
      nativeParams.setRange(0, paramsBuffer.length, paramsBuffer);
      return VoltronPair(paramsPointer, nativeParams);
    } else {
      var paramsJson = objectToJson(params);
      assert(paramsJson.isNotEmpty);
      final units = utf8.encode(paramsJson);
      final Pointer<Uint8> result = malloc<Uint8>(units.length + 1);
      final Uint8List nativeString = result.asTypedList(units.length + 1);
      nativeString.setAll(0, units);
      nativeString[units.length] = 0;
      return VoltronPair(result, nativeString);
    }
  }
}
