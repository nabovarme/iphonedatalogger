//
//  NLAppDelegate.h
//  MeterLogger
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioSession.h>
#import "CharReceiver.h"

//all devices here
#import "Protocols.h"

#import "Testo.h"

#import "DeviceSampleDataObject.h"
#import "SamplesEntity.h"

//end

#define APP_DELEGATE ((NLAppDelegate*)[[UIApplication sharedApplication] delegate])

@class FSKSerialGenerator;//,CharReceiverDelegate;
@class AudioSignalAnalyzer, FSKSerialGenerator, FSKRecognizer;

@interface NLAppDelegate : UIResponder <UIApplicationDelegate, AVAudioSessionDelegate> {
    AudioSignalAnalyzer* _analyzer;
	FSKRecognizer* _recognizer;
    FSKSerialGenerator* _generator;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) AudioSignalAnalyzer* analyzer;
@property (nonatomic, retain) FSKRecognizer* recognizer;

@property (nonatomic, retain) FSKSerialGenerator* generator;

//core data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;
//end

//@property (strong, nonatomic) NLMainViewController *viewController;
//@property (strong, nonatomic) CharReceiverDelegate * receiveDelegate;
//+ (NLAppDelegate*) getInstance;
-(NSArray*)getAllSamplesFromDevice:(NSString*)deviceName;
-(void)deleteEntityWithDeviceName:(NSString*)deviceName andDate:(NSDate *)date;

- (void) myStop;
- (void) myPlay;
@end
