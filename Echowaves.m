//
//  Echowaves.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "Echowaves.h"

@implementation Echowaves

@synthesize responseData, updatedConvos;
@synthesize echowavesURI;

- (id)init {
	if ( self = [super init] ) {
		// do custom stuff here
		
		updatedConvos = [[NSMutableArray array] retain];
		
		// https://echowaves.com/conversations/new_messages.json?user_credentials=fR2Pf-OUah5Ec9QVVKp7
		NSString *apiKey = @"fR2Pf-OUah5Ec9QVVKp7";
		NSString *baseURI = @"https://echowaves.com/conversations/new_messages.json?user_credentials=";
		echowavesURI = [[baseURI stringByAppendingString:apiKey] retain];
		NSLog(@"Allocating Echowaves object with URI: %@", echowavesURI);
	}
	return self;
}

- (void)dealloc {
	[echowavesURI release];
	[updatedConvos release];
	[responseData release];
	[super dealloc];
}

@end
