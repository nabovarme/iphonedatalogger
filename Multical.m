//
//  Multical.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "Multical.h"
#import "KeyLabelValueTextfieldCell.h"
#import "IEC62056-21.h"

//#define KAMSTRUP_DATA_LENGTH (285.0f)

#define RECEIVE_DATA_TIME (3.0f)
#define RECEIVE_DATA_PROGRESS_TIMER_UPDATE_INTERVAL (1.0f) // every second

@interface Multical ()
@property NSOperationQueue *sendIEC62056_21RequestOperationQueue;
@property BOOL readyToSend;
@property unsigned char framesToSend;
@property unsigned char framesReceived;
@property DeviceSampleDataObject *myDataObject;
@property NSArray *orderedNames;
@property NSMutableData *data;
@property BOOL state;

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@property IEC62056_21 *iec62056_21;

@end


@implementation Multical
@synthesize sendRequestDelegate;
@synthesize receiveDataProgressTimer;
@synthesize sendIEC62056_21RequestOperationQueue;
@synthesize readyToSend;
@synthesize framesToSend;
@synthesize framesReceived;
@synthesize myDataObject;
@synthesize orderedNames;
@synthesize data;
@synthesize state;
@synthesize detailsTableView;
@synthesize iec62056_21;

-(id)init
{
    self = [super init];
    return self;
}

//inits with a dictionary holding a viewcontroller to be set as delegate for sendrequest stuff
-(id)initWithDictionary:(NSDictionary *)dictionary ;//= /* parse the JSON response to a dictionary */;
{
    NSLog(@"sensor init with dictionary");
    //make kmp transport init alloc
    //    [kmpTransportInstance setSendRequestDelegate:dictionary[@"delegate"]];

    [self setSendRequestDelegate:dictionary[@"delegate"]];
    
    // set myDataObject to the one passed in dictionary key dataObject
    [self setMyDataObject:dictionary[@"dataObject"]];
    self.state = NO;

    // set up iec62056_21 protocol
    self.iec62056_21 = [[IEC62056_21 alloc] init];
    
    self.framesReceived = 0;
    self.framesToSend = 0;
    self.readyToSend = YES;
    
    self = [super init];
    return self;
}

/*
(id) getDelegate
{
 return kmpTransportInstance.receivedCharDelegate
}
 */

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
        NSString *devicePlistString=[NSString stringWithFormat:@"%@PropertyList",myDataObject.deviceName];
        NSString *devicePlist = [[NSBundle mainBundle] pathForResource:devicePlistString ofType:@"plist"];
        NSArray *deviceKeys = [NSArray arrayWithContentsOfFile:devicePlist];
        self.orderedNames=[[NSArray alloc]initWithArray:deviceKeys];
    }
    else
    {
        // new sample view
        // set momentary data object
        self.data = [[NSMutableData alloc] init];

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

        // start sendMulticalRequest in a operation queue, so it can be canceled
        self.sendIEC62056_21RequestOperationQueue = [[NSOperationQueue alloc] init];

        NSInvocationOperation *operation = [NSInvocationOperation alloc];
        operation = [operation initWithTarget:self
                                     selector:@selector(sendMulticalRequest:)
                                       object:operation];
        
        [self.sendIEC62056_21RequestOperationQueue addOperation:operation];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMulticalRequest:(NSOperation *)theOperation {
    self.readyToSend = NO;
    
    [self.sendRequestDelegate sendRequest:PROTO_MULTICAL];
    [NSThread sleepForTimeInterval:0.04];
    [self.sendRequestDelegate sendRequest:@"2f3f210d0a"];     // /?!\n\r          EN61107
    self.framesToSend++;
    while(!self.readyToSend ){
        if ([theOperation isCancelled]) {
            return;
        }
        [NSThread sleepForTimeInterval:0.01];
    }
    [NSThread sleepForTimeInterval:0.1];

    [self.sendRequestDelegate sendRequest:PROTO_MULTICAL];
    [NSThread sleepForTimeInterval:0.04];
    [self.sendRequestDelegate sendRequest:@"063030300d0a"];   // [ACK]000\n\r
    self.framesToSend++;
    while(!self.readyToSend ){
        if ([theOperation isCancelled]) {
            return;
        }
        [NSThread sleepForTimeInterval:0.01];
    }    
}

- (void)receivedChar:(unsigned char)input;
{
    //NSLog(@"Multical received %c (%d)", input, input);
    // save incoming data do our sampleDataDict
    NSData *inputData = [NSData dataWithBytes:(unsigned char[]){input} length:1];
    [self.data appendData:inputData];
    
    [self.receiveDataProgressView setProgress:(self.receiveDataProgressView.progress + 0.0075) animated:YES];

    if (self.receiveDataProgressTimer) {
        // stop it
        [self.receiveDataProgressTimer invalidate];
        self.receiveDataProgressTimer = nil;        // let it be deallocated
        // and start a new timer
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doneReceiving) userInfo:nil repeats:NO];
    }
    else {
        // if its not running start a new one
        self.receiveDataProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doneReceiving) userInfo:nil repeats:NO];
    }
}

