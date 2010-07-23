//
//  EvernoteBackup.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 06.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteStore.h"
#import "NoteEntry.h"

@interface EvernoteBackup : NSObject {
	NSString *guid;
	EDAMAuthenticationResult* authResult;
	EDAMNoteStoreClient *noteStore;
	NSArray *notebooks;
	EDAMNotebook* notebookUsed;
	BOOL loggedIn;
}
@property(nonatomic, retain) 	NSString *guid;
@property(nonatomic, retain)	EDAMAuthenticationResult* authResult;
@property(nonatomic, retain)	EDAMNoteStoreClient *noteStore;
@property(nonatomic, retain)	NSArray *notebooks;
@property(nonatomic, retain)	EDAMNotebook* notebookUsed;
@property(nonatomic)	BOOL loggedIn;

- (BOOL) addEverNote:(NSString *) noteContent at:(NSDate*) noteDate;
- (BOOL) addNote:(NoteEntry *) noteEntry;
- (BOOL) login;
- (BOOL) initNotebook;
- (BOOL) login:(NSString*)username with:(NSString*)password;

@end
