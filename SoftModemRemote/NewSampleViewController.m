//
//  NewSampleViewController.m
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "NewSampleViewController.h"

//#import "UIView+Layout.h"
#import "NSString+HexColor.h"
#import "FSKSerialGenerator.h"
#include <ctype.h>
#include "ProtocolHelper.h"

/*
@interface NSString (NSStringHexToBytes)
-(NSData*) hexToBytes ;
@end

@implementation NSString (NSStringHexToBytes)
-(NSData*) hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
*/

@interface NewSampleViewController ()
@property (nonatomic) NSOperationQueue *operationQueue;

@end

@implementation NewSampleViewController

@synthesize delegate;
@synthesize counter;
@synthesize activity;
@synthesize sendButton;

-(id)init {
    NSLog(@"init");
    self = [super init];
    
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"new sample view loaded");
    // assign delegate
    [APP_DELEGATE.receiveDelegate setDelegate:self];
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    NSString *hexString=@"ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00";
    [self sendRequest:hexString];
    
    counter=0;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



-(void)chaCha:(char)myChar;
{
    UInt8 a =(UInt8)myChar;
    counter++;
    NSLog(@"input:\t%u\tcounter:%d", myChar & 0xff,counter);


}

-(void) sendRequest:(NSString*) hexString{
    [activity startAnimating];

    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    /*operation=[operation initWithTarget:self
                               selector:@selector(encodeStringToBytesAndSend:)
                                 object:[NSArray arrayWithObjects:hexString,operation, nil]
                                         ];*/
    operation=[operation initWithTarget:self
                               selector:@selector(test:)
                                 object:operation
               ];
    typeof(operation) __weak weakOperation = operation;
    
    [self.operationQueue addOperation:operation];
}

/****************************
 encodeStringToBytesAndSend:
 
 takes an nsarray holding a hexstring an a reference to an operation object
 sends data to audio generator and returns on finish or if operation is canceled
 ****************************/
-(void) encodeStringToBytesAndSend:(NSArray*)params{
    NSString * hexString=[params objectAtIndex:0];
    
    NSInvocationOperation *operation = (NSInvocationOperation *)[params objectAtIndex:1];

    NSData* hexData = [[[ProtocolHelper alloc] init]hexStringToBytes:hexString];
    NSLog(@"hexstring: %@", hexString);
    NSLog(@"converted to bytes: %@", hexData);
    
    //stoffers protocol dictates:
    [APP_DELEGATE.generator writeByte:(UInt8)255];

    const char *bytes = [hexData bytes];
    for (int i = 0; i < [hexData length]; i++)
    {
        if ([operation isCancelled])
        {
            NSLog(@"operation cancelled");
            break;
        }
        [NSThread sleepForTimeInterval:0.01]; // This will sleep for 10 millis
        [APP_DELEGATE.generator writeByte:(UInt8)bytes[i]];
    }
    
    [self performSelectorOnMainThread:@selector(updateAfterSend)
                           withObject:nil
                        waitUntilDone:NO];

}

-(void) test:(id)object{
    NSInvocationOperation *operation = (NSInvocationOperation *)object;

    [APP_DELEGATE.generator writeByte:(UInt8)255];

    for (UInt8 i = 0; i < 255; i++)
    {
        if ([operation isCancelled])
        {
            NSLog(@"operation cancelled");
            return;
        }

//        usleep(100000);
        [NSThread sleepForTimeInterval:0.01]; // This will sleep for 2 seconds

        [APP_DELEGATE.generator writeByte:i];
    }
    NSLog(@"done sending test");
    //[APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];
    
}

- (void)updateAfterSend{
    NSLog(@"reached Update after send");
    [activity stopAnimating];
    [sendButton setEnabled:true];
}

/****************************
 cancel:
 used to tell delegate that cancel button is pressed
 ****************************/
- (IBAction)cancel:(UIBarButtonItem *)sender {
    NSLog(@"sending cancel");
    [self.operationQueue cancelAllOperations];
    [delegate NewSampleViewControllerDidCancel:self];
    
}
/****************************
 cancel:
 used to tell delegate that cancel button is pressed
 ****************************/
- (IBAction)done:(UIBarButtonItem *)sender {
    NSLog(@"sending done");
    [self.operationQueue cancelAllOperations];
    [delegate NewSampleViewControllerDidSave:self];
}

- (void)dealloc {
    NSLog(@"dealloc");

    [super dealloc];
}
@end
