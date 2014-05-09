//
//  TestoDemo.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "TestoDemo.h"

@interface TestoDemo ()
@property DeviceSampleDataObject *myDataObject;
@property (retain, nonatomic) IBOutlet UITextField *testoO2Level;
@property (retain, nonatomic) IBOutlet UITextField *testoCO2Level;
@property (weak, nonatomic) IBOutlet UITextField *testoCOLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoFlueGasTempLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoExcessAirLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoDraughtLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoEffNetLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoAmbientCOLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoEffGrossLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoDiffPressLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoAmbientTempLevel;
@property (weak, nonatomic) IBOutlet UITextField *testoUndilutedCOLevel;

@end

@implementation TestoDemo
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
    [self setSendRequestDelegate:dictionary[@"delegate"]];
    
    [self setMyDataObject:dictionary[@"dataObject"]];
    self.myDataObject.sampleDataDict = [@{@"data": [@"" mutableCopy]} mutableCopy];
    //self.myDataObject.sampleDataDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"data": [[NSMutableString alloc] initWithString:@""]}];
    
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
    
    // Do any additional setup after loading the view from its nib.
    if([self.myDataObject.sampleDataDict[@"data"] length])
    {
        // details view
//        NSString * tmp=[self.myDataObject.sampleDataDict valueForKey:@"data"];
//        [self.myTextView setText:tmp];
    }
    else
    {
        // new sample view
        NSLog(@"mydataobject is empty");
        [self.receiveDataProgress startAnimating];
        [self.sendRequestDelegate sendRequest:@"ff"];
        
        [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
        
        [self.sendRequestDelegate sendRequest:@"302e30303334202020202020526174696f0d0a352e38322520202020202020434f320d0a31352e3125202020202020204f320d0a31393870706d202020202020434f0d0a36312e38b043202020202020466c75656761732074656d700d0a3235352e3925202020202020457863657373206169720d0a2d2d2e2d6d6d48324f202020447261756768740d0a39332e362520202020202020454646206e65740d0a2d2d2e2d70706d2020202020416d6269656e7420434f0d0a38362e3025202020202020204546462067726f73730d0a2d2d2e2d6d6d48324f202020446966662e2070726573732e0d0a31382e36b043202020202020416d6269656e742074656d700d0a37303670706d202020202020556e64696c7574656420434f0d0a"];
        

    }
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

    // save incoming data do our sampleDataDict
    [self.myDataObject.sampleDataDict[@"data"] appendFormat:@"%c", input];
    
    NSLog(@"TestoDemo received %c", input);

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
    NSLog(@"Done receiving %@", self.myDataObject.sampleDataDict[@"data"]);
    NSLog(@"length: %lu", (unsigned long)[self.myDataObject.sampleDataDict[@"data"] length]);
    
    NSRegularExpression *regex;
    NSString *str;
    NSTextCheckingResult *match;
    
    // match CO2
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+CO2" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoCO2Level.text = [NSString stringWithFormat:@"Carbon dioxide %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"CO2 %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example

    // match O2
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+O2" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoO2Level.text = [NSString stringWithFormat:@"Oxygen %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"O2 %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example

    // match CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+CO\\s" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoCOLevel.text = [NSString stringWithFormat:@"Carbon monoxide %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"O2 %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Fluegas temp
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Fluegas temp" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoFlueGasTempLevel.text = [NSString stringWithFormat:@"Fluegas temp %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Fluegas temp %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Excess air
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Excess air" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoExcessAirLevel.text = [NSString stringWithFormat:@"Excess air %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Excess air %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Draught
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Draught" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoDraughtLevel.text = [NSString stringWithFormat:@"Draught %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Draught %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match EFF net
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+EFF net" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoEffNetLevel.text = [NSString stringWithFormat:@"EFF net %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"EFF net %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Ambient CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Ambient CO" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoAmbientCOLevel.text = [NSString stringWithFormat:@"Ambient CO %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Ambient CO %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match EFF gross
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+EFF gross" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoEffGrossLevel.text = [NSString stringWithFormat:@"EFF gross %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"EFF gross %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Diff. press.
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Diff. press." options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoDiffPressLevel.text = [NSString stringWithFormat:@"Diff. press. %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Diff. press. %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Ambient temp
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Ambient temp" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoAmbientTempLevel.text = [NSString stringWithFormat:@"Ambient temp %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Ambient temp %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example

    // match Undiluted CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Undiluted CO" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    self.testoUndilutedCOLevel.text = [NSString stringWithFormat:@"Undiluted CO %@", [str substringWithRange:[match rangeAtIndex:1]]];
    NSLog(@"Undiluted CO %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
}

- (DeviceSampleDataObject *)getDataObject
{
    [self.myDataObject setPlaceName:@"Nowhere"];

    NSMutableDictionary *dictionary = [@{@"testoOxygenLevel": @"oxygen",
                                         @"testoCarbonDioxide": @2.2,
                                 @"data": self.myDataObject.sampleDataDict[@"data"]
                                 } mutableCopy];
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary: @{@"data": self.myDataObject.sampleDataDict[@"data"]}];
    [self.myDataObject setSampleDataDict:dictionary];
    return self.myDataObject;
}

@end
