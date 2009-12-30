//
//  EchowavesController.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

/*
 *
 * http://www.sonsothunder.com/devres/revolution/tutorials/StatusMenu.html
 * http://www.musicalgeometry.com/archives/571
 *
 */

#import "EchowavesController.h"
#import "JSON.h"
#import "Echowaves.h"
#import "UpdatedConvo.h"
#import "ApiKeyController.h"
#import "GrowlNotifier.h"

@implementation EchowavesController

@synthesize updateTimer;

- (id)init {
	if (self = [super init]) {
		echowaves = [[Echowaves alloc] init];
		[self startTimer];
	}
	return self;
}

- (void)startTimer {
	updateTimer = [NSTimer timerWithTimeInterval:_updateInterval target:self selector:@selector(getUpdates) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];
}

- (void)awakeFromNib {	
	[statusMenu setAutoenablesItems:NO];

	// Create the NSStatusBar and set its length
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
	
	// Used to detect where our files are
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Allocates and loads th eimages into the app to use with NSStatusItem
	ewImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ewBW" ofType:@"png"]];
	ewHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ewHL" ofType:@"png"]];
	
	// Sets the images in our NSStatusItem
	[statusItem setImage:ewImage];
	[statusItem setAlternateImage:ewHighlightImage];
	
	[ewImage release];
	[ewHighlightImage release];
	
	// Tells the NSStatusItem what menu to load
	[statusItem setMenu:statusMenu];
	// Sets the tooltip for our item
	[statusItem setToolTip:@"Echowaves Notifier"];
	// Enables highlighting
	[statusItem setHighlightMode:YES];
	
	// Set up growl notifier
	growl = [[[GrowlNotifier alloc] init] retain];
	
	// setup ApiKey window stuff
	apiWindow = [[ApiKeyController alloc] init];
	//[apiWindow window];
	
	if ( _userApiKey ) {
		NSLog(@"_userApiKey found: %@", _userApiKey);
		[echowaves setEchowavesURI:_userApiKey];
		[self getUpdates];
		// TODO: set timer for next update
	} else {
		// no user API Key set in the defaults yet
		NSLog(@"No _userApiKey set");
		[self enableManualUpdateMenuItem:NO];
		[apiWindow showWindow:self];
		// TODO: disable timer
	}
	
	// add KVO observer for userApiKey
	[self observeUserDefault:@"userApiKey"];
}

- (void)enableManualUpdateMenuItem:(BOOL)enabled {
	NSMenuItem *manualUpdateItem = [statusMenu itemWithTitle:@"Manually Check for Updates"];
	[manualUpdateItem setEnabled:enabled];
}

- (void)observeUserDefault:(NSString *)property {
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:property 
											   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
											   context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// do observing here
	NSString *newApiKey = [change objectForKey:NSKeyValueChangeNewKey];
	NSString *oldApiKey = [change objectForKey:NSKeyValueChangeOldKey];
	
	if ( newApiKey != oldApiKey ) {
		NSLog(@"userApiKey changed. old: %@, new: %@", oldApiKey, newApiKey);
		if ( newApiKey != [NSNull null] ) {
			[echowaves setEchowavesURI:newApiKey];
			[self enableManualUpdateMenuItem:YES];
			[self getUpdates];
			// restart timer
			//if ( ![updateTimer isValid] ) [self startTimer];
		} else {
			[self resetUpdatedConvos];
			[self enableManualUpdateMenuItem:NO];
			[self updateStatusbarImage:@"ewBW" withCount:0];
			// stop timer
			//[updateTimer invalidate];
		}
	}
}

- (void)resetUpdatedConvos {
	[echowaves resetUpdatedConvos];
	[echowaves.updatedConvos addObject:_noNewConvosMessage];
	[self reloadMenuItems];
	[self updateStatusbarImage:@"ewBW"];
}

	 
- (IBAction)queryEchowavesServer:(id)sender {
	[self getUpdates];
}

- (IBAction)updateApiKey:(id)sender {
	// 1. Pop window to enter API Key
	// 2. Store users API key into the defaults and Echowaves object
	[NSApp activateIgnoringOtherApps:YES];
	[apiWindow showWindow:self];
}

