//
//  KamstrupRequest.h
//  MeterLogger
//
//  Created by johannes on 6/26/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "KMP.h"

@interface KamstrupRequest : NSObject

- (void)sendRequest;

- (void)sendKamstrupRequest:(NSOperation *)theOperation;
@property (nonatomic, assign) id<DeviceViewControllerSendRequest> sendRequestDelegate;

@end
