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

#import "HippyBridge.h"
#import "HPToolUtils.h"

#include "HippyFileHandler.h"
#include "footstone/logging.h"

HippyFileHandler::HippyFileHandler(HippyBridge *bridge) {
    bridge_ = bridge;
}

void HippyFileHandler::RequestUntrustedContent(std::shared_ptr<hippy::RequestJob> request,
                                               std::shared_ptr<hippy::JobResponse> response,
                                               std::function<std::shared_ptr<UriHandler>()> next) {
    FOOTSTONE_UNIMPLEMENTED();
}

void HippyFileHandler::RequestUntrustedContent(std::shared_ptr<hippy::RequestJob> request,
                                               std::function<void(std::shared_ptr<hippy::JobResponse>)> cb,
                                               std::function<std::shared_ptr<UriHandler>()> next) {
    FOOTSTONE_UNIMPLEMENTED();
}

void HippyFileHandler::RequestUntrustedContent(NSURLRequest *request, VFSHandlerProgressBlock progress,
                                               VFSHandlerCompletionBlock completion, VFSGetNextHandlerBlock next) {
    HippyBridge *bridge = bridge_;
    if (!completion) {
        return;
    }
    if (!bridge || !request) {
        completion(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnsupportedURL userInfo:nil]);
        return;
    }
    NSString *urlString = [[request URL] absoluteString];
    if (!urlString) {
        completion(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnsupportedURL userInfo:nil]);
        return;
    }
    if ([HippyBridge isHippyLocalFileURLString:urlString]) {
        urlString = [bridge absoluteStringFromHippyLocalFileURLString:urlString];
    }
    NSMutableURLRequest *req = [request mutableCopy];
    [req setURL:HPURLWithString(urlString, nil)];
    VFSUriHandler::RequestUntrustedContent(req, progress, completion, next);
}