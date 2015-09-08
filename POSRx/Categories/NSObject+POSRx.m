//
//  NSObject+POSRx.m
//  POSRx
//
//  Created by Osipov on 07.09.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "NSObject+POSRx.h"
#import "NSException+POSRx.h"
#import <objc/runtime.h>

static char kDownloadProgressHandlerKey;
static char kUploadProgressHandlerKey;
static char kCompletionHandlerKey;
static char kDataHandlerKey;
static char kResponseHandlerKey;
static char kBodyStreamBuilderKey;
static char kDownloadCompletionHandlerKey;
static char kResponse;

@implementation NSObject (POSRx)

- (void)posrx_start {
    if ([self isKindOfClass:NSURLConnection.class]) {
        [(NSURLConnection *)self start];
        return;
    }
    if ([self respondsToSelector:@selector(resume)]) {
        NSURLSessionTask *task = (id)self;
        switch (task.state) {
            case NSURLSessionTaskStateRunning:
            case NSURLSessionTaskStateCanceling:
                break;
            case NSURLSessionTaskStateSuspended:
                [task resume];
                break;
            case NSURLSessionTaskStateCompleted:
                if (self.posrx_completionHandler) {
                    self.posrx_completionHandler(task.error);
                }
                break;
        }
        return;
    }
    POSRX_CHECK(!"Undefined object type.");
}

- (void)posrx_cancel {
    [(id)self cancel];
}

- (NSHTTPURLResponse *)posrx_response {
    if ([self respondsToSelector:@selector(response)]) {
        return (id)[(id)self response];
    }
    return objc_getAssociatedObject(self, &kResponse);
}

- (void)posrx_setResponse:(NSHTTPURLResponse *)response {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (![self respondsToSelector:@selector(setResponse:)]) {
#pragma clang diagnostic pop
        objc_setAssociatedObject(self, &kResponse, response, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void (^)(POSHTTPTaskProgress *))posrx_uploadProgressHandler {
    return objc_getAssociatedObject(self, &kUploadProgressHandlerKey);
}

- (void)posrx_setUploadProgressHandler:(void (^)(POSHTTPTaskProgress *))uploadProgressHandler {
    objc_setAssociatedObject(self, &kUploadProgressHandlerKey, uploadProgressHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSError *))posrx_completionHandler {
    return objc_getAssociatedObject(self, &kCompletionHandlerKey);
}

- (void)posrx_setCompletionHandler:(void (^)(NSError *))completionHandler {
    objc_setAssociatedObject(self, &kCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInputStream *(^)())posrx_bodyStreamBuilder {
    return objc_getAssociatedObject(self, &kBodyStreamBuilderKey);
}

- (void)posrx_setBodyStreamBuilder:(NSInputStream *(^)())bodyStreamBuilder {
    objc_setAssociatedObject(self, &kBodyStreamBuilderKey, bodyStreamBuilder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSURLSessionResponseDisposition (^)(NSURLResponse *))posrx_responseHandler {
    return objc_getAssociatedObject(self, &kResponseHandlerKey);
}

- (void)posrx_setResponseHandler:(NSURLSessionResponseDisposition (^)(NSURLResponse *))responseHandler {
    objc_setAssociatedObject(self, &kResponseHandlerKey, responseHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSData *))posrx_dataHandler {
    return objc_getAssociatedObject(self, &kDataHandlerKey);
}

- (void)posrx_setDataHandler:(void (^)(NSData *))dataHandler {
    objc_setAssociatedObject(self, &kDataHandlerKey, dataHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(POSHTTPTaskProgress *))posrx_downloadProgressHandler {
    return objc_getAssociatedObject(self, &kDownloadProgressHandlerKey);
}

- (void)posrx_setDownloadProgressHandler:(void (^)(POSHTTPTaskProgress *))downloadProgressHandler {
    objc_setAssociatedObject(self, &kDownloadProgressHandlerKey, downloadProgressHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSURL *))posrx_downloadCompletionHandler {
    return objc_getAssociatedObject(self, &kDownloadCompletionHandlerKey);
}

- (void)posrx_setDownloadCompletionHandler:(void (^)(NSURL *))downloadCompletionHandler {
    objc_setAssociatedObject(self, &kDownloadCompletionHandlerKey, downloadCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
