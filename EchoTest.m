//
//  EchoTest.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "EchoTest.h"

@interface EchoTest ()
@property (nonatomic,assign) SensorSampleDataObject *  myDataObject;

@end

@implementation EchoTest
@synthesize sendRequestDelegate;
@synthesize receiveTimer;
@synthesize myDataObject;

-(id)init
{
    NSLog(@"lol");
    self = [super init];
    return self;
}
//inits with a dictionary holding a viewcontroller to be set as delegate for sendrequest stuff
-(id)initWithDictionary:(NSDictionary *)dictionary ;//= /* parse the JSON response to a dictionary */;
{
    NSLog(@"sensor init with dictionary");
    [self setSendRequestDelegate:[dictionary valueForKey:@"delegate"]];
    
    [self setMyDataObject:[dictionary valueForKey:@"dataObject"]];
    NSLog(@"%@",[myDataObject description]);



    self = [super init];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"content loaded with %@",nibNameOrNil);
        // Custom initialization

    }
    NSLog(@"content loaded");
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sendRequestDelegate sendRequest:@"ff"];
    
    [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
    if([self.myDataObject.sampleDataDict valueForKey:@"data"])
    {
        NSString * tmp=[self.myDataObject.sampleDataDict valueForKey:@"data"];
        [self.myTextView setText:tmp];
    }
    else
    {
        NSLog(@"mydataobject is empty");
        [self.receiveDataProgress startAnimating];
    }

    
    [self.sendRequestDelegate sendRequest:@"2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a20202020202020746573746f203331300a2056332e332020202020202034323830333630302f320a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a436f6d70616e795f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0a0a416464726573735f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0a0a50686f6e655f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0a0a2031352e342e32303134202020506d31303a31343a33320a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a4675656c2020202020202020576f6f642070656c6c6574730a434f324d41582020202020202020202020202032302e37250a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a2d2e2d2d2d2d202020202020526174696f0a2d2d2e2d2520202020202020434f320a2d2d2e2d25202020202020204f320a2d2d2e2d70706d2020202020434f0a2d2d2e2db043202020202020466c75656761732074656d700a2d2d2e2d2520202020202020457863657373206169720a2d2d2e2d6d6d48324f202020447261756768740a2d2d2e2d2520202020202020454646206e65740a2d2d2e2d70706d2020202020416d6269656e7420434f0a2d2d2e2d25202020202020204546462067726f73730a2d2d2e2d6d6d48324f202020446966662e2070726573732e0a31382e37b043202020202020416d6269656e742074656d700a2d2d2e2d70706d2020202020556e64696c7574656420434f0a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a536d6f6b65206e6f2e202020202020202020205f205f205f0a0a536d6f6b65206e6f2e202020202020202020205f0a0a4843542020202020202020202020202020205f5f5f5fb0430a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0a466f727175657374696f6e2063616c6c2d5f5f5f5f5f5f5f0a"];
    

    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) receivedChar:(char)input;
{
    if ([self.receiveDataProgress isAnimating]) {
        [self.receiveDataProgress stopAnimating];
    }

    self.myTextView.text = [self.myTextView.text stringByAppendingString:[NSString stringWithFormat:@"%c",input]];
    [self.myTextView scrollRangeToVisible:NSMakeRange([self.myTextView.text length], 0)];
    NSLog(@"EchoTest received %c", input);

    if (self.receiveTimer) {
        // stop it
        [self.receiveTimer invalidate];
        self.receiveTimer = nil;        // let it be deallocated
        // and start a new timer
        self.receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(doneReceiving) userInfo:nil repeats:NO];
    }
    else {
        // if its not running start a new one
        self.receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(doneReceiving) userInfo:nil repeats:NO];
    }
}

- (void)doneReceiving {
    NSLog(@"Done receiving");
    NSLog(@"length: %d", self.myTextView.text.length);
    [self.myTextView scrollRangeToVisible:NSMakeRange([self.myTextView.text length], 0)];
}

- (SensorSampleDataObject *)getDataObject
{
    [self.myDataObject setPlaceName:@"loppen hihi"];

    NSDictionary *dictionary = @{
                                 @"data" : self.myTextView.text
                                 };
    [self.myDataObject setSampleDataDict:dictionary];
    return self.myDataObject;
}


@end
