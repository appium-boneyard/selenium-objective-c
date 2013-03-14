//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteWebDriver : NSObject

- (id)initWithServerAddress:(NSString*)address port:(NSInteger)port;

@end
