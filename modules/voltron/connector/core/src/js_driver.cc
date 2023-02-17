//
// Created by henryjin on 2022/12/9.
//

#include "js_driver.h"

#include <footstone/worker_manager.h>
#include "bridge/ffi_bridge_runtime.h"
#include "callback_manager.h"
#include "footstone/logging.h"

#if defined(__ANDROID__) || defined(_WIN32)
#  include "bridge_impl.h"
#else
#  include "bridge_impl_ios.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

using voltron::BridgeManager;
using voltron::FFIJSBridgeRuntime;

EXTERN_C int64_t InitJSFrameworkFFI(const char16_t* global_config, int32_t single_thread_mode,
                                    int32_t bridge_param_json, int32_t is_dev_module, int64_t group_id,
                                    uint32_t work_manager_id, uint32_t dom_manager_id,
                                    int32_t engine_id, int32_t callback_id, uint32_t devtools_id) {
  auto ffi_runtime = std::make_shared<FFIJSBridgeRuntime>(engine_id);
  BridgeManager::Create(engine_id, ffi_runtime);
//  throw 123000000000;
  std::shared_ptr<WorkerManager>
    worker_manager = voltron::BridgeManager::FindWorkerManager(work_manager_id);
  FOOTSTONE_DCHECK(worker_manager != nullptr);

  auto result = BridgeImpl::InitJsEngine(ffi_runtime, single_thread_mode, bridge_param_json, is_dev_module, group_id,
                                         worker_manager, dom_manager_id, global_config, 0, 0,
                                         [callback_id](int64_t value) { CallGlobalCallback(callback_id, value); }, devtools_id);
  ffi_runtime->SetRuntimeId(result);

  return result;
}

EXTERN_C int32_t RunScriptFromUriFFI(int32_t engine_id,
                                     uint32_t vfs_id,
                                     const char16_t *uri,
                                     const char16_t *code_cache_dir,
                                     int32_t can_use_code_cache,
                                     int32_t is_local_file,
                                     int32_t callback_id) {
  auto bridge_manager = BridgeManager::Find(engine_id);
  if (!bridge_manager) {
    FOOTSTONE_DLOG(WARNING) << "RunScriptFromAssetsFFI engine_id invalid";
    return false;
  }

  auto runtime = std::static_pointer_cast<FFIJSBridgeRuntime>(bridge_manager->GetRuntime());
  if (!runtime) {
    FOOTSTONE_DLOG(WARNING) << "RunScriptFromAssetsFFI runtime unbind";
    return false;
  }

  auto runtime_id = runtime->GetRuntimeId();
  bool result = BridgeImpl::RunScriptFromUri(
    runtime_id, vfs_id, can_use_code_cache, is_local_file, uri, code_cache_dir,
    [callback_id](int value) { CallGlobalCallback(callback_id, value); });
  return result;
}

EXTERN_C void LoadInstanceFFI(int32_t engine_id, const char* params, int32_t params_length) {
  auto bridge_manager = BridgeManager::Find(engine_id);
  if (!bridge_manager) {
    FOOTSTONE_DLOG(WARNING) << "LoadInstanceFFI engine_id invalid";
    return;
  }

  auto runtime = std::static_pointer_cast<FFIJSBridgeRuntime>(bridge_manager->GetRuntime());
  if (!runtime) {
    FOOTSTONE_DLOG(WARNING) << "LoadInstanceFFI runtime unbind";
    return;
  }

  auto runtime_id = runtime->GetRuntimeId();
  if (params_length <= 0) {
    FOOTSTONE_DLOG(WARNING) << "LoadInstanceFFI params length error";
    return;
  }

  std::string param_str(params, static_cast<unsigned int>(params_length));
  BridgeImpl::LoadInstance(runtime_id, std::move(param_str));
}

EXTERN_C void UnloadInstanceFFI(int32_t engine_id, const char* params, int32_t params_length) {
  auto bridge_manager = BridgeManager::Find(engine_id);
  if (!bridge_manager) {
    FOOTSTONE_DLOG(WARNING) << "UnloadInstanceFFI engine_id invalid";
    return;
  }

  auto runtime = std::static_pointer_cast<FFIJSBridgeRuntime>(bridge_manager->GetRuntime());
  if (!runtime) {
    FOOTSTONE_DLOG(WARNING) << "UnloadInstanceFFI runtime unbind";
    return;
  }

  auto runtime_id = runtime->GetRuntimeId();
  std::string param_str(params, static_cast<unsigned int>(params_length));
  BridgeImpl::UnloadInstance(runtime_id, std::move(param_str));
}

EXTERN_C void DestroyFFI(int32_t engine_id, int32_t callback_id, int32_t is_reload) {
  auto bridge_manager = BridgeManager::Find(engine_id);
  if (!bridge_manager) {
    FOOTSTONE_DLOG(WARNING) << "DestroyFFI engine_id invalid";
    return;
  }

  BridgeManager::Destroy(engine_id);

  auto runtime = std::static_pointer_cast<FFIJSBridgeRuntime>(bridge_manager->GetRuntime());
  if (!runtime) {
    FOOTSTONE_DLOG(WARNING) << "DestroyFFI runtime unbind";
    return;
  }

  auto runtime_id = runtime->GetRuntimeId();
  BridgeImpl::Destroy(runtime_id,
                      [callback_id](int64_t value) { CallGlobalCallback(callback_id, value); },
                      is_reload);
}

EXTERN_C int32_t AddAdd (int32_t a, int32_t b) {
  return a + b;
}

#ifdef __cplusplus
}
#endif
