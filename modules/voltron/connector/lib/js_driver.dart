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

import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:voltron_ffi/define.dart';
import 'package:voltron_ffi/ffi_util.dart';
import 'package:voltron_ffi/global_callback.dart';

import 'connector_ffi.dart';

class JsDriver {
  // late int _instanceId;

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
    bool enableVoltronBuffer = (Platform.isIOS || Platform.isMacOS) ? false : true;
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
}
