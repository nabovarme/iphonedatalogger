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
@property NSMutableString *data;
@property BOOL *state;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TestoDemo
@synthesize sendRequestDelegate;
@synthesize receiveTimer;
@synthesize myDataObject;
@synthesize tableView;
@synthesize state;

@synthesize data;

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
    self.state = NO;
    
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
    if([self.myDataObject.sampleDataDict count] != 0)
    {
        // details view
    }
    else
    {
        //set momentary data object
        self.data =[@"" mutableCopy];

        // if there is no data saved init sampleDataDict empty
        // load keys from property list

        NSString *devicePlistString=[NSString stringWithFormat:@"%@PropertyList",myDataObject.deviceName];
        NSString *devicePlist = [[NSBundle mainBundle] pathForResource:devicePlistString ofType:@"plist"];
        NSArray *deviceKeys = [NSArray arrayWithContentsOfFile:devicePlist];

        NSMutableDictionary *deviceDict = [[NSMutableDictionary alloc] initWithObjects:deviceKeys forKeys:deviceKeys];
        //[[[NSMutableDictionary alloc] initWithContentsOfFile:devicePlist] mutableCopy];
        self.myDataObject.sampleDataDict = deviceDict;
        //self.myDataObject.sampleDataDict[@"data"]=[@" " mutableCopy];
        // self.myDataObject.sampleDataDict = [@{@"data": [@"" mutableCopy]} mutableCopy];

        //self.myDataObject.sampleDataDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"data": [[NSMutableString alloc] initWithString:@""]}];

        // new sample view
        NSLog(@"mydataobject is empty");
        [self.receiveDataProgressView setHidden:NO];
        [self.receiveDataProgressView setProgress:0.0 animated:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];  // dont lock

        [self.sendRequestDelegate sendRequest:@"ff"];
        
        [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
        
        // 285 characters
        [self.sendRequestDelegate sendRequest:@"302e30303334202020202020526174696f0d0a352e38322520202020202020434f320d0a31352e3125202020202020204f320d0a31393870706d202020202020434f0d0a36312e38b043202020202020466c75656761732074656d700d0a3235352e3925202020202020457863657373206169720d0a2d2d2e2d6d6d48324f202020447261756768740d0a39332e362520202020202020454646206e65740d0a2d2d2e2d70706d2020202020416d6269656e7420434f0d0a38362e3025202020202020204546462067726f73730d0a2d2d2e2d6d6d48324f202020446966662e2070726573732e0d0a31382e36b043202020202020416d6269656e742074656d700d0a37303670706d202020202020556e64696c7574656420434f0d0a"];
        
        [self.receiveDataProgressView setProgress:0.5 animated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedChar:(char)input;
{
    // save incoming data do our sampleDataDict
    [self.data appendFormat:@"%c", input];
    
    NSLog(@"TestoDemo received %c", input);
    [self.receiveDataProgressView setProgress:(0.5 + [self.data length]/285.0/2) animated:YES];

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
    NSLog(@"Done receiving %@", self.data);
    
    [self.receiveDataProgressView setHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
    
    NSRegularExpression *regex;
    NSString *str;
    NSTextCheckingResult *match;
    NSString *testoValue;
    
    //datastring is set
    str = self.data;

    // match CO2
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+CO2\\s" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"CO2"] = testoValue;

    // match O2
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+O2" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"O2"] = testoValue;

    // match CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+CO\\s" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"CO"] = testoValue;

    // match Fluegas temp
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Fluegas temp" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"FlueGasTemp"] = testoValue;

    // match Excess air
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Excess air" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"ExcessAir"] = testoValue;

    // match Draught
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Draught" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"Draught"] = testoValue;

    // match EFF net
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+EFF net" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"EffNet"] = testoValue;

    // match Ambient CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Ambient CO" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"AmbientCO"] = testoValue;

    // match EFF gross
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+EFF gross" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"EffGross"] = testoValue;

    // match Diff. press.
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Diff. press." options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"DiffPress"] = testoValue;

    // match Ambient temp
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Ambient temp" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"AmbientTemp"] = testoValue;

    // match Undiluted CO
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+(.*?)\\s+Undiluted CO" options:0 error:NULL];
    match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    testoValue = [str substringWithRange:[match rangeAtIndex:1]];
    self.myDataObject.sampleDataDict[@"UndilutedCO"] = testoValue;

    //update table view
    self.state = YES;
    [self.tableView reloadData];
}

- (DeviceSampleDataObject *)getDataObject
{
    return self.myDataObject;
}

//table view stuff
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section==1)
    {
        return @" ";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return [self.myDataObject.sampleDataDict count]-2;
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray* keys = [self.myDataObject.sampleDataDict allKeys];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }

    if (indexPath.section==0)//place
    {
        cell.textLabel.text = @"Place";//   objectAtIndex:indexPath.section];
        if([self.myDataObject.sampleDataDict[@"Place"] isEqualToString:@"Place"]){
            
            if(self.state)
            {
                [cell.textLabel setEnabled:YES];
                UITextField *inputText = [[UITextField alloc]initWithFrame:CGRectMake(22,0,280,22)];
                inputText.textAlignment = UITextAlignmentRight;
                inputText.backgroundColor = [UIColor clearColor];
                inputText.placeholder = @"place name";
                // inputText.text=[self.myDataObject.sampleDataDict objectForKey:@"Place"];
                
                [inputText setDelegate:self];
                [cell.contentView addSubview:inputText];
            } else {
                [cell.textLabel setEnabled:NO];
            }
        } else
        {
            cell.detailTextLabel.text = self.myDataObject.placeName;
        }
    }
    else if (indexPath.section==1)//effect
    {
        cell.textLabel.text = @"Effect";//   objectAtIndex:indexPath.section];
        if([self.myDataObject.sampleDataDict[@"Effect"] isEqualToString:@"Effect"]){
            if(self.state)
            {
                [cell.textLabel setEnabled:YES];
                
                UITextField *inputText = [[UITextField alloc]initWithFrame:CGRectMake(22,0,280,22)];
                inputText.textAlignment = UITextAlignmentRight;
                inputText.backgroundColor = [UIColor clearColor];
                inputText.placeholder = @"effect";
                
                //            inputText.text=[self.myDataObject.sampleDataDict objectForKey:@"Effect"];

                [inputText setDelegate:self];
                [cell.contentView addSubview:inputText];
            } else {
                [cell.textLabel setEnabled:NO];
            }
        } else
        {
            cell.detailTextLabel.text = [self.myDataObject.sampleDataDict objectForKey:@"Effect"];
        }
        
    }
    else//the rest
    {
        cell.textLabel.text = [keys objectAtIndex:indexPath.row];//   objectAtIndex:indexPath.section];
        cell.detailTextLabel.text = [self.myDataObject.sampleDataDict objectForKey:[keys objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.placeholder isEqualToString:@"effect"])
    {
        self.myDataObject.sampleDataDict[@"Effect"]=textField.text;
    }
    if([textField.placeholder isEqualToString:@"place name"])
    {
        [self.myDataObject setPlaceName:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
