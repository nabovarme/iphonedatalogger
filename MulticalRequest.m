//
//  MulticalRequest.m
//  MeterLogger
//
//  Created by stoffer on 23/06/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import "MulticalRequest.h"
#import "MeterLoggerProtocol.h"

@interface MulticalRequest()

// private
@property (nonatomic, assign) id<DeviceViewControllerSendRequest> sendRequestDelegate;
@property NSOperationQueue *sendIEC62056_21RequestOperationQueue;
@property BOOL readyToSend;
@property unsigned char framesToSend;
@property unsigned char framesReceived;

@end

@implementation MulticalRequest

@synthesize sendRequestDelegate;
@synthesize iec62056_21;
@synthesize sendIEC62056_21RequestOperationQueue;
@synthesize readyToSend;
@synthesize framesToSend;
@synthesize framesReceived;

- (id)init
{
    self = [super init];
    
    self.iec62056_21 = [[IEC62056_21 alloc] init];
    
    return self;
}

- (void)sendRequest:(id<DeviceViewControllerSendRequest>)theSendRequestDelegate {
    self.sendRequestDelegate = theSendRequestDelegate;
    
    // start sendMulticalRequest in a operation queue, so it can be canceled
    self.sendIEC62056_21RequestOperationQueue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    operation = [operation initWithTarget:self
                                 selector:@selector(sendMulticalRequest:)
                                   object:operation];
    
    [self.sendIEC62056_21RequestOperationQueue addOperation:operation];

}

- (void)sendMulticalRequest:(NSOperation *)theOperation {
    self.readyToSend = NO;
    
    [self.sendRequestDelegate sendRequest:[NSString stringWithFormat:@"%02x", PROTO_IEC61107]];
    [NSThread sleepForTimeInterval:0.04];
    [self.sendRequestDelegate sendRequest:@"2f3f210d0a"];     // /?!\n\r          EN61107
    self.framesToSend++;
    while(!self.readyToSend ){
        if ([theOperation isCancelled]) {
            return;
        }
        [NSThread sleepForTimeInterval:0.01];
    }
    [NSThread sleepForTimeInterval:0.1];
    
    if ([iec62056_21.responseData[@"ident"] isEqualToString:@"KAM0MC"]) {
        [self.sendRequestDelegate sendRequest:[NSString stringWithFormat:@"%02x", PROTO_IEC61107]];
        [NSThread sleepForTimeInterval:0.04];
        [self.sendRequestDelegate sendRequest:@"063030300d0a"];   // [ACK]000\n\r
        self.framesToSend++;
        while(!self.readyToSend ){
            if ([theOperation isCancelled]) {
                return;
            }
            [NSThread sleepForTimeInterval:0.01];
        }
    }
}


@end
