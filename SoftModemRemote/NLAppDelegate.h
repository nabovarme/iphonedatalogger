//
//  NLAppDelegate.h
//  IRRemote
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2012 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioSession.h>
#import "CharReceiver.h"

//all devices here
#import "Testo.h"
#import "EchoTest.h"
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
- (void) myStop;
- (void) myPlay;
@end
