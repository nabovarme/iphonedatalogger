//
//  SampleDetailsViewController.h
//  SoftModemRemote
//
//  Created by johannes on 5/7/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"

@interface SampleDetailsViewController : UIViewController
@property (assign, nonatomic) IBOutlet UIView *contentView;
@property (atomic,retain) SensorSampleDataObject* myDataObject;
-(SensorSampleDataObject *)getObject;
@end
