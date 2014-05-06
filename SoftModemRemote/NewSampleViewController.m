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
#import "FSKRecognizer.h"
#include <ctype.h>
#import "ProtocolHelper.h"

#import "Testo.h"
#import "EchoTest.h"


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
@property UIViewController  *currentDetailViewController;

@end

@implementation NewSampleViewController

@synthesize delegate=_delegate;
@synthesize contentDelegate=_contentDelegate;
//@synthesize activity;
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
- (id)initWithViewController:(UIViewController*)viewController{
    
    self = [super init];
    
    if(self){
        [self presentDetailController:viewController];
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
    
    // Do any additional setup after loading the view.
    
    //     [NSClassFromString(sensorName) presentInViewController:self]; //loads custom view
    
    //Load the first detail controller
    //    NSString *sensorName=@"Testo";
    NSString *sensorName=@"EchoTest";      // echo test
    
    // Class contentViewClass=NSClassFromString(sensorName)
    
    //contentViewClass *_newContentView = [[contentViewClass alloc] init];
    
    _contentDelegate = [[NSClassFromString(sensorName) alloc] init];
    //[self presentDetailController:(UIViewController*)[[NSClassFromString(sensorName) alloc] init]];
    [self presentDetailController:self.contentDelegate];
    
    //[SensorTestoView presentInViewController:self]; //loads custom view
    [super viewDidLoad];
    

    // send command via FSK
    [self sendRequest:[self.contentDelegate selectProtocolCommand]];
    [NSThread sleepForTimeInterval:0.04]; // This will sleep for 40 millis
    [self sendRequest:@"2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a20202020202020746573746f203331300a2056332e332020202020202034323830333630302f320a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a436f6d70616e795f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0a0a416464726573735f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0a0a50686f6e655f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0a0a2031352e342e32303134202020506d31303a31343a33320a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a4675656c2020202020202020576f6f642070656c6c6574730a434f324d41582020202020202020202020202032302e37250a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a2d2e2d2d2d2d202020202020526174696f0a2d2d2e2d2520202020202020434f320a2d2d2e2d25202020202020204f320a2d2d2e2d70706d2020202020434f0a2d2d2e2db043202020202020466c75656761732074656d700a2d2d2e2d2520202020202020457863657373206169720a2d2d2e2d6d6d48324f202020447261756768740a2d2d2e2d2520202020202020454646206e65740a2d2d2e2d70706d2020202020416d6269656e7420434f0a2d2d2e2d25202020202020204546462067726f73730a2d2d2e2d6d6d48324f202020446966662e2070726573732e0a31382e37b043202020202020416d6269656e742074656d700a2d2d2e2d70706d2020202020556e64696c7574656420434f0a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a536d6f6b65206e6f2e202020202020202020205f205f205f0a0a536d6f6b65206e6f2e202020202020202020205f0a0a4843542020202020202020202020202020205f5f5f5fb0430a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a466f727175657374696f6e2063616c6c2d5f5f5f5f5f5f5f0a"];
    
}
- (void)presentDetailController:(UIViewController*)detailVC{
    
    //0. Remove the current Detail View Controller showed
    if(self.currentDetailViewController){
        [self removeCurrentDetailViewController];
    }
    
    //1. Add the detail controller as child of the container
    [self addChildViewController:detailVC];
    
    //2. Define the detail controller's view size
    //detailVC.view.frame = [self frameForDetailController];
    
    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.contentView addSubview:detailVC.view];
    self.currentDetailViewController = detailVC;
    [self setContentDelegate:self.currentDetailViewController];
    
    //4. Complete the add flow calling the function didMoveToParentViewController
    [detailVC didMoveToParentViewController:self];
    
}


- (CGRect)frameForDetailController{
    CGRect detailFrame = self.contentView.bounds;
    
    return detailFrame;
}



- (void)removeCurrentDetailViewController{
    
    //1. Call the willMoveToParentViewController with nil
    //   This is the last method where your detailViewController can perform some operations before neing removed
    [self.currentDetailViewController willMoveToParentViewController:nil];
    
    //2. Remove the DetailViewController's view from the Container
    [self.currentDetailViewController.view removeFromSuperview];
    
    //3. Update the hierarchy"
    //   Automatically the method didMoveToParentViewController: will be called on the detailViewController)
    [self.currentDetailViewController removeFromParentViewController];
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
    //NSLog(@"input");
    NSLog(@"input from delegate%c", input);
    [self.contentDelegate receivedChar:input];
    
	if(isprint(input)){
        //NSLog(@"inputIsAvailableChanged %c", input);
        
		//textReceived.text = [textReceived.text stringByAppendingFormat:@"%c", input];
	}
}


-(void) sendRequest:(NSString*) hexString{
    //[activity startAnimating];

    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    operation=[operation initWithTarget:self
                               selector:@selector(encodeStringToBytesAndSend:)
                                 object:[NSArray arrayWithObjects:hexString,operation, nil]
                                         ];

    [self.operationQueue addOperation:operation];
    [operation release];
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
//    [APP_DELEGATE.generator writeByte:(UInt8)0];              // <- should they really be sent here?
//    [NSThread sleepForTimeInterval:0.04]; // This will sleep for 40 millis


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
    //[activity stopAnimating];
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
//    [activity release];
    [saveButton release];
    [protocolHelper release];
    [_contentDelegate release];
    NSLog(@"objects released");
    //[self.operationQueue release];
   // [saveButton release];
    //[activity release];
    //[self.operationQueue cancelAllOperations];
    [super dealloc];

}


#pragma mark - Encapsulate everything (a really flexible, reusable way to load your custom UIView from XIB)



@end
