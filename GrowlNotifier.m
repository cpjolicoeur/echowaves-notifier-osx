//
//  GrowlNotifier.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/30/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "GrowlNotifier.h"


@implementation GrowlNotifier

- (id)init {
	if ( self = [super init] ) {
		[GrowlApplicationBridge setGrowlDelegate:self];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (NSDictionary *)registrationDictionaryForGrowl {
	NSArray *array = [NSArray arrayWithObjects:@"echowavesNotifier", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"TicketVersion", array, @"AllNotifications", array, @"DefaultNotifications", nil];
	return dict;
}

- (void)growlAlert:(NSString *)message title:(NSString *)title {
	[GrowlApplicationBridge notifyWithTitle:title
								description:message
						   notificationName:@"echowavesNotifier"
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

@end
