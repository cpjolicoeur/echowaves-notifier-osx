//
//  EchowavesController.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Echowaves.h"

#define _userApiKey [[NSUserDefaults standardUserDefaults] stringForKey:@"userApiKey"]
#define _convoBaseURI @"http://echowaves.com/conversations/"
#define _updateInterval 300
#define _noNewConvosMessage @"No new convo messages"

@class ApiKeyController;

@interface EchowavesController : NSObject {
	Echowaves *echowaves;
	ApiKeyController *apiWindow;

	IBOutlet NSMenu *statusMenu;
	
	NSStatusItem *statusItem;
	NSImage	*ewImage;
	NSImage *ewHighlightImage;
	NSTimer *updateTimer;
}

@property (nonatomic, retain) NSTimer *updateTimer;

- (IBAction)queryEchowavesServer:(id)sender;
- (IBAction)updateApiKey:(id)sender;
- (void)convoSelected:(id)sender;
- (void)getUpdates;
- (void)openEchowavesURL:(NSURL *)urlToOpen;
- (void)reloadMenuItems;
- (void)observeUserDefault:(NSString *)property;
- (void)enableManualUpdateMenuItem:(BOOL)enabled;
- (void)resetUpdatedConvos;
- (void)updateStatusbarImage:(NSString *)imagePathName;
- (void)updateStatusbarImage:(NSString *)imagePathName withCount:(int)count;
- (void)startTimer;

@end
