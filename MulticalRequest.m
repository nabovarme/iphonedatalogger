//
//  MulticalRequest.m
//  MeterLogger
//
//  Created by stoffer on 23/06/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import "MulticalRequest.h"
#import "MeterLoggerProtocol.h"

#define RECEIVE_DATA_TIME (4.0f)
#define RECEIVE_DATA_PROGRESS_TIMER_UPDATE_INTERVAL (0.2f)

@interface MulticalRequest()

// private
//@property (nonatomic, assign) id<DeviceViewControllerSendRequest> sendRequestDelegate;
@property NSOperationQueue *sendIEC62056_21RequestOperationQueue;
@property BOOL readyToSend;
@property unsigned char framesToSend;
@property unsigned char framesReceived;

@property NSMutableData *data;
@property NSTimer *receiveDataProgressTimer;




@end

@implementation MulticalRequest

@synthesize deviceViewControllerSendToNewSampleViewControllerDelegate;
@synthesize deviceModelUpdatedDelegate;
@synthesize iec62056_21;
@synthesize sendIEC62056_21RequestOperationQueue;
@synthesize readyToSend;
@synthesize framesToSend;
@synthesize framesReceived;

@synthesize receiveDataProgressTimer;
@synthesize data;



- (id)init
{
    self = [super init];
    
    self.iec62056_21 = [[IEC62056_21 alloc] init];
    
    return self;
}
/*
- (void)receivedChar:(unsigned char)input;
{
    NSLog(@"lol multical received a char lol");
}
  */

- (void)receivedChar:(unsigned char)input {
    //NSLog(@"Multical received %c (%d)", input, input);
    // save incoming data do our sampleDataDict
    NSData *inputData = [NSData dataWithBytes:(unsigned char[]){input} length:1];
    [self.data appendData:inputData];
    
   // [self.receiveDataProgressView setProgress:(self.receiveDataProgressView.progress + 0.003) animated:YES];
    
    if (self.receiveDataProgressTimer) {
        // stop it
        [self.receiveDataProgressTimer invalidate];
        self.receiveDataProgressTimer = nil;        // let it be deallocated
        // and start a new timer
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self.deviceModelUpdatedDelegate selector:@selector( doneReceiving: ) userInfo:self.data repeats:NO];
        
    }
    else {
        // if its not running start a new one
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doneReceiving) userInfo:nil repeats:NO];
    }
}

- (void)sendRequest {
//    self.sendRequestDelegate = theSendRequestDelegate;
    
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
