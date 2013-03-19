//
//  WebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebElement : NSObject

@property NSString *opaqueId;

- (id)initWithOpaqueId:(NSString*)opaqueId;

@end
