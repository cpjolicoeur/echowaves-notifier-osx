//
//  UpdatedConvo.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/27/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "UpdatedConvo.h"


@implementation UpdatedConvo

@synthesize URI, name, newMessagesCount;

- (id)initWithConvoName:(NSString *)convoName convoURI:(NSString *)convoURI unreadCount:(int)updatesCount; {
	if ( self = [super init] ) {
		// do custom stuff here
		URI = convoURI;
		name = convoName;
		newMessagesCount = updatesCount;
	}
	return self;
}

- (void)dealloc {
	[URI release];
	[name release];
	[super dealloc];
}

@end
