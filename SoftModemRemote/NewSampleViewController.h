//
//  NewSampleViewController.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"

#import "CharReceiverDelegate.h"

@class NewSampleViewController;

@protocol NewSampleViewControllerDelegate <NSObject>
@required
- (void)NewSampleViewControllerDidCancel:(NewSampleViewController *)controller;
- (void)NewSampleViewControllerDidSave:(NewSampleViewController *)controller;
@end


@interface NewSampleViewController : UIViewController <CharReceiverProtocol>{
    id<NewSampleViewControllerDelegate> _delegate;
}
@property (nonatomic, assign) id delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;

@end
