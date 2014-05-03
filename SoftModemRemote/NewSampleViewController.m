//
//  NewSampleViewController.m
//  SoftModemRemoted
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "NewSampleViewController.h"

//#import "UIView+Layout.h"
#import "NSString+HexColor.h"
#import "FSKSerialGenerator.h"
#import "FSKRecognizer.h";
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
@property (nonatomic,retain) NSOperationQueue *operationQueue;

@end

@implementation NewSampleViewController

@synthesize delegate=_delegate;
@synthesize activity;
@synthesize saveButton;
@synthesize protocolHelper;

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
    NSLog(@"new sample view loaded");
    // assign delegate
    protocolHelper=[[ProtocolHelper alloc] init];
    [APP_DELEGATE.recognizer addReceiver:self];
    _operationQueue = [[NSOperationQueue alloc] init];
    
    NSString *hexString=@"ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00";
    [self sendRequest:hexString];
    [hexString release];
    // Do any additional setup after loading the view.
    [super viewDidLoad];

}
- (void)viewDidUnload
{
    NSLog(@"unloading");
    

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning sample view");
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"going back to table view");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



-(void)chaCha:(char)myChar;
{
   // UInt8 a =(UInt8)myChar;
    NSLog(@"input:\t%u", myChar & 0xff);


}


- (void) receivedChar:(char)input
{
    //NSLog(@"input");
    NSLog(@"input from delegate%c", input);
    
    
	if(isprint(input)){
        //NSLog(@"inputIsAvailableChanged %c", input);
        
		//textReceived.text = [textReceived.text stringByAppendingFormat:@"%c", input];
	}
}


-(void) sendRequest:(NSString*) hexString{
    [activity startAnimating];

    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    operation=[operation initWithTarget:self
                               selector:@selector(encodeStringToBytesAndSend:)
                                 object:[NSArray arrayWithObjects:hexString,operation, nil]
                                         ];

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

    NSData* hexData = [protocolHelper hexStringToBytes:hexString];
    NSLog(@"hexstring: %@", hexString);
    NSLog(@"converted to bytes: %@", hexData);
    
    //stoffers protocol dictates:
    [APP_DELEGATE.generator writeByte:(UInt8)255];
    [NSThread sleepForTimeInterval:0.04]; // This will sleep for 40 millis


    const char *bytes = [hexData bytes];
    for (int i = 0; i < [hexData length]; i++)
    {
        if ([operation isCancelled])
        {
            NSLog(@"operation cancelled");
            return;
        }
        [NSThread sleepForTimeInterval:0.05]; // This will sleep for 50 millis
        [APP_DELEGATE.generator writeByte:(UInt8)bytes[i]];
    }
    
    [self performSelectorOnMainThread:@selector(updateAfterSend)
                           withObject:nil
                        waitUntilDone:YES];
}

-(void) test:(id)object{
    NSInvocationOperation *operation = (NSInvocationOperation *)object;

    [APP_DELEGATE.generator writeByte:(UInt8)255];
    [NSThread sleepForTimeInterval:0.04]; // This will sleep for 40 millis
    for (UInt8 i = 0; i < 255; i++)
    {
        if ([operation isCancelled])
        {
            NSLog(@"operation cancelled");
            break;
        }

        [NSThread sleepForTimeInterval:0.05]; // This will sleep for 40 millis

        [APP_DELEGATE.generator writeByte:i];
    }
    NSLog(@"done sending test");
    //[APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];
    
}

- (void)updateAfterSend{
    NSLog(@"reached Update after send");
    [activity stopAnimating];
    [saveButton setEnabled:true];
}

/****************************
 cancel:
 used to tell delegate that cancel button is pressed
 ****************************/
- (IBAction)cancel:(UIBarButtonItem *)sender {
    NSLog(@"sending cancel");
   // [self.operationQueue cancelAllOperations];
    [_delegate NewSampleViewControllerDidCancel:self];
    
}
/****************************
 save:
 used to tell delegate that done button is pressed
 ****************************/
- (IBAction)save:(UIBarButtonItem *)sender {
        NSLog(@"sending done");
        // [self.operationQueue cancelAllOperations];
        [_delegate NewSampleViewControllerDidSave:self];
}

- (void)dealloc {

    self.delegate=nil;

    NSLog(@"dealloc");
    [_operationQueue cancelAllOperations];
    [_operationQueue waitUntilAllOperationsAreFinished];
    [_operationQueue release ];
   // [APP_DELEGATE myStop];
    [APP_DELEGATE.recognizer removeAllReceivers];

    //[self.operationQueue autorelease];
    NSLog(@"all operations finnished");
    [activity release];
    [saveButton release];
    [protocolHelper release];
    NSLog(@"objects released");
    //[self.operationQueue release];
   // [saveButton release];
    //[activity release];
    //[self.operationQueue cancelAllOperations];
    [super dealloc];

}
@end
