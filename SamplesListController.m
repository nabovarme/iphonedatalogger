//
//  SamplesListController.m
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//  bruger http://www.codigator.com/tutorials/ios-core-data-tutorial-with-example/
//

#import "SamplesListController.h"
#import "SamplesEntity.h"
#import "NLAppDelegate.h"


@interface SamplesListController ()
@property (nonatomic,strong)NSArray* fetchedSamplesArray;
@property (nonatomic,strong)NSDateFormatter* dateFormatter;


@end


@implementation SamplesListController
@synthesize dateFormatter;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"masterviewloaded");
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self updateTableView];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedSamplesArray count];

    //return 0;
}

- (void)updateTableView
{
    self.fetchedSamplesArray = [APP_DELEGATE getAllSamplesFromDevice:self.title];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *CellIdentifier = @"SampleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    SamplesEntity * sample = [self.fetchedSamplesArray objectAtIndex:indexPath.row];
    NSString *dateString=[dateFormatter stringFromDate:sample.date];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dateString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",sample.placeName];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    SamplesEntity * entity = [self.fetchedSamplesArray objectAtIndex:indexPath.row];
    [APP_DELEGATE deleteEntityWithDeviceName:entity.deviceName andDate:entity.date];
    [self updateTableView];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)newSampleButtonPressed:(UIBarButtonItem *)sender {
    NSLog(@"new sample button pressed");
#ifndef __i386__
    AVAudioSession *session = [AVAudioSession sharedInstance];
#endif
    
    // check if headphone jack in plugged in
    // should go to NewSampleViewController with popup
    BOOL headPhonesConnected = NO;
#ifdef __i386__
    NSLog(@"Running in the simulator");
    headPhonesConnected = YES;
#else
    NSLog(@"Running on a device");
    NSArray *availableOutputs = [session currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        NSLog(@"%@", portDescription.portType);
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            headPhonesConnected = YES;
        }
    }
#endif
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL debugUI = [defaults boolForKey:@"debugUI"];
    
    NSLog(@"headPhonesConnected: %@", headPhonesConnected ? @"YES" : @"NO");
    NSLog(@"debugUI: %@", debugUI ? @"YES" : @"NO");
    if (!(headPhonesConnected || debugUI))
    {
        NSLog(@"headphones not connected");
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Insert MeterLogger Device"
                                                         message:@"Insert Device in headphone plug"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        [self performSegueWithIdentifier:@"NewSample" sender:self];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    NSLog(@"cancel: someone unwinded to samples list!!");
    // do any clean up you want
    NewSampleViewController * controller = (NewSampleViewController*)segue.sourceViewController ;

    [controller terminate];

}

- (IBAction)save:(UIStoryboardSegue *)segue
{
    NSLog(@"save: someone unwinded to samples list!!");
    // do any clean up you want
    NewSampleViewController * controller = (NewSampleViewController*)segue.sourceViewController ;
     [self addSampleEntry:controller.getDataObject];
    [controller terminate];
     [self updateTableView];
}


- (IBAction)delete:(UIStoryboardSegue *)segue
{
    NSLog(@"save: someone unwinded to samples list!!");
    // do any clean up you want
    SampleDetailsViewController *controller = (SampleDetailsViewController*)segue.sourceViewController ;
    //(SampleDetailsViewController*)segue.sourceViewController
    
    DeviceSampleDataObject * object=[controller getObject];
    [APP_DELEGATE deleteEntityWithDeviceName:object.deviceName andDate:object.date];
    [self updateTableView];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewSample"]) {
        NSLog(@"NewSample Segue");
        //[(NewSampleViewController*) segue.destinationViewController setCancelSaveDelegate:self];
        [(NewSampleViewController*) segue.destinationViewController setDeviceName:self.title];
    }
        else if([segue.identifier isEqualToString:@"SampleDetails"]) {
            NSLog(@"sample details Segue");

            //NewSampleViewController *newSampleViewController = segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell*)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            SamplesEntity * sampleObject = [self.fetchedSamplesArray objectAtIndex:indexPath.row];
          
            DeviceSampleDataObject *tmp = [[DeviceSampleDataObject alloc]init];
            
            tmp.deviceName=sampleObject.deviceName;
            tmp.placeName=sampleObject.placeName;
            tmp.date=sampleObject.date;
            tmp.sampleDataDict=sampleObject.sampleDataDict;
            
            [(SampleDetailsViewController *)  segue.destinationViewController setMyDataObject:tmp];
            

            NSLog(@"%@",[tmp description]);

        }
}


- (IBAction)addSampleEntry:(DeviceSampleDataObject *)myDataObject
{
    NSLog(@"inside addsample");
    //  1
    SamplesEntity *newSample=[NSEntityDescription insertNewObjectForEntityForName:@"SamplesEntity"
                                                          inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    //  2


    //newSample.date=[NSDate date];
    //newSample.deviceName=self.title;
    //newSample.placeName=@"loppen";
    //newSample.sampleDataDict=controller;
    
    newSample.deviceName=myDataObject.deviceName;
    newSample.placeName=myDataObject.placeName;
    newSample.date=myDataObject.date;

    newSample.sampleDataDict=myDataObject.sampleDataDict;
   // NSLog(@"%@",myDataObject.deviceName);
    //  3
    NSError *error;
    if (![APP_DELEGATE.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    //  5
//    [self.view endEditing:YES];
}


@end
