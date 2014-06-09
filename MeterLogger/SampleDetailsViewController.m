//
//  SampleDetailsViewController.m
//  SoftModemRemote
//
//  Created by johannes on 5/7/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "SampleDetailsViewController.h"
#import "MeterShareActivity.h"

@interface SampleDetailsViewController ()
@property UIViewController  *currentDetailViewController;
@property UIPopoverController *popoverController;

@end

@implementation SampleDetailsViewController
@synthesize myDataObject;
@synthesize popoverController;

- (id)initWithViewController:(UIViewController*)viewController{
    
    self = [super init];
    
    if(self){
        [self presentDetailController:viewController];
    }
    
    return self;
}

- (IBAction)confirmDelete
{
    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Confirm delete"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:@"Cancel", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"ok");
        [self performSegueWithIdentifier:@"deleteDetailsSegue" sender:self];

    }
    else
    {
        NSLog(@"cancel");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"sample details view load");
    
    NSDictionary *dictionary = @{
                                 @"dataObject":myDataObject
                                 };
    
    [self presentDetailController:(UIViewController*)[[ NSClassFromString(myDataObject.deviceName) alloc] initWithDictionary:dictionary]];
    


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(DeviceSampleDataObject * )getObject
{
    return self.myDataObject;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// sharing
- (IBAction)showActivityView:(id)sender {
    NSString *shareText = [NSString stringWithFormat:@"%@ @ %@", self.myDataObject.deviceName, self.myDataObject.placeName];
    NSMutableArray *itemsToShare = [@[shareText] mutableCopy];
    [itemsToShare addObject:self.myDataObject.sampleDataDict.debugDescription];
    
    MeterShareActivity *ca = [[MeterShareActivity alloc]init];
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:itemsToShare
                                      applicationActivities:[NSArray arrayWithObject:ca]];

    [activityVC setValue:shareText forKeyPath:@"subject"];
    activityVC.excludedActivityTypes = @[];
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        NSLog(@" activityType: %@", activityType);
        NSLog(@" completed: %i", completed);
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        [self.popoverController
         presentPopoverFromRect:rect inView:self.view
         permittedArrowDirections:0
         animated:YES];
    }
    else
    {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    

    //UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //[activityVC setValue:shareText forKeyPath:@"subject"];
    //activityVC.excludedActivityTypes = @[];
    //[self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)deleteSampleRowWithConfirm:(id)sender {
/*
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:@"Delete"
                                              otherButtonTitles:nil];
    [sheet showFromToolbar:sender];
 */
//    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
//    NSArray *fetchedSamplesArray = [APP_DELEGATE getAllSamplesFromDevice:self.title];
//    [context deleteObject:[fetchedSamplesArray objectAtIndex:indexPath.row]];
//    [self updateTableView];
}

@end
