//
//  SampleDetailsViewController.h
//  SoftModemRemote
//
//  Created by johannes on 5/7/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"

@interface SampleDetailsViewController : UIViewController <UIAlertViewDelegate>
@property (assign, nonatomic) IBOutlet UIView *contentView;
@property (atomic,retain) DeviceSampleDataObject* myDataObject;
- (IBAction)showActivityView:(id)sender;
-(DeviceSampleDataObject *)getObject;
@end
