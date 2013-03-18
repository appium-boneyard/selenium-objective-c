//
//  SeleniumTests.m
//  SeleniumTests
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumTests.h"
#import "RemoteWebDriver.h"
#import "Capabilities.h"

@implementation SeleniumTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    Capabilities *c = [Capabilities new];
    [c setPlatform:@"ANY"];
    [c setBrowserName:@"firefox"];
    [c setVersion:@"19.0.2"];
    NSError *error;
    RemoteWebDriver *driver = [[RemoteWebDriver alloc] initWithServerAddress:@"0.0.0.0" port:4444 desiredCapabilities:c requiredCapabilities:nil error:&error];
	[driver setUrl:[[NSURL alloc] initWithString:@"http://www.google.com"]];
	NSString *url = [[driver url] absoluteString];
    NSString *pageSource = [driver pageSourceAndReturnError:&error];
	[driver setUrl:[[NSURL alloc] initWithString:@"http://www.bing.com"]];
	[driver back];
	[driver forward];
	[driver refresh];
    NSLog(@"%@", pageSource);
	NSLog(@"%@", url);
    [driver quitAndError:&error];

	STFail(@"Unit tests are not implemented yet in SeleniumTests");
}

@end
