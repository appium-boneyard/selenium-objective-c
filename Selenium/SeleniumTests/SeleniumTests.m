//
//  SeleniumTests.m
//  SeleniumTests
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumTests.h"
#import "SERemoteWebDriver.h"
#import "SECapabilities.h"
#import "SEBy.h"
#import "SEWebElement.h"

SERemoteWebDriver *driver;

@implementation SeleniumTests

- (void) setUp
{
    [super setUp];
	SECapabilities *c = [SECapabilities new];
    [c setPlatform:@"ANY"];
    [c setBrowserName:@"firefox"];
	[c setVersion:@"19.0.2"];
    NSError *error;
    driver = [[SERemoteWebDriver alloc] initWithServerAddress:@"0.0.0.0" port:4444 desiredCapabilities:c requiredCapabilities:nil error:&error];
}

- (void) tearDown
{
    [driver quit];
    [super tearDown];
}

- (void) testUrl
{
	NSString *oldUrl = [[driver url] absoluteString];
	[driver setUrl:[[NSURL alloc] initWithString:@"http://www.zoosk.com"]];
	STAssertFalse(([[[driver url] absoluteString] isEqualToString:oldUrl]), @"Url");
}

-(void) testSendKeys
{
	[driver setUrl:[[NSURL alloc] initWithString:@"http://www.zoosk.com"]];
	SEWebElement *a = [driver findElementBy:[SEBy idString:@"signup-firstname"]];
	[a sendKeys:@"Hello"];
	NSString *text = [a text];
	STAssertTrue([text isEqualToString:@"Hello"], @"Send Keys");
}

@end
