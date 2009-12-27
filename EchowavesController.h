//
//  EchowavesController.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Echowaves.h"

//#define _userApiKey [[NSUserDefaults standardUserDefaults] stringForKey:@"userApiKey"];
#define _echowavesURI @"https://echowaves.com/conversations/new_messages.json?user_credentials="

@interface EchowavesController : NSObject {
	Echowaves *echowaves;
	NSUserDefaults *userDefaults;
	
	IBOutlet NSMenu *statusMenu;
	
	NSStatusItem *statusItem;
	NSImage	*ewImage;
	NSImage *ewHighlightImage;
}

- (IBAction)queryEchowavesServer:(id)sender;
- (IBAction)updateApiKey:(id)sender;
- (void)convoSelected:(id)sender;
- (void)getUpdates;

@end
