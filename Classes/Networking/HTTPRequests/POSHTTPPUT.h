//
//  POSHTTPPUT.h
//  POSNetworking
//
//  Created by Pavel Osipov on 03/07/2018.
//  Copyright © 2018 Pavel Osipov. All rights reserved.
//

#import "POSHTTPRequestBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface POSHTTPPUT : POSHTTPRequestBuilder

/// Notifies how many bytes were sent to remote host.
- (instancetype)withUploadProgress:(void (^ _Nullable)(POSHTTPRequestProgress progress))uploadProgress;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod NS_UNAVAILABLE;

@end

#pragma mark -

@interface POSHTTPPUTForeground : POSHTTPPUT

/// Creates stream for the HTTP request's body.
- (instancetype)withBodyStream:(NSInputStream * _Nullable (^ _Nullable)(void))streamFactory;

@end

#pragma mark -

@interface POSHTTPPUTBackground : POSHTTPPUT

- (instancetype)initWithFile:(NSURL *)fileLocation NS_DESIGNATED_INITIALIZER;

POS_INIT_UNAVAILABLE

@end

NS_ASSUME_NONNULL_END
