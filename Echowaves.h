//
//  Echowaves.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Echowaves : NSObject {
//	NSString *apiKey;
	NSString *echowavesURI;
	NSMutableData *responseData;
	NSMutableArray *updatedConvos;
	//NSInteger updateInterval;
}

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *updatedConvos;
@property (nonatomic, retain) NSString *echowavesURI;

- (void)getUpdates;

@end
