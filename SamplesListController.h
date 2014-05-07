//
//  SamplesListController.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewSampleViewController.h"
#import "SampleDetailsViewController.h"
#import "Protocols.h"


//@interface SamplesListController : UITableViewController <NewSampleViewControllerDelegate>{
    @interface SamplesListController : UITableViewController <NewSampleViewControllerCancelSave,SampleDetailsViewControllerBack>{
    
}


@end
