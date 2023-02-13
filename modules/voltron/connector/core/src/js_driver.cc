//
// Created by henryjin on 2022/12/9.
//

#include <footstone/worker_manager.h>
#include "render/bridge/bridge_manager.h"
#include "bridge/ffi_bridge_runtime.h"
#include "callback_manager.h"
#include "footstone/logging.h"

#if defined(__ANDROID__) || defined(_WIN32)
#  include "bridge_impl.h"
#else
#  include "bridge_impl_ios.h"
#endif

using voltron::BridgeManager;
using voltron::FFIJSBridgeRuntime;

EXTERN_C int64_t InitJSFrameworkFFI(const char16_t* global_config, int32_t single_thread_mode,
                                    int32_t bridge_param_json, int32_t is_dev_module, int64_t group_id,
                                    uint32_t work_manager_id, uint32_t dom_manager_id,
                                    int32_t engine_id, int32_t callback_id, uint32_t devtools_id) {
  auto ffi_runtime = std::make_shared<FFIJSBridgeRuntime>(engine_id);
  BridgeManager::Create(engine_id, ffi_runtime);

  std::shared_ptr<WorkerManager>
    worker_manager = voltron::BridgeManager::FindWorkerManager(work_manager_id);
  FOOTSTONE_DCHECK(worker_manager != nullptr);

  auto result = BridgeImpl::InitJsEngine(ffi_runtime, single_thread_mode, bridge_param_json, is_dev_module, group_id,
                                         worker_manager, dom_manager_id, global_config, 0, 0,
                                         [callback_id](int64_t value) { CallGlobalCallback(callback_id, value); }, devtools_id);
  ffi_runtime->SetRuntimeId(result);

  return result;
}
