//
// Created by henryjin on 2022/12/9.
//

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
