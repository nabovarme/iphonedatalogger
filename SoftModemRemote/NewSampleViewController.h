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
#import "ProtocolHelper.h"
#import "CharReceiver.h"

@class NewSampleViewController;

@protocol NewSampleViewControllerDelegate <NSObject>
@optional
- (void)NewSampleViewControllerDidCancel:(NewSampleViewController *)controller;
- (void)NewSampleViewControllerDidSave:(NewSampleViewController *)controller;
- (void) receivedChar:(char)input;
@end

@protocol NewSampleViewControllerDelegateForContentView <NSObject>
@optional
- (void) receivedChar:(char)input;
@end


@interface NewSampleViewController : UIViewController <CharReceiver>{
    id<NewSampleViewControllerDelegate> _delegate;
    id<NewSampleViewControllerDelegateForContentView> _contentDelegate;
}
@property (assign, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id contentDelegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, assign) ProtocolHelper* protocolHelper;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;

@end
