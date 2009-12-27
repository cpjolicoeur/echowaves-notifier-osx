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

@implementation EchowavesController

- (id)init {
	if (self = [super init]) {
		// Create the echowaves objects
		echowaves = [[Echowaves alloc] init];
		userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}

- (void)awakeFromNib {	
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
	//[statusItem setTitle:@"Foobar"];
	
	[ewImage release];
	[ewHighlightImage release];
	
	// Tells the NSStatusItem what menu to load
	[statusItem setMenu:statusMenu];
	// Sets the tooltip for our item
	[statusItem setToolTip:@"Echowaves Notifier"];
	// Enables highlighting
	[statusItem setHighlightMode:YES];
}

- (IBAction)queryEchowavesServer:(id)sender {
	[self getUpdates];
}

- (IBAction)updateApiKey:(id)sender {
	// 1. Pop window to enter API Key
	// 2. Store users API key into the defaults and Echowaves object
	NSLog(@"Inside #updateApiKey");
	[NSApp activateIgnoringOtherApps:YES];
	
	[statusMenu setAutoenablesItems:NO];
	NSArray *itemArray = [statusMenu itemArray];
	for (NSMenuItem *item in itemArray) {
		NSLog(@"Menu item: %@", item);
		if ([item isSeparatorItem]) {
			NSLog(@"Item is separator");
			NSLog(@"Item index: %d", [statusMenu indexOfItem:item]);
			break;  // The first separator item marks the end of the item updates
		}
	}
	[statusMenu insertItemWithTitle:@"MMA HQ" action:@selector(openEchowavesURL:) keyEquivalent:@"" atIndex:0];
}

- (void)openEchowavesURL:(id)sender {
	NSLog(@"Inside #openEchowavesURL");
	NSURL *loadUrl = [NSURL URLWithString:@"http://www.mmahq.com"];
	[[NSWorkspace sharedWorkspace] openURL:loadUrl];
	[loadUrl release];
}

- (void)convoSelected:(id)sender {
	// user clicked a convo from the menu
}

- (void)getUpdates {
	// get updates from Echowaves.com here
	echowaves.responseData = [[NSMutableData data] retain];
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
		NSBundle *bundle = [NSBundle mainBundle];
		[echowaves.updatedConvos removeAllObjects];
		NSDictionary *dictionary = [responseString JSONValue];
		if ( [dictionary count] ) {
			//NSLog(@"returned dictionary data: %@", dictionary);
			for (NSDictionary *subscription in dictionary ) {
				UpdatedConvo *convo = [[UpdatedConvo alloc] initWithConvoName:[[subscription objectForKey:@"subscription"] objectForKey:@"convo_name"]
																	 convoURI:[[subscription objectForKey:@"subscription"] objectForKey:@"@conversation_id"]
																  unreadCount:[[[subscription objectForKey:@"subscription"] objectForKey:@"new_messages_count"] integerValue]];
				
				
				[echowaves.updatedConvos addObject:convo];
				[convo release];
			}
			[statusItem setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ewColor" ofType:@"png"]]];
		} else {
			// * No new subscriptions
			// * for now, just store the blank message
			[echowaves.updatedConvos addObject:@"No new convo messages"];
			[statusItem setImage:[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ewBW" ofType:@"png"]]];
		}
	}
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
	[echowaves.updatedConvos addObject:@"Connection failure"];
}

- (void)dealloc {
	// Release the echowaves object
	[echowaves release];
	
	// Release the 2 images we loaded into memory
	[ewImage release];
	[ewHighlightImage release];
	[super dealloc];
}

@end