- (void)doneReceiving {
    NSLog(@"Done receiving %@", self.data);
    NSLog(@"Done receiving ascii \"%@\"", [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding]);
    self.framesReceived++;
    // decode
    [self.iec62056_21 decodeFrame:self.data];
    if (self.iec62056_21.frameReceived) {
        for (NSNumber *rid in self.iec62056_21.registerIDTable) {
            if (self.iec62056_21.responseData[rid] && self.myDataObject.sampleDataDict[self.iec62056_21.registerIDTable[rid]]) {
                //NSLog(@"doneReceiving: updating %@", self.kmp.registerIDTable[rid]);
                self.myDataObject.sampleDataDict[self.iec62056_21.registerIDTable[rid]] = self.iec62056_21.responseData[rid][@"value"];
            }
        }
        
        if ((self.framesReceived == 1) && (self.framesToSend == 1)) {
            if ([iec62056_21.responseData[@"ident"] isEqualToString:@"KAM MC"]) {  // Kamstrup Multical, 2001
                // sends data after ack in same frame, so cancel second frame
                [self.sendIEC62056_21RequestOperationQueue cancelAllOperations];
                [self.receiveDataProgressView setHidden:YES];
                [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
                
                //update table view
                self.state = YES;
                [self.detailsTableView reloadData];
            }
        }
        if ((self.framesReceived == 2) && (self.framesToSend == 2)) {
            // last frame received
            [self.receiveDataProgressView setHidden:YES];
            [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
            
            //update table view
            self.state = YES;
            [self.detailsTableView reloadData];
        }
        
        self.data = [[NSMutableData alloc] init];       // clear data after use
        self.iec62056_21.responseData = [[NSMutableDictionary alloc] init];
        
        self.readyToSend = YES;
    }
    
    if (self.iec62056_21.errorReceiving) {
        NSLog(@"Retransmit");
        self.framesToSend = 0;
        self.framesReceived = 0;
        self.data = [[NSMutableData alloc] init];       // clear data after use
        self.iec62056_21.responseData = [[NSMutableDictionary alloc] init];
        // stop all already running sendIEC62056_21Requests
        [self.sendIEC62056_21RequestOperationQueue cancelAllOperations];
        
        // restart progress bar
        [self.receiveDataProgressView setProgress:0.0];
        
        // and start a new one
        NSInvocationOperation *operation = [NSInvocationOperation alloc];
        operation = [operation initWithTarget:self
                                     selector:@selector(sendMulticalRequest:)
                                       object:operation];
        
        [self.sendIEC62056_21RequestOperationQueue addOperation:operation];
    }
        
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];  // allow lock again
    [self.receiveDataProgressTimer invalidate];
    self.receiveDataProgressTimer = nil;
    [self.sendIEC62056_21RequestOperationQueue cancelAllOperations];
    self.sendIEC62056_21RequestOperationQueue = nil;
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
        self.receiveDataProgressView.progress + 0.5 / RECEIVE_DATA_TIME * RECEIVE_DATA_PROGRESS_TIMER_UPDATE_INTERVAL animated:YES];
    if (self.receiveDataProgressView.progress >= 0.5) {
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
