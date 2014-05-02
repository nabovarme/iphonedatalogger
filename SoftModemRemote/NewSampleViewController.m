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
#include <ctype.h>
#include "ProtocolHelper.h"



#import "AudioSignalAnalyzer.h"
#import "FSKSerialGenerator.h"
#import "FSKRecognizer.h"

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

@synthesize delegate=_delegate;
@synthesize activity;
@synthesize saveButton;

@synthesize generator = _generator;


@synthesize analyzer = _analyzer;

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
    AVAudioSession *session = [AVAudioSession sharedInstance];
	session.delegate = self;
	if(session.inputIsAvailable){
		[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	}else{
		[session setCategory:AVAudioSessionCategoryPlayback error:nil];
	}
	[session setActive:YES error:nil];
	[session setPreferredIOBufferDuration:0.023220 error:nil];
    
	_recognizer = [[FSKRecognizer alloc] init];
	[_recognizer addReceiver:self];
    
	_generator = [[FSKSerialGenerator alloc] init];
	[_generator play];
    
	_analyzer = [[AudioSignalAnalyzer alloc] init];
	[_analyzer addRecognizer:_recognizer];
    
	if(session.inputIsAvailable){
		[_analyzer record];
	}
    
    // assign delegate
//    [APP_DELEGATE add:self];
    //[APP_DELEGATE addReceiver:self];
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    NSString *hexString=@"ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00ff00a5ff00ffa5ff00ffa5ff00";
    [self sendRequest:hexString];
    
    // Do any additional setup after loading the view.
}
#pragma mark - AVAudioSessionDelegate


- (void)inputIsAvailableChanged:(BOOL)isInputAvailable
{
	NSLog(@"inputIsAvailableChanged %d",isInputAvailable);
	
	AVAudioSession *session = [AVAudioSession sharedInstance];
	
	[_analyzer stop];
	[_generator stop];
	
	if(isInputAvailable){
		[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
		[_analyzer record];
	}else{
		[session setCategory:AVAudioSessionCategoryPlayback error:nil];
	}
	[_generator play];
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




- (void) receivedChar:(char)input
{
    NSLog(@"input from view:\t%u", input & 0xff);


}

-(void) sendRequest:(NSString*) hexString{
    [activity startAnimating];

    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    operation=[operation initWithTarget:self
                               selector:@selector(encodeStringToBytesAndSend:)
                                 object:[NSArray arrayWithObjects:hexString,operation, nil]
                                         ];
/*
    operation=[operation initWithTarget:self
                               selector:@selector(test:)
                                 object:operation
               ];
 */
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
    [_generator writeByte:(UInt8)255];
    [NSThread sleepForTimeInterval:0.05]; // This will sleep for 40 millis


    const char *bytes = [hexData bytes];
    for (int i = 0; i < [hexData length]; i++)
    {
        if ([operation isCancelled])
        {
            NSLog(@"operation cancelled");
            return;
        }
        [NSThread sleepForTimeInterval:0.05]; // This will sleep for 50 millis
        [_generator writeByte:(UInt8)bytes[i]];
    }
    /*
    [self performSelectorOnMainThread:@selector(updateAfterSend)
                           withObject:nil
                        waitUntilDone:YES];
*/
}
/*
-(void) test:(id)object{
    NSInvocationOperation *operation = (NSInvocationOperation *)object;

    [_generator writeByte:(UInt8)255];
    [NSThread sleepForTimeInterval:0.04]; // This will sleep for 40 millis
    for (UInt8 i = 0; i < 255; i++)
    {
        if ([operation isCancelled])
        {
            NSLog(@"operation cancelled");
            break;
        }

        [NSThread sleepForTimeInterval:0.05]; // This will sleep for 40 millis

        [_generator writeByte:i];
    }
    NSLog(@"done sending test");
    //[APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];
    
}*/

- (void)updateAfterSend{
    NSLog(@"reached Update after send");
    //[activity stopAnimating];
   // [saveButton setEnabled:true];
}

/****************************
 cancel:
 used to tell delegate that cancel button is pressed
 ****************************/
- (IBAction)cancel:(UIBarButtonItem *)sender {
    NSLog(@"sending cancel");
    [_delegate NewSampleViewControllerDidCancel:self];
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"lol");
    [_analyzer stop];
	[_generator stop];
    [self.operationQueue cancelAllOperations];
    [self.operationQueue waitUntilAllOperationsAreFinished];

    
    [_generator release];
    [_analyzer release];
    [_recognizer release];
    //[self.operationQueue autorelease];
    NSLog(@"all operations finnished");
    [activity release];
    [saveButton release];
    NSLog(@"objects released");
    //[self.operationQueue release];
    // [saveButton release];
    //[activity release];
    //[self.operationQueue cancelAllOperations];

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

   // [APP_DELEGATE removeReceiver:self];
    

//    self.delegate=nil;

    NSLog(@"deallocing view controller");

    [super dealloc];

}
@end
