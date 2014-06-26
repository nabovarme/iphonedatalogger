//
//  Multical.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import "Multical.h"
#import "KeyLabelValueTextfieldCell.h"
#import "IEC62056-21.h"
#import "MulticalRequest.h"

//#define KAMSTRUP_DATA_LENGTH (285.0f)

#define RECEIVE_DATA_TIME (4.0f)
#define RECEIVE_DATA_PROGRESS_TIMER_UPDATE_INTERVAL (0.2f)

@interface Multical ()
@property DeviceSampleDataObject *myDataObject;
@property NSArray *orderedNames;
@property BOOL state;

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@property IEC62056_21 *iec62056_21;
@property MulticalRequest *multicalRequest;

@end


@implementation Multical
@synthesize receiveDataProgressTimer;
@synthesize myDataObject;
@synthesize orderedNames;
@synthesize state;
@synthesize detailsTableView;
@synthesize iec62056_21;
@synthesize multicalRequest;

-(id)init
{
    self = [super init];
    return self;
}
-(void)updateView
{
    NSLog(@"device model wants to update device view");
}

//inits with a dictionary holding a viewcontroller to be set as delegate for sendrequest stuff
-(id)initWithDictionary:(NSDictionary *)dictionary ;//= /* parse the JSON response to a dictionary */;
{
    NSLog(@"sensor init with dictionary");

    // set myDataObject to the one passed in dictionary key dataObject
    [self setMyDataObject:dictionary[@"dataObject"]];
    self.state = NO;

    // set up multicalRequest
    self.multicalRequest = [[MulticalRequest alloc] init];
    [self.multicalRequest setDeviceRequestSendToNewSampleViewControllerDelegate:dictionary[@"delegate"]];
    [self.multicalRequest setDeviceRequestSendToDeviceViewControllerDelegate:self];

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

//new stuff
-(id)respondWithReceiveCharDelegate
{
    return self.multicalRequest;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    if([self.myDataObject.sampleDataDict count] != 0)
    {
        // details view
        NSString *devicePlistString=[NSString stringWithFormat:@"%@PropertyList",myDataObject.deviceName];
        NSString *devicePlist = [[NSBundle mainBundle] pathForResource:devicePlistString ofType:@"plist"];
        NSArray *deviceKeys = [NSArray arrayWithContentsOfFile:devicePlist];
        self.orderedNames=[[NSArray alloc]initWithArray:deviceKeys];
    }
    else
    {
        // new sample view
        // set momentary data object

        // if there is no data saved init sampleDataDict empty
        // load keys from property list

        NSString *devicePlistString=[NSString stringWithFormat:@"%@PropertyList",myDataObject.deviceName];


        NSString *devicePlist = [[NSBundle mainBundle] pathForResource:devicePlistString ofType:@"plist"];
        NSArray *deviceKeys = [NSArray arrayWithContentsOfFile:devicePlist];
 
        NSMutableArray *deviceValues = [[NSMutableArray alloc] init];
        
        for(int i=0; i<[deviceKeys count]; i++){
            
            NSString *newString = @"";
            
            [deviceValues addObject: newString];
        }
               
        self.orderedNames=[[NSArray alloc]initWithArray:deviceKeys];

        NSMutableDictionary *deviceDict = [[NSMutableDictionary alloc] initWithObjects:deviceValues forKeys:deviceKeys];

        self.myDataObject.sampleDataDict = deviceDict;

        NSLog(@"mydataobject is empty");
        // start progress bar
        [self.receiveDataProgressView setHidden:NO];
        [self.receiveDataProgressView setProgress:0.0 animated:YES];
        
        // and start a timer to update it
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:RECEIVE_DATA_PROGRESS_TIMER_UPDATE_INTERVAL
                                                                         target:self
                                                                       selector:@selector(updateProgressBar)
                                                                       userInfo:nil
                                                                        repeats:YES];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];  // dont lock

        [self.multicalRequest sendRequest];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneReceiving:(NSDictionary * )responseDataDict
{
    for (id key in responseDataDict)
    {
            id obj1 = [self.myDataObject.sampleDataDict objectForKey:key];
            id obj2 = [responseDataDict objectForKey:key];
            if ([obj1 isKindOfClass:[NSNull class]] && [obj2 isKindOfClass:[NSNull class]])
            {
                NSLog(@"key problem");
                break;
            }
        self.myDataObject.sampleDataDict[key]=responseDataDict[key];
    }
    
    [self.detailsTableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
    [self.receiveDataProgressTimer invalidate];
    self.receiveDataProgressTimer = nil;
   [self.multicalRequest.sendIEC62056_21RequestOperationQueue cancelAllOperations];
    self.multicalRequest.sendIEC62056_21RequestOperationQueue = nil;
    NSLog(@"viewDidDisappear");
}

- (DeviceSampleDataObject *)getDataObject
{
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0];
    id placeCell=[self.detailsTableView cellForRowAtIndexPath:myIP];
    UITextField *placeTextfield = (UITextField *)[placeCell viewWithTag:100];
    
    myIP = [NSIndexPath indexPathForRow:1 inSection:0];
    id commentCell=[self.detailsTableView cellForRowAtIndexPath:myIP];
    UITextField *commentTextfield = (UITextField *)[commentCell viewWithTag:100];

    self.myDataObject.placeName = placeTextfield.text;
    self.myDataObject.sampleDataDict[@"Comment"] = commentTextfield.text;
    

    return self.myDataObject;
}

//table view stuff
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section==0)
    {
        return @" ";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [self.myDataObject.sampleDataDict count]-2;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KeyLabelValueTextfieldCellIdentifier";
    KeyLabelValueTextfieldCell *cell = (KeyLabelValueTextfieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"KeyLabelValueTextfieldCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (KeyLabelValueTextfieldCell *)currentObject;
                break;
            }
        }
    }
    // Configure the cell.
//    NSArray* keys = [self.myDataObject.sampleDataDict allKeys];

    //NSLog(@"%d, %d",indexPath.row,indexPath.section);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    lol+=10;

    //real keys is from sel.orderednames and value is from dict[self.orderednames[0]]
    NSInteger row=indexPath.row;

    if(indexPath.section == 1)
    {
        row+=2;
    }
    NSString *key = self.orderedNames[row];
    NSString *value = self.myDataObject.sampleDataDict[key];
    
    cell.keyLabel.text = key;//   objectAtIndex:indexPath.section];

    if (indexPath.section==0 && [value length]==0 && [self.myDataObject.placeName length]==0)//place
    {
        cell.valueTextfield.userInteractionEnabled=YES;
    }else{
        if([key isEqualToString:@"Place"])
        {
            value=self.myDataObject.placeName;
        }
        cell.valueTextfield.text = value;
    }
    return cell;
}

// progress bar stuff
- (void)updateProgressBar {
    NSLog(@"updateProgressBar %f", self.receiveDataProgressView.progress);
    [self.receiveDataProgressView setProgress:
        self.receiveDataProgressView.progress + 0.7 / RECEIVE_DATA_TIME * RECEIVE_DATA_PROGRESS_TIMER_UPDATE_INTERVAL animated:YES];
    if (self.receiveDataProgressView.progress >= 0.7) {
        // stop the timer - updating is done in receivedChar from there
        [self.receiveDataProgressTimer invalidate];
        self.receiveDataProgressTimer = nil;
    }
}

#pragma mark - Stupid redundant code

-(NSString *) dataToHexString:(NSData *) theData {
    NSString *result = [[theData description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result substringWithRange:NSMakeRange(1, [result length] - 2)];
    return result;
}


@end
