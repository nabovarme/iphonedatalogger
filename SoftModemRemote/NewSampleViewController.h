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
    //id<NewSampleViewControllerDelegate> delegate;

}
@property (nonatomic, assign) id <NewSampleViewControllerDelegate> delegate;
@property (nonatomic,assign) NSInteger * counter;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)done:(UIBarButtonItem *)sender;

@end