- (void)reloadMenuItems {
	[statusMenu setAutoenablesItems:NO];

	// remove all menu items until the first separator is reached
	NSArray *itemArray = [statusMenu itemArray];
	for (NSMenuItem *item in itemArray) {
		if ([item isSeparatorItem]) {
			break;  // The first separator item marks the end of the item updates
		}
		[statusMenu removeItem:item];
	}

	if ( ([echowaves.updatedConvos count] == 0 ) || [[echowaves.updatedConvos objectAtIndex:0] isKindOfClass:[NSString class]] ) {
		// no convo updates
		NSMenuItem *newItem = [statusMenu insertItemWithTitle:_noNewConvosMessage action:NULL keyEquivalent:@"" atIndex:0];
		[newItem setEnabled:NO];
		[self updateStatusbarImage:@"ewBW" withCount:0];
	} else {
		// real convo updates
		for (UpdatedConvo *convo in echowaves.updatedConvos) {
			// TODO: need to truncate convo name string if it is longer than 25? chars
			NSMenuItem *newItem = [statusMenu insertItemWithTitle:[NSString stringWithFormat:@"%d - %@", convo.newMessagesCount, convo.ewName] action:@selector(convoSelected:) keyEquivalent:@"" atIndex:0];
			[newItem setTarget:self];
			[newItem setRepresentedObject:convo.ewURI];
		}
		[self updateStatusbarImage:@"ewColor" withCount:[echowaves.updatedConvos count]];
	}
}

- (void)openEchowavesURL:(NSURL *)urlToOpen {
	NSLog(@"Opening URL in browser: %@", urlToOpen);
	[[NSWorkspace sharedWorkspace] openURL:urlToOpen];
}

- (void)convoSelected:(id)sender {
	id convo_id = [sender representedObject];
	NSURL *loadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _convoBaseURI, convo_id]];
	[self openEchowavesURL:loadUrl];
}

- (void)getUpdates {
	// NO OP if no API KEY set
	if ( !_userApiKey ) {
		NSLog(@"No _userApiKey set.  Aborting getUpdates process");
		return;
	}
	
	echowaves.responseData = [[NSMutableData data] retain]; // FIXME: don't I already alloc/init this in Echowaves.m #init method
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:echowaves.echowavesURI]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:echowaves.responseData encoding:NSUTF8StringEncoding];
	[echowaves.responseData release];
	
	if ( [responseString isEqualToString:@"\"Unable to find specified resource.\""] ) {
		NSLog(@"Unable to find specified resource.\n");
	} else {
		[echowaves resetUpdatedConvos];
		NSDictionary *dictionary = [responseString JSONValue];
		if ( [dictionary count] ) {
			for (NSDictionary *subscription in dictionary ) {
				UpdatedConvo *convo = [[UpdatedConvo alloc] initWithConvoName:[[subscription objectForKey:@"subscription"] objectForKey:@"convo_name"]
																	 convoURI:[[subscription objectForKey:@"subscription"] objectForKey:@"conversation_id"]
																  unreadCount:[[[subscription objectForKey:@"subscription"] objectForKey:@"new_messages_count"] integerValue]];
				
				
				NSLog(@"Adding convo: %@", convo);
				[[echowaves updatedConvos] addObject:convo];
				/*
				 * FIXME: pretty sure there is a memory leak here since 
				 * convo isn't being released.  However, when I do the next line
				 * the app crashes on the 2nd time through getUpdates.
				 */
				[convo release];
			}
		} else {
			// * No new subscriptions
			// * for now, just store the blank message
//			NSString *noNewConvos = @"No new convo messages";
//			[echowaves.updatedConvos addObject:noNewConvos];
//			[noNewConvos release];
			
			[[echowaves updatedConvos] addObject:_noNewConvosMessage];
		}
	}
	[self reloadMenuItems];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[echowaves.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[echowaves.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
	[echowaves.updatedConvos removeAllObjects];
	// TODO: will adding a 'Connection failure' message cause crashes elsewhere?? probably
	[echowaves.updatedConvos addObject:@"Connection failure"];
}

- (void)updateStatusbarImage:(NSString *)imagePathName {
	NSBundle *bundle = [NSBundle mainBundle];
	[statusItem setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:imagePathName ofType:@"png"]]];
}

- (void)updateStatusbarImage:(NSString *)imagePathName withCount:(int)count {
	if (count == 0) {
		[statusItem setTitle:@""];
	} else {
		[statusItem setTitle:[NSString stringWithFormat:@"%d", count]];
	}
	[self updateStatusbarImage:imagePathName];
}

- (void)dealloc {
	[echowaves release];
	[apiWindow release];
	[growl release];
	
	if (updateTimer != nil) {
		[updateTimer invalidate];
		updateTimer = nil;
	}
	
	// Release the 2 images we loaded into memory
	[ewImage release];
	[ewHighlightImage release];
	[super dealloc];
}

@end
