//
//  Multical601Request.m
//  MeterLogger
//
//  Created by johannes on 6/26/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "Multical601Request.h"
#import "MeterLoggerProtocol.h"

@interface Multical601Request()

// private
@property BOOL readyToSend;
@property unsigned char framesToSend;
@property unsigned char framesReceived;
@property DeviceSampleDataObject *myDataObject;
//@property NSArray *orderedNames;
@property NSMutableData *data;
//@property BOOL state;
@property NSTimer *receiveDataProgressTimer;

@end


@implementation Multical601Request

//@synthesize sendRequestDelegate;
@synthesize deviceRequestSendToNewSampleViewControllerDelegate;
@synthesize deviceRequestSendToDeviceViewControllerDelegate;
@synthesize kmp;
@synthesize sendKMPRequestOperationQueue;
@synthesize readyToSend;
@synthesize framesToSend;
@synthesize framesReceived;
@synthesize myDataObject;
//@synthesize orderedNames;

@synthesize receiveDataProgressTimer;
@synthesize data;
//@synthesize state;

- (id)init
{
    self = [super init];
    
    self.kmp = [[KMP alloc] init];
    data = [[NSMutableData alloc] init];
    
    return self;
}

- (void)receivedChar:(unsigned char)input;
{
    //NSLog(@"Kamstrup received %02x", input);
    // save incoming data do our sampleDataDict
    NSData *inputData = [NSData dataWithBytes:(unsigned char[]){input} length:1];
    [self.data appendData:inputData];
    
    //[self.receiveDataProgressView setProgress:(self.receiveDataProgressView.progress + 0.0075) animated:YES];
    
    if ((input == 0x0d) || (input == 0x06)) {   // last character from kamstrup
        [self doneReceiving];
    }
}

- (void)doneReceiving {
    NSLog(@"Done receiving %@", self.data);
    self.framesReceived++;
    // decode kmp frame
    [self.kmp decodeFrame:self.data];
    
    /*
    if (self.kmp.frameReceived) {
        for (NSNumber *rid in self.kmp.registerIDTable) {
            if (self.kmp.responseData[rid] && self.myDataObject.sampleDataDict[self.kmp.registerIDTable[rid]]) {
                //NSLog(@"doneReceiving: updating %@", self.kmp.registerIDTable[rid]);
                
                // format as number
                NSMutableString *valueString = [[[self.kmp numberForKmpNumber:self.kmp.responseData[rid][@"value"] andSiEx:self.kmp.responseData[rid][@"siEx"]] stringValue] mutableCopy];
                
                float valueFloat = atof([valueString UTF8String]);
                // localized number format
                
                valueString = [[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:valueFloat] numberStyle:NSNumberFormatterDecimalStyle] mutableCopy];
                NSString *unit = kmp.registerUnitsTable[kmp.responseData[rid][@"unit"]];
                if (unit && (![unit isEqualToString:@"number"])) {
                    [valueString appendString:@" "];
                    [valueString appendString:unit];
                }
                NSLog(@"valueString %@", valueString);
                self.myDataObject.sampleDataDict[self.kmp.registerIDTable[rid]] = valueString;
            }
        }
        self.data = [[NSMutableData alloc] init];       // clear data after use
        self.kmp.responseData = [[NSMutableDictionary alloc] init];
        
        //update table view
        self.state = YES;
        [self.detailsTableView reloadData];
        
        self.readyToSend = YES;
    }
    
    if (self.kmp.errorReceiving) {
        NSLog(@"Retransmit");
        self.framesReceived = 0;
        self.data = [[NSMutableData alloc] init];       // clear data after use
        self.kmp.responseData = [[NSMutableDictionary alloc] init];
        // stop all already running sendKMPRequests
        [self.sendKMPRequestOperationQueue cancelAllOperations];
        
        // restart progress bar
        //[self.receiveDataProgressView setProgress:0.0];
        
        // and start a new one
        NSInvocationOperation *operation = [NSInvocationOperation alloc];
        operation = [operation initWithTarget:self
                                     selector:@selector(sendKMPRequest:)
                                       object:operation];
        
        [self.sendKMPRequestOperationQueue addOperation:operation];
        
    }
    
    if (self.framesReceived == self.framesToSend) {
        // last frame received
        //[self.receiveDataProgressView setHidden:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
    }
    [self.deviceRequestSendToDeviceViewControllerDelegate doneReceiving:nil];
    */
}

- (void)sendRequest {
    // start sendKMPRequest in a operation queue, so it can be canceled
    self.sendKMPRequestOperationQueue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    operation = [operation initWithTarget:self
                                 selector:@selector(sendKMPRequest:)
                                   object:operation];
    
    [self.sendKMPRequestOperationQueue addOperation:operation];
}


- (void)sendKMPRequest:(NSOperation *)theOperation {
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
        [self.deviceRequestSendToNewSampleViewControllerDelegate sendRequest:[NSString stringWithFormat:@"%02x", PROTO_KAMSTRUP]];
        [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
        [self.kmp prepareFrameWithRegistersFromArray:registerOctet];
        [self.deviceRequestSendToNewSampleViewControllerDelegate sendRequest:[self dataToHexString:self.kmp.frame]];
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

#pragma mark - Stupid redundant code

-(NSString *) dataToHexString:(NSData *) theData {
    NSString *result = [[theData description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result substringWithRange:NSMakeRange(1, [result length] - 2)];
    return result;
}


@end
