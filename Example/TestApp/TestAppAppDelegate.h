//
//  TestAppAppDelegate.h
//  TestApp
//
//  Created by Gabriel Handford on 9/5/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TestAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
