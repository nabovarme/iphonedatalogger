//
//  SampleDetailsViewController.h
//  SoftModemRemote
//
//  Created by johannes on 5/7/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
@interface SampleDetailsViewController : UIViewController 
@property (nonatomic, assign) id <SampleDetailsViewControllerBack> backDelegate;
- (IBAction)back:(UIBarButtonItem *)sender;

@end
