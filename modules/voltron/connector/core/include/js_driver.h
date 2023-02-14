/*
 *
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2019 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#pragma once

#if defined(__ANDROID__) || defined(_WIN32)
//#  include "bridge_runtime.h"
#  include "callback_manager.h"
#elif __APPLE__
#  include "bridge/bridge_runtime.h"
#  include "common_header.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

EXTERN_C int64_t InitJSFrameworkFFI(const char16_t* global_config, int32_t single_thread_mode,
                                    int32_t bridge_param_json, int32_t is_dev_module, int64_t group_id,
                                    uint32_t work_manager_id, uint32_t dom_manager_id,
                                    int32_t engine_id, int32_t callback_id, uint32_t devtools_id);

EXTERN_C int32_t AddAdd(int32_t a, int32_t b);

#ifdef __cplusplus
}
#endif
