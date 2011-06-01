//
//  DemoAppDelegate.h
//  Demo
//
//  Created by Giovambattista Fazioli on 22/04/11.
//  Copyright 2011 Saidmade Srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoViewController;

@interface DemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DemoViewController *viewController;

@end
