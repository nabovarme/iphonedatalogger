//
//  Multical601Request.m
//  MeterLogger
//
//  Created by johannes on 6/26/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "Multical601Request.h"

@interface Multical601Request()

// private
@property BOOL readyToSend;
@property unsigned char framesToSend;
@property unsigned char framesReceived;
//@property DeviceSampleDataObject *myDataObject;
//@property NSArray *orderedNames;
@property NSMutableData *data;
//@property BOOL state;

@end

@implementation Multical601Request

//@synthesize sendRequestDelegate;
@synthesize sendKMPRequestOperationQueue;
@synthesize readyToSend;
@synthesize framesToSend;
@synthesize framesReceived;
@synthesize myDataObject;
@synthesize orderedNames;
@synthesize data;
@synthesize state;
@synthesize kmp;

@synthesize DeviceRequestSendToNewSampleViewControllerDelegate;
@synthesize DeviceRequestSendToDeviceViewControllerDelegate;

- (void)receivedChar:(unsigned char)input;
{
    //NSLog(@"Kamstrup received %02x", input);
    // save incoming data do our sampleDataDict
    NSData *inputData = [NSData dataWithBytes:(unsigned char[]){input} length:1];
    [self.data appendData:inputData];
    
    [self.receiveDataProgressView setProgress:(self.receiveDataProgressView.progress + 0.0075) animated:YES];
    
    if ((input == 0x0d) || (input == 0x06)) {   // last character from kamstrup
        [self.DeviceRequestSendToDeviceViewControllerDelegate doneReceiving:<#(NSDictionary *)#>];
    }
}


- (void)sendRequest {

}


- (void)sendMultical601Request:(NSOperation *)theOperation {
    // read Kamstrup601PropertyList.plist to get rid's to send
    NSString *kamstrup601Plist = [[NSBundle mainBundle] pathForResource:@"Kamstrup601PropertyList" ofType:@"plist"];
    NSArray *registerNameArray = [NSArray arrayWithContentsOfFile:kamstrup601Plist];
    
    // get rid's
    NSMutableArray *ridArray = [NSMutableArray array];
    for (NSString *registerName in registerNameArray) {
        NSNumber *rid = [[self.kmp.registerIDTable allKeysForObject:registerName] lastObject];
        if (rid) {
            NSLog(@"rid %@ value \"%@\"", rid, registerName);
            if (![ridArray containsObject:rid]) {
                // add unique rid's to rids
                [ridArray addObject:rid];
            }
        }
    }
    self.framesToSend = (unsigned int)ceil(ridArray.count / 8.0);
    
    // request 8 registers at a time
    for (unsigned int i = 0; i < self.framesToSend; i++) {
        unsigned int remainingRidCount = ridArray.count - i * 8;
        
        NSArray *registerOctet;
        if (remainingRidCount >= 8) {
            NSRange range = NSMakeRange(8 * i, 8);
            registerOctet = [ridArray subarrayWithRange:range];
        }
        else {
            NSRange range = NSMakeRange(8 * i, remainingRidCount);
            registerOctet = [ridArray subarrayWithRange:range];
        }
        
        self.readyToSend = NO;
        [self.sendRequestDelegate sendRequest:PROTO_KAMSTRUP];
        [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
        [self.kmp prepareFrameWithRegistersFromArray:registerOctet];
        [self.sendRequestDelegate sendRequest:[self dataToHexString:self.kmp.frame]];
        self.kmp.frame = [[NSMutableData alloc] initWithBytes:NULL length:0];    // free the frame
        
        // wait for end of data
        while(!self.readyToSend ){
            if ([theOperation isCancelled]) {
                return;
            }
            [NSThread sleepForTimeInterval:0.01];
        }
    }
}


@end
