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

//@property NSDictionary *responseDataDict;
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

//@synthesize responseDataDict;
@synthesize receiveDataProgressTimer;
@synthesize data;



- (id)init
{
    self = [super init];
    
    self.iec62056_21 = [[IEC62056_21 alloc] init];
    data = [[NSMutableData alloc] init];

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
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector( timerTimeout ) userInfo:nil repeats:NO];
        
    }
    else {
        // if its not running start a new one
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector( timerTimeout ) userInfo:nil repeats:NO];
        
    }
}
-(void)timerTimeout
{
    self.framesReceived++;
    // decode
    [self.iec62056_21 decodeFrame:data];
    if (self.iec62056_21.errorReceiving) {
        NSLog(@"Retransmit");
        self.framesToSend = 0;
        self.framesReceived = 0;
        data = [[NSMutableData alloc] init];       // clear data after use
        self.iec62056_21.responseData = [[NSMutableDictionary alloc] init];
        // stop all already running sendIEC62056_21Requests
        [self.sendIEC62056_21RequestOperationQueue cancelAllOperations];
        
        // restart progress bar
        
        // and start a new one
        NSInvocationOperation *operation = [NSInvocationOperation alloc];
        operation = [operation initWithTarget:self
                                     selector:@selector(sendMulticalRequest:)
                                       object:operation];
        
        [self.sendIEC62056_21RequestOperationQueue addOperation:operation];
        return;
    }

    if (self.iec62056_21.frameReceived)
    {
        if (
            ((self.framesReceived == 2) && (self.framesToSend == 2))
            ||
            ([iec62056_21.responseData[@"ident"] isEqualToString:@"KAM MC"]))
        {
            NSDictionary * responseDataDict = [[NSDictionary alloc] init];
            for (NSNumber *rid in self.iec62056_21.registerIDTable) {
                    //NSLog(@"doneReceiving: updating %@", self.iec62056_21.responseData[rid][@"value"]);
                [responseDataDict setValue:self.iec62056_21.responseData[rid][@"value"] forKey:self.iec62056_21.registerIDTable[rid]];
            }
            [self.deviceModelUpdatedDelegate doneReceiving:responseDataDict];
        }
        self.readyToSend = YES;
    }
}


/*
- (void)doneReceiving:(NSTimer* )sender {
    NSData * data=sender.userInfo;
    NSLog(@"Done receiving %@", data);
    
    //NSLog(@"Done receiving ascii \"%@\"", [[NSString alloc] initWithData: encoding:NSASCIIStringEncoding]);
    self.framesReceived++;
    // decode
    [self.iec62056_21 decodeFrame:data];
    if (self.iec62056_21.frameReceived) {
        for (NSNumber *rid in self.iec62056_21.registerIDTable) {
            if (self.iec62056_21.responseData[rid] && self.myDataObject.sampleDataDict[self.iec62056_21.registerIDTable[rid]]) {
                //NSLog(@"doneReceiving: updating %@", self.iec62056_21.responseData[rid][@"value"]);
                //self.myDataObject.sampleDataDict[self.iec62056_21.registerIDTable[rid]] = self.iec62056_21.responseData[rid][@"value"];
                
            }
        }
        
        if ((self.framesReceived == 1) && (self.framesToSend == 1)) {
            if ([iec62056_21.responseData[@"ident"] isEqualToString:@"KAM MC"]) {  // Kamstrup Multical, 2001
                // sends data after ack in same frame
                // [self.receiveDataProgressView setHidden:YES];
                // [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
                
                //update table view
                self.state = YES;
                [self.detailsTableView reloadData];
            }
        }
        if ((self.framesReceived == 2) && (self.framesToSend == 2)) {
            // last frame received
            //[self.receiveDataProgressView setHidden:YES];
            //[[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
            
            //update table view
            self.state = YES;
            [self.detailsTableView reloadData];
        }
        
        //  data = [[NSMutableData alloc] init];       // clear data after use
        
        self.readyToSend = YES;
    }
    
    if (self.iec62056_21.errorReceiving) {
        NSLog(@"Retransmit");
        self.framesToSend = 0;
        self.framesReceived = 0;
        data = [[NSMutableData alloc] init];       // clear data after use
        self.iec62056_21.responseData = [[NSMutableDictionary alloc] init];
        // stop all already running sendIEC62056_21Requests
        [self.sendIEC62056_21RequestOperationQueue cancelAllOperations];
        
        // restart progress bar
        [self.receiveDataProgressView setProgress:0.0];
        
        // and start a new one
        NSInvocationOperation *operation = [NSInvocationOperation alloc];
        operation = [operation initWithTarget:self
                                     selector:@selector(sendMulticalRequest:)
                                       object:operation];
        
        //[self.sendIEC62056_21RequestOperationQueue addOperation:operation];
    }
    
}
*/


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
    
    [self.deviceViewControllerSendToNewSampleViewControllerDelegate sendRequest:[NSString stringWithFormat:@"%02x", PROTO_IEC61107]];
    [NSThread sleepForTimeInterval:0.04];
    [self.deviceViewControllerSendToNewSampleViewControllerDelegate sendRequest:@"2f3f210d0a"];     // /?!\n\r          EN61107
    self.framesToSend++;
    while(!self.readyToSend ){
        if ([theOperation isCancelled]) {
            return;
        }
        [NSThread sleepForTimeInterval:0.01];
    }
    [NSThread sleepForTimeInterval:0.1];
    
    if ([iec62056_21.responseData[@"ident"] isEqualToString:@"KAM0MC"]) {
        [self.deviceViewControllerSendToNewSampleViewControllerDelegate sendRequest:[NSString stringWithFormat:@"%02x", PROTO_IEC61107]];
        [NSThread sleepForTimeInterval:0.04];
        [self.deviceViewControllerSendToNewSampleViewControllerDelegate sendRequest:@"063030300d0a"];   // [ACK]000\n\r
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
