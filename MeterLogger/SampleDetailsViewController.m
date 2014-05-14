//
//  SampleDetailsViewController.m
//  SoftModemRemote
//
//  Created by johannes on 5/7/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "SampleDetailsViewController.h"

@interface SampleDetailsViewController ()
@property UIViewController  *currentDetailViewController;

@end

@implementation SampleDetailsViewController
@synthesize myDataObject;

- (id)initWithViewController:(UIViewController*)viewController{
    
    self = [super init];
    
    if(self){
        [self presentDetailController:viewController];
    }
    
    return self;
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
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [activityVC setValue:shareText forKeyPath:@"subject"];
    activityVC.excludedActivityTypes = @[];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
