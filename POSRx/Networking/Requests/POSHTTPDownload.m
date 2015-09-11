//
//  POSHTTPDownload.m
//  POSRx
//
//  Created by Pavel Osipov on 11.09.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "POSHTTPDownload.h"
#import "POSHTTPGateway.h"
#import "NSObject+POSRx.h"

@interface POSHTTPRequest (Hidden)
- (NSMutableURLRequest *)requestWithURL:(NSURL *)hostURL options:(POSHTTPRequestOptions *)options;
@end

#pragma mark -

@interface POSHTTPRequest (POSHTTPDownload) <POSHTTPDownload>
@end

@implementation POSHTTPRequest (POSHTTPDownload)
@dynamic progress;
@dynamic destination;

- (id<POSURLSessionTask>)downloadTaskWithURL:(NSURL *)hostURL
                                  forGateway:(id<POSHTTPGateway>)gateway
                                     options:(POSHTTPRequestOptions *)options {
    NSMutableURLRequest *request = [self requestWithURL:hostURL options:options];
    id<POSURLSessionTask> task = [gateway.foregroundSession downloadTaskWithRequest:request];
    task.posrx_downloadProgressHandler = self.progress;
    task.posrx_downloadCompletionHandler = self.destination;
    return task;
}

@end

#pragma mark -

@interface POSHTTPDownload ()
@property (nonatomic, copy) void (^destination)(NSURL *location);
@property (nonatomic, copy) void (^progress)(POSHTTPTaskProgress *progress);
@end

@implementation POSHTTPDownload

#pragma mark Lifecycle

- (instancetype)initWithEndpointMethod:(NSString *)endpointMethod
                           destination:(void (^)(NSURL *))destination
                              progress:(void (^)(POSHTTPTaskProgress *progress))progress
                          headerFields:(NSDictionary *)headerFields {
    if (self = [super initWithType:POSHTTPRequestTypeGET
                    endpointMethod:endpointMethod
                              body:nil
                      headerFields:headerFields]) {
        _destination = [destination copy];
        _progress = [progress copy];
    }
    return self;
}

#pragma mark POSHTTPRequest

- (id<POSURLSessionTask>)taskWithURL:(NSURL *)hostURL
                          forGateway:(id<POSHTTPGateway>)gateway
                             options:(POSHTTPRequestOptions *)options {
    return [self downloadTaskWithURL:hostURL forGateway:gateway options:options];
}

@end

#pragma mark -

@implementation POSMutableHTTPDownload
@dynamic progress;
@dynamic destination;

#pragma mark Lifecycle

- (instancetype)init {
    return [super initWithType:POSHTTPRequestTypeGET
                endpointMethod:nil
                          body:nil
                  headerFields:nil];
}

#pragma mark POSHTTPRequest

- (id<POSURLSessionTask>)taskWithURL:(NSURL *)hostURL
                          forGateway:(id<POSHTTPGateway>)gateway
                             options:(POSHTTPRequestOptions *)options {
    return [self downloadTaskWithURL:hostURL forGateway:gateway options:options];
}

@end