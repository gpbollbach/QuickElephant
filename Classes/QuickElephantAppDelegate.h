//
//  QuickElephantAppDelegate.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//
#import "RootViewController.h"
#import "NoteEntry.h"
@class EvernoteBackup;

@interface QuickElephantAppDelegate : NSObject <UIApplicationDelegate,UINavigationControllerDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UIWindow *window;
    UINavigationController *navigationController;
	BOOL returnFromCache;
	NSOperationQueue* aQueue;
	CGPoint scrollPosition;
	EvernoteBackup *en;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic) BOOL returnFromCache;
@property (nonatomic, retain) NSOperationQueue* aQueue;
@property (nonatomic) CGPoint scrollPosition;

- (NSString *)applicationDocumentsDirectory;
- (void) pushNewNoteEntryController:(RootViewController *) rootViewController;
- (void) pushNewNoteEntryController:(RootViewController *) rootViewController with:(NoteEntry *) noteEntry uploaded:(BOOL)uploaded;
- (EvernoteBackup*) getEvernoteBackup;

@end

