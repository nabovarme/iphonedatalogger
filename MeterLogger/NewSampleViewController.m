//
//  NewSampleViewController.m
//  SoftModemRemoted
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "NewSampleViewController.h"

#import "NSString+HexColor.h"
#import "FSKSerialGenerator.h"
#import "FSKRecognizer.h"
#include <ctype.h>


@interface NewSampleViewController ()
@property (nonatomic,retain) NSOperationQueue *operationQueue;
@property UIViewController  *currentDetailViewController;

@end

@implementation NewSampleViewController

@synthesize cancelSaveDelegate;//=_cancelSaveDelegate;
@synthesize receivedCharDelegate;//=_receivedCharDelegate;
@synthesize saveButton;
@synthesize protocolHelper;
@synthesize deviceName;

-(id)init {
    NSLog(@"init");
    self = [super init];
    
    
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.navigationItem.backBarButtonItem.title = @"but This Works";
    NSLog(@"new sample view loaded");
    // assign delegate
    protocolHelper = [[ProtocolHelper alloc] init];
    [APP_DELEGATE.recognizer addReceiver:self];
    _operationQueue = [[NSOperationQueue alloc] init];


    /*propertyList
    NSString *devicePlistString=[NSString stringWithFormat:@"%@PropertyList",self.deviceName];
    NSString *devicePlist = [[NSBundle mainBundle] pathForResource:devicePlistString ofType:@"plist"];
    NSMutableDictionary *deviceDict = [[[NSDictionary alloc] initWithContentsOfFile:devicePlist] mutableCopy];
   */
    DeviceSampleDataObject *dataObject = [[DeviceSampleDataObject alloc]init];
    dataObject.placeName = @"";
    dataObject.date=[[NSDate alloc]init];
    dataObject.deviceName = self.deviceName;
    dataObject.sampleDataDict=[@{} mutableCopy];
    //dataObject.sampleDataDict=deviceDict;
    NSDictionary *dictionary = @{
                                @"delegate" : self,
                                @"dataObject":dataObject
                                };
    
    [self presentDetailController:(UIViewController *)[[ NSClassFromString(self.deviceName) alloc] initWithDictionary:dictionary]];

    [super viewDidLoad];
    
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
    [self setReceivedCharDelegate : self.currentDetailViewController];
    //[self.receivedCharDelegate setSelfAsSendRequestDelegate:self];

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
  //  NSLog(@"input from delegate%c", input);
    [self.receivedCharDelegate receivedChar:input];
}


-(void) sendRequest:(NSString*) hexString{
    //[activity startAnimating];

    NSInvocationOperation *operation = [NSInvocationOperation alloc];
    operation=[operation initWithTarget:self
                               selector:@selector(encodeStringToBytesAndSend:)
                                 object:[NSArray arrayWithObjects:hexString,operation, nil]
                                         ];

    [self.operationQueue addOperation:operation];
//    [operation release];
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
   /*
    [self performSelectorOnMainThread:@selector(updateAfterSend)
                           withObject:nil
                        waitUntilDone:YES];
    */
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

    //[self.cancelSaveDelegate NewSampleViewControllerDidCancel:self];
    [self.navigationController popViewControllerAnimated:YES];

    [self terminate];

}
/****************************
 save:
 used to tell delegate that done button is pressed
 ****************************/
- (IBAction)save:(UIBarButtonItem *)sender {
        NSLog(@"sending done");
        [self.cancelSaveDelegate NewSampleViewControllerDidSave:self];
    [self terminate];

}

- (DeviceSampleDataObject *)getDataObject
{
    id tmp=self.receivedCharDelegate;
    
    //[self.receivedCharDelegate lort];
    DeviceSampleDataObject *tmp2 = [tmp getDataObject];//=[self.receivedCharDelegate getDataObject];
   return tmp2;
}


-(void) terminate
{
    [_operationQueue cancelAllOperations];
    [_operationQueue waitUntilAllOperationsAreFinished];
    [self setReceivedCharDelegate:nil];
}

- (void)dealloc {

    self.cancelSaveDelegate=nil;

    NSLog(@"dealloc");
    [_operationQueue cancelAllOperations];
    [_operationQueue waitUntilAllOperationsAreFinished];
//    [_operationQueue release ];
   // [APP_DELEGATE myStop];
    [APP_DELEGATE.recognizer removeAllReceivers];

    //[self.operationQueue autorelease];
    NSLog(@"all operations finnished");
//    [activity release];
//    [saveButton release];
//    [protocolHelper release];
//    [_receivedCharDelegate release];
    NSLog(@"objects released");
    //[self.operationQueue release];
   // [saveButton release];
    //[activity release];
    //[self.operationQueue cancelAllOperations];
//    [super dealloc];

}


#pragma mark - Encapsulate everything (a really flexible, reusable way to load your custom UIView from XIB)



@end
