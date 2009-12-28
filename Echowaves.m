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
		updatedConvos = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)setEchowavesURI:(NSString *)apiKey {
	echowavesURI = [[_echowavesBaseURI stringByAppendingString:apiKey] retain];
	NSLog(@"Setting echowavesURI: %@", echowavesURI);
}

- (void)dealloc {
	[echowavesURI release];
	[updatedConvos release];
	[responseData release];
	[super dealloc];
}

@end
