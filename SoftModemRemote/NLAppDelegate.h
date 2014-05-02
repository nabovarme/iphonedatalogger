//
//  NLAppDelegate.h
//  IRRemote
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2012 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_DELEGATE ((NLAppDelegate*)[[UIApplication sharedApplication] delegate])

@interface NLAppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (strong, nonatomic) UIWindow *window;


//core data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;
//end

//@property (strong, nonatomic) NLMainViewController *viewController;
-(NSArray*)getAllSamplesFromDevice:(NSString*)deviceName;

@end
