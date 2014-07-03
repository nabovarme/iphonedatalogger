//
//  Multical601Request.h
//  MeterLogger
//
//  Created by johannes on 6/26/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "KMP.h"

@interface Multical601Request : NSObject <NewSampleViewControllerSendToDeviceRequest>

- (void)sendRequest;
- (void)sendKMPRequest:(NSOperation *)theOperation;

@property KMP *kmp;
@property (nonatomic, assign) id<DeviceRequestSendToNewSampleViewController> deviceRequestSendToNewSampleViewControllerDelegate;
@property (nonatomic, assign) id<DeviceRequestSendToDeviceViewController> deviceRequestSendToDeviceViewControllerDelegate;

@property NSOperationQueue *sendKMPRequestOperationQueue;

@end
