//
//  GrowlNotifier.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/30/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Growl.framework/Headers/GrowlApplicationBridge.h"

@interface GrowlNotifier : NSObject <GrowlApplicationBridgeDelegate>{

}

- (void)growlAlert:(NSString *)message title:(NSString *)title;

@end
