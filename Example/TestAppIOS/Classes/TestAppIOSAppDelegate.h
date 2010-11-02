//
//  TestAppIOSAppDelegate.h
//  TestAppIOS
//
//  Created by Gabriel Handford on 11/2/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestAppIOSViewController;

@interface TestAppIOSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TestAppIOSViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestAppIOSViewController *viewController;

@end

