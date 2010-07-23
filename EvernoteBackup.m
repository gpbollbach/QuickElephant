#import "EvernoteBackup.h"

#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "UserStore.h"
#import "NoteStore.h"
#import "TTransportException.h"
#import "Errors.h"

@implementation EvernoteBackup
@synthesize guid,authResult,noteStore, notebooks, notebookUsed, loggedIn;

- (BOOL) addEverNote:(NSString *) noteContent at:(NSDate*) noteDate
{
	BOOL noteCreatedVal = NO;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	@try {
		
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	NSString *username = [userDefaults valueForKey:@"uname"];
	NSString *password = [userDefaults valueForKey:@"pword"];
		NSLog(@"loggin in with");
		NSLog(username);
		
	// Keep this key private
	NSString *consumerKey = [[[NSString alloc]
							  initWithString: @"philbolli" ] autorelease];
	NSString *consumerSecret = [[[NSString alloc]
								 initWithString: @"bc99022d994c19b9"] autorelease];
	// For testing we use the sandbox server.
	NSURL *userStoreUri = [[[NSURL alloc]
							initWithString: @"https://www.evernote.com/edam/user"] autorelease];
	NSString *noteStoreUriBase = [[[NSString alloc]
								   initWithString: @"http://www.evernote.com/edam/note/"] autorelease];
	// These are for test purposes. At some point the user will provide his/her own.
/*	NSString *username = [[[NSString alloc]
						   initWithString: @"philbollisandbox"] autorelease];
	NSString *password = [[[NSString alloc]
						   initWithString: @"sandboxTest"] autorelease];
*/	
	THTTPClient *userStoreHttpClient = [[[THTTPClient alloc]
										 initWithURL:userStoreUri] autorelease];
	TBinaryProtocol *userStoreProtocol = [[[TBinaryProtocol alloc]
										   initWithTransport:userStoreHttpClient] autorelease];
	EDAMUserStoreClient *userStore = [[[EDAMUserStoreClient alloc]
									   initWithProtocol:userStoreProtocol] autorelease];
	EDAMNotebook* defaultNotebook = NULL;
	
	BOOL versionOk = [userStore checkVersion:@"Cocoa EDAMTest" :
					  [EDAMUserStoreConstants EDAM_VERSION_MAJOR] :
					  [EDAMUserStoreConstants EDAM_VERSION_MINOR]];
	
	if (versionOk == YES)
	{
		EDAMAuthenticationResult* authResult =
		[userStore authenticate:username :password
							   :consumerKey :consumerSecret];
		EDAMUser *user = [authResult user];
		NSString *authToken = [authResult authenticationToken];
		NSLog(@"Authentication was successful for: %@", [user username]);
		NSLog(@"Authentication token: %@", authToken);
		
		NSURL *noteStoreUri =  [[[NSURL alloc]
								 initWithString:[NSString stringWithFormat:@"%@%@",
												 noteStoreUriBase, [user shardId]] ]autorelease];
		THTTPClient *noteStoreHttpClient = [[[THTTPClient alloc]
											 initWithURL:noteStoreUri] autorelease];
		TBinaryProtocol *noteStoreProtocol = [[[TBinaryProtocol alloc]
											   initWithTransport:noteStoreHttpClient] autorelease];
		EDAMNoteStoreClient *noteStore = [[[EDAMNoteStoreClient alloc]
										   initWithProtocol:noteStoreProtocol] autorelease];
		
		
		NSArray *notebooks = [noteStore listNotebooks:authToken] ;
		NSLog(@"Found %d notebooks", [notebooks count]);
		for (int i = 0; i < [notebooks count]; i++)
		{
			EDAMNotebook* notebook = (EDAMNotebook*)[notebooks objectAtIndex:i];
			if ([notebook defaultNotebook] == YES)
			{
				defaultNotebook = notebook;
			}
			NSLog(@" * %@", [notebook name]);
		}
		
		NSLog(@"Creating a new note in default notebook: %@", [defaultNotebook name]);
		
		// Skipping the image resource section...
		
		EDAMNote *note = [[[EDAMNote alloc] init] autorelease];
		[note setNotebookGuid:[defaultNotebook guid]];
		[note setTitle:@"untitled"];//[NSString stringWithFormat:@"Test note from Quickphant (%@).",[noteDate description]]]; //date
		NSMutableString* contentString = [[[NSMutableString alloc] init] autorelease];
		[contentString setString:	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
		[contentString appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
		[contentString appendString:[NSString stringWithFormat:@"<en-note>%@<br/>",noteContent]];
		[contentString appendString:@"			</en-note>"];
		[note setContent:contentString];
		[note setCreated:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
		EDAMNote *createdNote = [noteStore createNote:authToken :note];
		if (createdNote != NULL)
		{
			DebugLog(@"Created note: %@", [createdNote title]);
			noteCreatedVal = YES;
		}
	}
	
	}@catch (TTransportException *transpEx) {
		NSLog(@"TTransportException: %@", [transpEx name]); 
		NSLog(@"TTransportException: %@", [transpEx reason]);

	}
	@catch (EDAMUserException *userEx) {
		NSLog(@"EDAMUserException: %@", [userEx name]); 
		NSLog(@"EDAMUserException: %@", [userEx reason]);
	}
	@catch(NSException *e) {
		NSLog(@"NSException: %@", [e name]); //TODO: abfangen "TTransportException" bei fehlender Connectivity
		NSLog(@"NSException: %@", [e reason]);//EDAMUserException bei fehlgeschlagener Auth
	}
	@finally {
		[pool drain];
	}	
	return noteCreatedVal;

}
- (BOOL) addNote:(NoteEntry *)noteEntry{
	BOOL noteCreatedVal = NO;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	@try {
		EDAMNote *note = [[[EDAMNote alloc] init] autorelease];
		[note setNotebookGuid:self.guid];
		//[note setTitle:[NSString stringWithFormat:@"FastPhant:%@...",[noteEntry.textContent substringToIndex:4]]];//[NSString stringWithFormat:@"Test note from Quickphant (%@).",[noteDate description]]]; //date
		[note setTitle:@"Untitled Note"];
		NSMutableString* contentString = [[[NSMutableString alloc] init] autorelease];
		[contentString setString:	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
		[contentString appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
		[contentString appendString:[NSString stringWithFormat:@"<en-note>%@<br/>",noteEntry.textContent]];
		[contentString appendString:@"			</en-note>"];
		[note setContent:contentString];
		[note setCreated:(long long)[noteEntry.timeStamp timeIntervalSince1970] * 1000];
		EDAMNote *createdNote = [noteStore createNote:[self.authResult authenticationToken] :note];
		if (createdNote != NULL)
		{
			NSLog(@"Created note: %@", [createdNote title]);
			noteCreatedVal = YES;
		}
	}@catch (TTransportException *transpEx) {
		DebugLog(@"TTransportException: %@", [transpEx name]); 
		DebugLog(@"TTransportException: %@", [transpEx reason]);
		
	}
	@catch (EDAMUserException *userEx) {
		DebugLog(@"EDAMUserException: %@", [userEx name]); 
		DebugLog(@"EDAMUserException: %@", [userEx reason]);
	}
	@catch(NSException *e) {
		DebugLog(@"NSException: %@", [e name]); //TODO: abfangen "TTransportException" bei fehlender Connectivity
		DebugLog(@"NSException: %@", [e reason]);//EDAMUserException bei fehlgeschlagener Auth
	}
	@finally {
		[pool drain];
	}	
	return noteCreatedVal;
}

- (BOOL) login {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	NSString *username = [userDefaults valueForKey:@"uname"];
	NSString *password = [userDefaults valueForKey:@"pword"];
	DebugLog(@"loggin in with");
	//DebugLog(username);

	return [self login:username with:password];
}

- (BOOL) login:(NSString*)username with:(NSString*)password
{
	self.loggedIn = NO;
	if (username == nil || password == nil){
		return self.loggedIn;
	}
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		// Keep this key private
		NSString *consumerKey = [[[NSString alloc]
								  initWithString: @"philbolli" ] autorelease];
		NSString *consumerSecret = [[[NSString alloc]
									 initWithString: @"bc99022d994c19b9"] autorelease];
		// For testing we use the sandbox server.
		NSURL *userStoreUri = [[[NSURL alloc]
								initWithString: @"https://www.evernote.com/edam/user"] autorelease];
	
		// These are for test purposes. At some point the user will provide his/her own.
		/*
		NSString *username = [[[NSString alloc]
							   initWithString: @"philbollisandbox"] autorelease];
		NSString *password = [[[NSString alloc]
							   initWithString: @"sandboxTest"] autorelease];
		*/
		
		THTTPClient *userStoreHttpClient = [[[THTTPClient alloc]
											 initWithURL:userStoreUri] autorelease];
		TBinaryProtocol *userStoreProtocol = [[[TBinaryProtocol alloc]
											   initWithTransport:userStoreHttpClient] autorelease];
		EDAMUserStoreClient *userStore = [[[EDAMUserStoreClient alloc]
										   initWithProtocol:userStoreProtocol] autorelease];		
		BOOL versionOk = [userStore checkVersion:@"Cocoa EDAMTest" :
						  [EDAMUserStoreConstants EDAM_VERSION_MAJOR] :
						  [EDAMUserStoreConstants EDAM_VERSION_MINOR]];
		
		if (versionOk == YES)
		{
			self.authResult =
			[userStore authenticate:username :password
								   :consumerKey :consumerSecret];
			EDAMUser *user = [authResult user];
			NSString *authToken = [authResult authenticationToken];
			DebugLog(@"Authentication was successful for: %@", [user username]);
			DebugLog(@"Authentication token: %@", authToken);
			self.loggedIn = YES;
		}
		
		[pool drain];
		
	}@catch(NSException *e) {
		DebugLog(@"name: %@", [e name]);
		DebugLog(@"name: %@", [e reason]);
	}
	return loggedIn;
	
}

-(void)initNotebook {
	EDAMUser *user = [self.authResult user];
	NSString *authToken = [self.authResult authenticationToken];
	
	NSString *noteStoreUriBase = [[[NSString alloc]
								   initWithString: @"http://www.evernote.com/edam/note/"] autorelease];
	
	NSURL *noteStoreUri =  [[[NSURL alloc]
							 initWithString:[NSString stringWithFormat:@"%@%@",
											 noteStoreUriBase, [user shardId]] ]autorelease];
	THTTPClient *noteStoreHttpClient = [[[THTTPClient alloc]
										 initWithURL:noteStoreUri] autorelease];
	TBinaryProtocol *noteStoreProtocol = [[[TBinaryProtocol alloc]
										   initWithTransport:noteStoreHttpClient] autorelease];
	noteStore = [[[EDAMNoteStoreClient alloc]
									   initWithProtocol:noteStoreProtocol] autorelease];
	
	
	notebooks = [noteStore listNotebooks:authToken] ;
	DebugLog(@"Found %d notebooks", [notebooks count]);
	for (int i = 0; i < [notebooks count]; i++)
	{
		EDAMNotebook* notebook = (EDAMNotebook*)[notebooks objectAtIndex:i];
		if ([notebook defaultNotebook] == YES)
		{
			self.guid = [notebook guid];
			self.notebookUsed = notebook;
		}
		DebugLog(@" * %@", [notebook name]);
	}
}


- (void)dealloc {
	guid = nil;
	authResult = nil;
	notebooks = nil;
	notebookUsed = nil;
    [super dealloc];
}

@end