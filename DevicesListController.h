//
//  DevicesListController.h
//  SoftModemRemote
//
//  Created by johannes on 5/7/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"
#import "SamplesListController.h"

@interface DevicesListController : UITableViewController 
@property (strong, nonatomic) NSArray *devicesArray;

@end
