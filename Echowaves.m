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
//		updatedConvos = [[NSMutableArray array] retain];
//		responseData = [[NSMutableData data] retain];
//		updatedConvos = [NSMutableArray array];
//		responseData = [NSMutableData data];
		updatedConvos = [[NSMutableArray alloc] initWithCapacity:0];
		responseData = [[NSMutableData alloc] initWithCapacity:0];
	}
	return self;
}

- (void)setEchowavesURI:(NSString *)apiKey {
	// TODO: do I need to do some retain/release on the old and new apiKey's here???	
	//[apiKey retain];
	//[echowavesURI release];
	
	echowavesURI = [[_echowavesBaseURI stringByAppendingString:apiKey] retain];
	NSLog(@"Setting echowavesURI: %@", echowavesURI);
}

- (void)dealloc {
	[echowavesURI release];
	[updatedConvos release];
	[responseData release];
	[super dealloc];
}

- (void)resetUpdatedConvos {
	[updatedConvos removeAllObjects];
	//updatedConvos = [NSMutableArray array];
	//updatedConvos = nil;
}

@end
