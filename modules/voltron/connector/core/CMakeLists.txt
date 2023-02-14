#
#
# Tencent is pleased to support the open source community by making
# Hippy available.
#
# Copyright (C) 2022 THL A29 Limited, a Tencent company.
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

cmake_minimum_required(VERSION 3.14.0)

project("voltron_connector")

get_filename_component(PROJECT_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../.." REALPATH)

message(PROJECT_ROOT_DIR ${PROJECT_ROOT_DIR})

set(CONNECTOR_CORE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(RENDER_DIR ${PROJECT_ROOT_DIR}/renderer/voltron/core)

include("${PROJECT_ROOT_DIR}/buildconfig/cmake/GlobalPackagesModule.cmake")
include(${PROJECT_ROOT_DIR}/framework/voltron/cmake/compile_option.cmake)

# region library
add_library(${PROJECT_NAME} STATIC)
target_include_directories(${PROJECT_NAME} PUBLIC include)
target_compile_options(${PROJECT_NAME} PRIVATE ${COMPILE_OPTIONS})
# endregion

message(CMAKE_CURRENT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# region footstone
GlobalPackages_Add(footstone)
target_link_libraries(${PROJECT_NAME} PRIVATE footstone)
# endregion

# region dom
GlobalPackages_Add(dom)
target_link_libraries(${PROJECT_NAME} PRIVATE dom)
# endregion

# region vfs
GlobalPackages_Add(vfs)
#set(FRAMEWORK_CORE_DEPS ${FRAMEWORK_CORE_DEPS} vfs)
target_link_libraries(${PROJECT_NAME} PRIVATE vfs)
# endregion

# region js_driver
if (NOT TARGET voltron_ffi)
#  add_subdirectory(${PROJECT_ROOT_DIR}/modules/voltron/ffi/core ${CMAKE_CURRENT_BINARY_DIR}/voltron/ffi)
  add_subdirectory(${PROJECT_ROOT_DIR}/driver/js ${CMAKE_CURRENT_BINARY_DIR}/driver/js)
endif ()
target_link_libraries(${PROJECT_NAME} PRIVATE js_driver)
message(CMAKE_CURRENT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
# endregion

# region voltron_ffi
if (NOT TARGET voltron_ffi)
  add_subdirectory(${PROJECT_ROOT_DIR}/modules/voltron/ffi/core ${CMAKE_CURRENT_BINARY_DIR}/voltron/ffi)
endif ()
target_link_libraries(${PROJECT_NAME} PRIVATE voltron_ffi)
# endregion

# region voltron renderer
if (NOT TARGET render_core)
  add_subdirectory(${RENDER_DIR} ${CMAKE_CURRENT_BINARY_DIR}/render_core)
endif ()
target_link_libraries(${PROJECT_NAME} PRIVATE render_core)
# endregion

# region source set
set(CONNECTOR_SOURCE_SET src/js_driver.cc)

target_sources(${PROJECT_NAME} PUBLIC ${CONNECTOR_SOURCE_SET})
# endregion
