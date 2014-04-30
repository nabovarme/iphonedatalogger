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
    
    NSString *hexString=@"ff00a5ff";
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
    //NSLog(@"input");
    UInt8 a =(UInt8)myChar;
    /*
    if(a==255){
        [self performSelectorOnMainThread:@selector(updateAfterSend)
                               withObject:nil
                            waitUntilDone:NO];
    } */
    counter++;
    NSLog(@"input:\t%u\tcounter:%d", myChar & 0xff,counter);


}

-(void) sendRequest:(NSString*) hexString{
    /*
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(encodeStringToBytesAndSend:)
                                                                              object:hexString];
    */
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(test)
                                                                              object:nil];
    typeof(operation) __weak weakOperation = operation;
    
    [self.operationQueue addOperation:operation];

    /*[operation setCompletionBlock:^{
     [self performSelectorOnMainThread:@selector(updateAfterSend)
     withObject:nil
     waitUntilDone:NO];
     }];*/
}

-(void) encodeStringToBytesAndSend:(NSString*)hexString{
    NSData* hexData = [[[ProtocolHelper alloc] init]hexStringToBytes:hexString];
    NSLog(@"hexstring: %@", hexString);
    NSLog(@"converted to bytes: %@", hexData);
    
    //stoffers protocol dictates:
    [APP_DELEGATE.generator writeByte:(UInt8)255];

    const char *bytes = [hexData bytes];
    for (int i = 0; i < [hexData length]; i++)
    {
        usleep(100);
        [APP_DELEGATE.generator writeByte:(UInt8)bytes[i]];
    }
    //[APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];
    
}
-(void) test{

    [APP_DELEGATE.generator writeByte:(UInt8)255];

    for (UInt8 i = 0; i < 255; i++)
    {
//        usleep(100000);
        [NSThread sleepForTimeInterval:0.1]; // This will sleep for 2 seconds

        [APP_DELEGATE.generator writeByte:i];
    }
    NSLog(@"done sending test");
    //[APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];
    
}

- (void)updateAfterSend{
    NSLog(@"received last byte 255");
}


- (IBAction)cancel:(UIBarButtonItem *)sender {
    NSLog(@"sending cancel");
    [APP_DELEGATE resetGenerator];
    [delegate NewSampleViewControllerDidCancel:self];
    
}

- (IBAction)done:(UIBarButtonItem *)sender {
    NSLog(@"sending done");
    
    [delegate NewSampleViewControllerDidSave:self];
}

- (void)dealloc {
    NSLog(@"dealloc");

    [super dealloc];
}
@end
