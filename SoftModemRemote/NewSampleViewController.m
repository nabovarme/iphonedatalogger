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


@interface NewSampleViewController ()

@end

@implementation NewSampleViewController

@synthesize delegate;

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

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)chaCha:(char)myChar;
{
    //NSLog(@"input");
    NSLog(@"input from view:\t%d", (UInt8)myChar);


}


- (IBAction)SendA5:(UIButton *)sender {
    

    dispatch_queue_t sendQueue = dispatch_queue_create("sendTime",  DISPATCH_QUEUE_SERIAL);
    dispatch_async(sendQueue, ^{
        NSString *hexString=@"0xff00a5ff";
        NSData* hexData = [[[ProtocolHelper alloc] init]hexToBytes:hexString];
        NSLog(@"hexstring: %@", hexString);
        NSLog(@"converted to bytes: %@", hexData);
        [APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];

    });


}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    NSLog(@"sending cancel");

    [delegate NewSampleViewControllerDidCancel:self];
    
}

- (IBAction)done:(UIBarButtonItem *)sender {
    NSLog(@"sending done");
    
    [delegate NewSampleViewControllerDidSave:self];
}

@end
