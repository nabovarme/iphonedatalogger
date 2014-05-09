//
//  Testo.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "Testo.h"

@interface Testo ()
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

@implementation Testo
@synthesize sendRequestDelegate;
@synthesize receiveTimer;
@synthesize myDataObject;

-(id)init
{
    self = [super init];
    return self;
}

//inits with a dictionary holding a viewcontroller to be set as delegate for sendrequest stuff
-(id)initWithDictionary:(NSDictionary *)dictionary ;//= /* parse the JSON response to a dictionary */;
{
    NSLog(@"sensor init with dictionary");
    [self setSendRequestDelegate:dictionary[@"delegate"]];
    
    // set myDataObject to the one passed in dictionary key dataObject
    [self setMyDataObject:dictionary[@"dataObject"]];
    
    if([self.myDataObject.sampleDataDict[@"data"] length] == 0) {
        // if there is no data saved init sampleDataDict empty
        self.myDataObject.sampleDataDict = [@{@"data": [@"" mutableCopy]} mutableCopy];
        //self.myDataObject.sampleDataDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"data": [[NSMutableString alloc] initWithString:@""]}];
    }
    
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
    if([self.myDataObject.sampleDataDict[@"data"] length] != 0)
    {
        // details view
        [self.testoCO2Level setText:self.myDataObject.sampleDataDict[@"testoCO2Level"]];
        [self.testoO2Level setText:self.myDataObject.sampleDataDict[@"testoO2Level"]];
        [self.testoCOLevel setText:self.myDataObject.sampleDataDict[@"testoCOLevel"]];
        [self.testoFlueGasTempLevel setText:self.myDataObject.sampleDataDict[@"testoFlueGasTempLevel"]];
        [self.testoExcessAirLevel setText:self.myDataObject.sampleDataDict[@"testoExcessAirLevel"]];
        [self.testoDraughtLevel setText:self.myDataObject.sampleDataDict[@"testoDraughtLevel"]];
        [self.testoEffNetLevel setText:self.myDataObject.sampleDataDict[@"testoEffNetLevel"]];
        [self.testoAmbientCOLevel setText:self.myDataObject.sampleDataDict[@"testoAmbientCOLevel"]];
        [self.testoEffGrossLevel setText:self.myDataObject.sampleDataDict[@"testoEffGrossLevel"]];
        [self.testoDiffPressLevel setText:self.myDataObject.sampleDataDict[@"testoDiffPressLevel"]];
        [self.testoAmbientTempLevel setText:self.myDataObject.sampleDataDict[@"testoAmbientTempLevel"]];
        [self.testoUndilutedCOLevel setText:self.myDataObject.sampleDataDict[@"testoUndilutedCOLevel"]];
    }
    else
    {
        // new sample view
        NSLog(@"mydataobject is empty");
        [self.receiveDataProgress startAnimating];
        [self.sendRequestDelegate sendRequest:@"00"];
        [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) receivedChar:(char)input;
{
    // save incoming data do our sampleDataDict
    [self.myDataObject.sampleDataDict[@"data"] appendFormat:@"%c", input];
    
    NSLog(@"Testo received %c", input);
    
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
    
    if ([self.receiveDataProgress isAnimating]) {
        [self.receiveDataProgress stopAnimating];
    }
    
    NSRegularExpression *regex;
    NSString *str;
    NSTextCheckingResult *match;
    NSString *testoValue;
    
    // match CO2
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+CO2\\s" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoCO2Level.text = [NSString stringWithFormat:@"Carbon dioxide %@", testoValue];
    NSLog(@"CO2 %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match O2
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+O2" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoO2Level.text = [NSString stringWithFormat:@"Oxygen %@", testoValue];
    NSLog(@"O2 %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+CO\\s" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoCOLevel.text = [NSString stringWithFormat:@"Carbon monoxide %@", testoValue];
    NSLog(@"O2 %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Fluegas temp
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Fluegas temp" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoFlueGasTempLevel.text = [NSString stringWithFormat:@"Fluegas temp %@", testoValue];
    NSLog(@"Fluegas temp %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Excess air
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Excess air" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoExcessAirLevel.text = [NSString stringWithFormat:@"Excess air %@", testoValue];
    NSLog(@"Excess air %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Draught
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Draught" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoDraughtLevel.text = [NSString stringWithFormat:@"Draught %@", testoValue];
    NSLog(@"Draught %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match EFF net
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+EFF net" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoEffNetLevel.text = [NSString stringWithFormat:@"EFF net %@", testoValue];
    NSLog(@"EFF net %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Ambient CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Ambient CO" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoAmbientCOLevel.text = [NSString stringWithFormat:@"Ambient CO %@", testoValue];
    NSLog(@"Ambient CO %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match EFF gross
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+EFF gross" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoEffGrossLevel.text = [NSString stringWithFormat:@"EFF gross %@", testoValue];
    NSLog(@"EFF gross %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Diff. press.
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Diff. press." options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoDiffPressLevel.text = [NSString stringWithFormat:@"Diff. press. %@", testoValue];
    NSLog(@"Diff. press. %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Ambient temp
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Ambient temp" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoAmbientTempLevel.text = [NSString stringWithFormat:@"Ambient temp %@", testoValue];
    NSLog(@"Ambient temp %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
    
    // match Undiluted CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Undiluted CO" options:0 error:NULL];
    str = self.myDataObject.sampleDataDict[@"data"];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.testoUndilutedCOLevel.text = [NSString stringWithFormat:@"Undiluted CO %@", testoValue];
    NSLog(@"Undiluted CO %@.", [str substringWithRange:[match rangeAtIndex:1]]);// gives the first captured group in this example
}

- (DeviceSampleDataObject *)getDataObject
{
    [self.myDataObject setPlaceName:@"Nowhere"];
    
    NSMutableDictionary *dictionary = [@{@"testoCO2Level": self.testoCO2Level.text,
                                         @"testoO2Level": self.testoO2Level.text,
                                         @"testoCOLevel": self.testoCOLevel.text,
                                         @"testoFlueGasTempLevel": self.testoFlueGasTempLevel.text,
                                         @"testoExcessAirLevel": self.testoExcessAirLevel.text,
                                         @"testoDraughtLevel": self.testoDraughtLevel.text,
                                         @"testoEffNetLevel": self.testoEffNetLevel.text,
                                         @"testoAmbientCOLevel": self.testoAmbientCOLevel.text,
                                         @"testoEffGrossLevel": self.testoEffGrossLevel.text,
                                         @"testoDiffPressLevel": self.testoDiffPressLevel.text,
                                         @"testoAmbientTempLevel": self.testoAmbientTempLevel.text,
                                         @"testoUndilutedCOLevel": self.testoUndilutedCOLevel.text,
                                         @"data": self.myDataObject.sampleDataDict[@"data"]
                                         } mutableCopy];
    //    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary: @{@"data": self.myDataObject.sampleDataDict[@"data"]}];
    [self.myDataObject setSampleDataDict:dictionary];
    return self.myDataObject;
}


@end
