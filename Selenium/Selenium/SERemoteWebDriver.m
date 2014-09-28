//
//  SERemoteWebDriver.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SERemoteWebDriver.h"

@interface SERemoteWebDriver ()
	@property SEJsonWireClient *jsonWireClient;
@end

@implementation SERemoteWebDriver

#pragma mark - Public Methods

-(id) init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class SERemoteWebDriver"
                                 userInfo:nil];
    return nil;
}

-(id) initWithServerAddress:(NSString *)address port:(NSInteger)port
{
	self = [super init];
    if (self) {
		[self setErrors:[NSMutableArray new]];
		NSError *error;
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port error:&error]];
		[self addError:error];
    }
    return self;
}

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error
{
    self = [self initWithServerAddress:address port:port];
    if (self) {
		[self setErrors:[NSMutableArray new]];
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port error:error]];
		[self addError:*error];

		// get session
		[self setSession:[self startSessionWithDesiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites]];
        if (self.session == nil)
            return nil;
    }
    return self;
}

-(void)addError:(NSError*)error
{
	if (error == nil || error.code == 0)
		return;
	NSLog(@"Selenium Error: %ld - %@", error.code, error.description);
	[self setLastError:error];
	[[self errors] addObject:error];
}

-(void)quit
{
    NSError *error;
	[self.jsonWireClient deleteSessionWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites
{
	// get session
	NSError *error;
	[self setSession:[self.jsonWireClient postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:&error]];
	[self addError:error];
	if ([error code] != 0)
		return nil;
	return [self session];
}

-(NSArray*) allSessions
{
	NSError *error;
    NSArray *sessions = [self.jsonWireClient getSessionsAndReturnError:&error];
	[self addError:error];
	return sessions;
}

-(NSArray*) allContexts
{
    NSError *error;
    NSArray * windows = [self.jsonWireClient getContextsForSession:self.session.sessionId error:&error];
    [self addError:error];
    return windows;
}

-(NSString*) context
{
    NSError *error;
    NSString* context = [self.jsonWireClient getContextForSession:self.session.sessionId error:&error];
    [self addError:error];
    return context;
}

-(void) setContext:(NSString*)context
{
    NSError *error;
    [self.jsonWireClient postContext:context session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type
{
    NSError *error;
    [self.jsonWireClient postTimeout:timeoutInMilliseconds forType:type session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
	[self.jsonWireClient postAsyncScriptWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
	[self.jsonWireClient postImplicitWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSString*) window
{
	NSError *error;
	NSString* window = [self.jsonWireClient getWindowHandleWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return window;
}

-(NSArray*) allWindows
{
	NSError *error;
	NSArray * windows = [self.jsonWireClient getWindowHandlesWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return windows;
}

-(NSURL*) url
{
	NSError *error;
    NSURL *url = [self.jsonWireClient getURLWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return url;
}

-(void) setUrl:(NSURL*)url
{
	NSError *error;
	[self.jsonWireClient postURL:url session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) forward
{
	NSError *error;
	[self.jsonWireClient postForwardWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) back
{
	NSError *error;
	[self.jsonWireClient postBackWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) refresh
{
	NSError *error;
	[self.jsonWireClient postRefreshWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSDictionary*) executeScript:(NSString*)script
{
	return [self executeScript:script arguments:nil];
}

-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments
{
	NSError *error;
	NSDictionary *output = [self.jsonWireClient postExecuteScript:script arguments:arguments session:self.session.sessionId error:&error];
	[self addError:error];
	return output;
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script
{
	return [self executeAnsynchronousScript:script arguments:nil];
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments
{
	NSError *error;
	NSDictionary *output = [self.jsonWireClient postExecuteAsyncScript:script arguments:arguments session:self.session.sessionId error:&error];
	[self addError:error];
	return output;
}

-(NSImage*) screenshot
{
	NSError *error;
	NSImage *image = [self.jsonWireClient getScreenshotWithSession:self.session.sessionId error:&error];
	return image;
}

-(NSArray*) availableInputMethodEngines
{
	NSError *error;
	NSArray *engines = [self.jsonWireClient getAvailableInputMethodEnginesWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return engines;
}

-(NSString*) activeInputMethodEngine
{
    NSError *error;
	NSString *engine = [self.jsonWireClient getActiveInputMethodEngineWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return engine;
}

-(BOOL) inputMethodEngineIsActive
{
    NSError *error;
	BOOL isActive = [self.jsonWireClient getInputMethodEngineIsActivatedWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return isActive;
}

-(void) deactivateInputMethodEngine
{
    NSError *error;
	[self.jsonWireClient postDeactivateInputMethodEngineWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) activateInputMethodEngine:(NSString*)engine
{
    NSError *error;
	[self.jsonWireClient postActivateInputMethodEngine:engine session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setFrame:(id)name
{
	NSError* error;
	[self.jsonWireClient postSetFrame:name session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setWindow:(NSString*)windowHandle
{
	NSError* error;
	[self.jsonWireClient postSetWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) closeWindow:(NSString*)windowHandle
{
	NSError* error;
	[self.jsonWireClient deleteWindowWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setWindowSize:(NSSize)size window:(NSString*)windowHandle
{
	NSError *error;
	[self.jsonWireClient postSetWindowSize:size window:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSSize) windowSizeForWindow:(NSString*)windowHandle
{
	NSError *error;
	NSSize size = [self.jsonWireClient getWindowSizeWithWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
	return size;
}

-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle
{
	NSError *error;
	[self.jsonWireClient postSetWindowPosition:position window:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSPoint) windowPositionForWindow:(NSString*)windowHandle
{
	NSError *error;
	NSPoint position = [self.jsonWireClient getWindowPositionWithWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
	return position;
}

-(void) maximizeWindow:(NSString*)windowHandle
{
	NSError *error;
	[self.jsonWireClient postMaximizeWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSArray*) cookies
{
	NSError *error;
	NSArray *cookies = [self.jsonWireClient getCookiesWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return cookies;
}

-(void) setCookie:(NSHTTPCookie*)cookie
{
	NSError *error;
	[self.jsonWireClient postCookie:cookie session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) deleteCookies
{
	NSError *error;
	[self.jsonWireClient deleteCookiesWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) deleteCookie:(NSString*)cookieName
{
	NSError *error;
	[self.jsonWireClient deleteCookie:cookieName session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSString*) pageSource
{
    NSError *error;
    NSString *source = [self.jsonWireClient getSourceWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return source;
}

-(NSString*) title
{
    NSError *error;
	NSString *title = [self.jsonWireClient getTitleWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return title;
}

-(SEWebElement*) findElementBy:(SEBy*)by
{
	NSError *error;
	SEWebElement *element = [self.jsonWireClient postElement:by session:self.session.sessionId error:&error];
	[self addError:error];
	return element;
}

-(NSArray*) findElementsBy:(SEBy*)by
{
	NSError *error;
	NSArray *elements = [self.jsonWireClient postElements:by session:self.session.sessionId error:&error];
	[self addError:error];
	return elements;
}

-(SEWebElement*) activeElement
{
	NSError *error;
	SEWebElement *element = [self.jsonWireClient postActiveElementWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return element;
}

-(void) sendKeys:(NSString*)keyString
{
	NSError *error;
	unichar keys[keyString.length+1];
	for(int i=0; i < keyString.length; i++)
		keys[i] = [keyString characterAtIndex:i];
	keys[keyString.length] = '\0';
	[self.jsonWireClient postKeys:keys session:self.session.sessionId error:&error];
	[self addError:error];
}

-(SEScreenOrientation) orientation
{
	NSError *error;
	SEScreenOrientation orientation = [self.jsonWireClient getOrientationWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return orientation;
}

-(void) setOrientation:(SEScreenOrientation)orientation
{
	NSError* error;
	[self.jsonWireClient postOrientation:orientation session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSString*)alertText
{
    NSError *error;
	NSString *alertText = [self.jsonWireClient getAlertTextWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return alertText;
}

-(void) setAlertText:(NSString*)text
{
	NSError* error;
	[self.jsonWireClient postAlertText:text session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) acceptAlert
{
	NSError *error;
	[self.jsonWireClient postAcceptAlertWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) dismissAlert
{
	NSError *error;
	[self.jsonWireClient postDismissAlertWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
	[self moveMouseToElement:nil xOffset:xOffset yOffset:yOffset];
}

-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
	NSError *error;
	[self.jsonWireClient postMoveMouseToElement:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) click
{
	[self clickMouseButton:SELENIUM_MOUSE_LEFT_BUTTON];
}

-(void) clickMouseButton:(SEMouseButton)button
{
	NSError *error;
	[self.jsonWireClient postClickMouseButton:button session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) mouseButtonDown:(SEMouseButton)button
{
	NSError *error;
	[self.jsonWireClient postMouseButtonDown:button session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) mouseButtonUp:(SEMouseButton)button
{
	NSError *error;
	[self.jsonWireClient postMouseButtonUp:button session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) doubleclick
{
	NSError *error;
	[self.jsonWireClient postDoubleClickWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) tapElement:(SEWebElement*)element
{
	NSError *error;
	[self.jsonWireClient postTapElement:element session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) fingerDownAt:(NSPoint)point
{
	NSError *error;
	[self.jsonWireClient postFingerDownAt:point session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) fingerUpAt:(NSPoint)point
{
	NSError *error;
	[self.jsonWireClient postFingerUpAt:point session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) moveFingerTo:(NSPoint)point
{
	NSError *error;
	[self.jsonWireClient postMoveFingerTo:point session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) scrollfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
    NSError *error;
    [self.jsonWireClient postStartScrollingAtParticularLocation:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) scrollTo:(NSPoint)position
{
    NSError *error;
    [self.jsonWireClient postScrollfromAnywhereOnTheScreenWithSession:position session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) doubletapElement:(SEWebElement*)element
{
	NSError *error;
	[self.jsonWireClient postDoubleTapElement:element session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) pressElement:(SEWebElement*)element
{
	NSError *error;
	[self.jsonWireClient postPressElement:element session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) flickfromElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset speed:(NSInteger)speed
{
    NSError *error;
    [self.jsonWireClient postFlickFromParticularLocation:element xOffset:xOffset yOffset:yOffset speed:speed session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) flickWithXSpeed:(NSInteger)xSpeed ySpeed:(NSInteger)ySpeed
{
    NSError *error;
    [self.jsonWireClient postFlickFromAnywhere:xSpeed ySpeed:ySpeed session:self.session.sessionId error:&error];
    [self addError:error];
}

-(SELocation*) location
{
    NSError *error;
    SELocation *location =[self.jsonWireClient getLocationAndReturnError:self.session.sessionId error:&error];
    [self addError:error];
    return location;
}

-(void) setLocation:(SELocation*)location
{
    NSError *error;
    [self.jsonWireClient postLocation:location session:self.session.sessionId error:&error];
    [self addError:error];
}


-(NSArray*) allLocalStorageKeys
{
    NSError *error;
    NSArray *allLocalStorageKeys =[self.jsonWireClient getAllLocalStorageKeys:self.session.sessionId error:&error];
    [self addError:error];
    return allLocalStorageKeys;

}
-(void) setLocalStorageValue:(NSString*)value forKey:(NSString*)key
{
    NSError *error;
    [self.jsonWireClient postSetLocalStorageItemForKey:key value:value session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) clearLocalStorage
{
    NSError *error;
    [self.jsonWireClient deleteLocalStorage:self.session.sessionId error:&error];
    [self addError:error];
}


-(void) localStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self.jsonWireClient getLocalStorageItemForKey:key  session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) deleteLocalStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self.jsonWireClient deleteLocalStorageItemForGivenKey:key session:self.session.sessionId error:&error];
    [self addError:error];
}

-(NSInteger) countOfItemsInLocalStorage
{
    NSError *error;
    NSInteger numItems= [self.jsonWireClient getLocalStorageSize:self.session.sessionId error:&error];
    [self addError:error];
    return numItems;
}

-(NSArray*) allSessionStorageKeys
{
    NSError *error;
    NSArray *allStorageKeys =[self.jsonWireClient getAllStorageKeys:self.session.sessionId error:&error];
    [self addError:error];
    return allStorageKeys;

}

-(void) setSessionStorageValue:(NSString*)value forKey:(NSString*)key
{
    NSError *error;
    [self.jsonWireClient postSetStorageItemForKey:key value:value session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) clearSessionStorage
{
    NSError *error;
    [self.jsonWireClient deleteStorage:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) sessionStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self.jsonWireClient getStorageItemForKey:key  session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void) deleteStorageItemForKey:(NSString*)key
{
    NSError *error;
    [self.jsonWireClient deleteStorageItemForGivenKey:key session:self.session.sessionId error:&error];
    [self addError:error];
}

-(NSInteger) countOfItemsInStorage
{
    NSError *error;
    NSInteger numItems= [self.jsonWireClient getStorageSize:self.session.sessionId error:&error];
    [self addError:error];
    return numItems;
}


-(NSArray*) getLogForType:(SELogType)type
{
    NSError *error;
    NSArray *logsForType =[self.jsonWireClient  getLogForGivenLogType:type session:self.session.sessionId error:&error];
    [self addError:error];
    return logsForType;
}

-(NSArray*) allLogTypes
{
    NSError *error;
    NSArray *logTypes =[self.jsonWireClient getLogTypes:self.session.sessionId error:&error];
    [self addError:error];
    return logTypes;
}

-(SEApplicationCacheStatus) applicationCacheStatus
{
    NSError* error;
    SEApplicationCacheStatus status = [self.jsonWireClient getApplicationCacheStatusWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return status;
}


#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

-(void) shakeDevice {
    NSError *error;
    [self shakeDeviceWithError:&error];
    [self addError:error];
}

-(void) shakeDeviceWithError:(NSError**)error {
    [self.jsonWireClient postShakeDeviceWithSession:self.session.sessionId error:error];
}

-(void) lockDeviceScreen:(NSInteger)seconds {
    NSError *error;
    [self lockDeviceScreen:seconds error:&error];
    [self addError:error];
}

-(void) lockDeviceScreen:(NSInteger)seconds error:(NSError**)error {
    [self.jsonWireClient postLockDeviceWithSession:self.session.sessionId seconds:seconds error:error];
}

-(void) unlockDeviceScreen:(NSInteger)seconds {
    NSError *error;
    [self unlockDeviceScreen:seconds error:&error];
    [self addError:error];
}

-(void) unlockDeviceScreen:(NSInteger)seconds error:(NSError**)error {
    [self.jsonWireClient postUnlockDeviceWithSession:self.session.sessionId error:error];
}

-(BOOL) isDeviceLocked {
    NSError *error;
    BOOL locked = [self isDeviceLockedWithError:&error];
    [self addError:error];
    return locked;
}

-(BOOL) isDeviceLockedWithError:(NSError**)error {
    return [self.jsonWireClient postIsDeviceLockedWithSession:self.session.sessionId error:error];
}

-(void) pressKeycode:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error {
    [self.jsonWireClient postPressKeycode:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) longPressKeycode:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error {
    [self.jsonWireClient postLongPressKeycode:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) triggerKeyEvent:(NSInteger)keycode metaState:(NSInteger)metastate error:(NSError**)error {
    [self.jsonWireClient postKeyEvent:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) rotateDevice:(SEScreenOrientation)orientation
{
    NSError *error;
    [self rotateDevice:orientation error:&error];
    [self addError:error];
}

-(void) rotateDevice:(SEScreenOrientation)orientation error:(NSError**)error {
    [self.jsonWireClient postRotate:orientation session:self.session.sessionId error:error];
}

-(NSString*)currentActivity
{
    NSError *error;
    NSString *currentActivity = [self currentActivityWithError:&error];
    [self addError:error];
    return currentActivity;
}

-(NSString*)currentActivityWithError:(NSError**)error {
    return [self.jsonWireClient getCurrentActivityForDeviceForSession:self.session.sessionId error:error];
}

-(void)installAppAtPath:(NSString*)appPath session:(NSString*)sessionId {
    NSError *error;
    [self installAppAtPath:appPath session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void)installAppAtPath:(NSString*)appPath session:(NSString*)sessionId error:(NSError**)error {
    [self.jsonWireClient postInstallApp:appPath session:self.session.sessionId error:error];
}

-(void)removeApp:(NSString*)bundleId session:(NSString*)sessionId {
    NSError *error;
    [self removeApp:bundleId session:self.session.sessionId error:&error];
    [self addError:error];
}

-(void)removeApp:(NSString*)bundleId session:(NSString*)sessionId error:(NSError**)error {
    [self.jsonWireClient postRemoveApp:bundleId session:self.session.sessionId error:error];
}

-(BOOL)isAppInstalled:(NSString*)bundleId
{
    NSError *error;
    BOOL installed = [self isAppInstalled:bundleId error:&error];
    [self addError:error];
    return installed;
}

-(BOOL)isAppInstalled:(NSString*)bundleId error:(NSError**)error {
    return [self.jsonWireClient postIsAppInstalledWithBundleId:bundleId session:self.session.sessionId error:error];
}

-(void) hideKeyboard {
    NSError *error;
    [self hideKeyboardWithError:&error];
    [self addError:error];
}

-(void) hideKeyboardWithError:(NSError**)error {
    [self.jsonWireClient postHideKeyboardWithSession:self.session.sessionId error:error];
}

-(void) pushFileToPath:(NSString*)filePath data:(NSData*)data {
    NSError *error;
    [self pushFileToPath:filePath data:data error:&error];
    [self addError:error];
}

-(void) pushFileToPath:(NSString*)filePath data:(NSData*)data error:(NSError**) error {
    [self.jsonWireClient postPushFileToPath:filePath data:data session:self.session.sessionId error:error];
}

-(NSData*) pullFileAtPath:(NSString*)filePath {
    NSError *error;
    NSData *data = [self pullFileAtPath:filePath error:&error];
    [self addError:error];
    return data;
}

-(NSData*) pullFileAtPath:(NSString*)filePath error:(NSError**) error {
    return [self.jsonWireClient postPullFileAtPath:filePath session:self.session.sessionId error:error];
}


-(NSData*) pullFolderAtPath:(NSString*)filePath {
    NSError *error;
    NSData *data = [self pullFolderAtPath:filePath error:&error];
    [self addError:error];
    return data;
}

-(NSData*) pullFolderAtPath:(NSString*)filePath error:(NSError**) error {
    return [self.jsonWireClient postPullFolderAtPath:filePath session:self.session.sessionId error:error];
}

-(void) toggleAirplaneMode {
    NSError *error;
    [self toggleAirplaneModeWithError:&error];
    [self addError:error];
}

-(void) toggleAirplaneModeWithError:(NSError**)error {
    [self.jsonWireClient postToggleAirplaneModeWithSession:self.session.sessionId error:error];
}

-(void) toggleCellularData {
    NSError *error;
    [self toggleCellularDataWithError:&error];
    [self addError:error];
}

-(void) toggleCellularDataWithError:(NSError**)error {
    [self.jsonWireClient postToggleDataWithSession:self.session.sessionId error:error];
}

-(void) toggleWifi {
    NSError *error;
    [self toggleWifiWithError:&error];
    [self addError:error];
}

-(void) toggleWifiWithError:(NSError**)error {
    [self.jsonWireClient postToggleWifiWithSession:self.session.sessionId error:error];
}

-(void) toggleLocationServices {
    NSError *error;
    [self toggleLocationServicesWithError:&error];
    [self addError:error];
}

-(void) toggleLocationServicesWithError:(NSError**)error {
    [self.jsonWireClient postToggleLocationServicesWithSession:self.session.sessionId error:error];
}

-(void) openNotifications {
    NSError *error;
    [self openNotificationsWithError:&error];
    [self addError:error];
}

-(void) openNotificationsWithError:(NSError**)error {
    [self.jsonWireClient postOpenNotificationsWithSession:self.session.sessionId error:error];
}

-(void) startActivity:(NSString*)activity package:(NSString*)package {
    [self startActivity:activity package:package waitActivity:nil waitPackage:nil];
}

-(void) startActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage {
    NSError *error;
    [self startActivity:activity package:package waitActivity:waitActivity waitPackage:waitPackage error:&error];
    [self addError:error];
}

-(void) startActivity:(NSString*)activity package:(NSString*)package waitActivity:(NSString*)waitActivity waitPackage:(NSString*)waitPackage error:(NSError**)error {
    [self.jsonWireClient postStartActivity:activity package:package waitActivity:waitActivity waitPackage:waitPackage session:self.session.sessionId error:error];
}

-(void) launchApp
{
    NSError *error;
    [self launchAppWithError:&error];
    [self addError:error];
}

-(void) launchAppWithError:(NSError**)error
{
    [self.jsonWireClient postLaunchAppWithSession:self.session.sessionId error:error];
}

-(void) closeApp
{
    NSError *error;
    [self closeAppWithError:&error];
    [self addError:error];
}

-(void) closeAppWithError:(NSError**)error
{
    [self.jsonWireClient postCloseAppWithSession:self.session.sessionId error:error];
}

-(void) resetApp
{
    NSError *error;
    [self resetAppWithError:&error];
    [self addError:error];
}

-(void) resetAppWithError:(NSError**)error
{
    [self.jsonWireClient postResetAppWithSession:self.session.sessionId error:error];
}

-(void) runAppInBackground:(NSInteger)seconds
{
    NSError *error;
    [self runAppInBackground:seconds error:&error];
    [self addError:error];
}

-(void) runAppInBackground:(NSInteger)seconds error:(NSError**)error
{
    [self.jsonWireClient postRunAppInBackground:seconds session:self.session.sessionId error:error];
}

-(void) endTestCodeCoverage
{
    NSError *error;
    [self endTestCodeCoverageWithError:&error];
    [self addError:error];
}

-(void) endTestCodeCoverageWithError:(NSError**)error
{
    [self.jsonWireClient postEndTestCoverageWithSession:self.session.sessionId error:error];
}

-(NSString*)stringsForApp:(NSString*)bundleId
{
    NSError *error;
    NSString *strings = [self stringsForApp:bundleId error:&error];
    [self addError:error];
    return strings;
}

-(NSString*)stringsForApp:(NSString*)bundleId error:(NSError**)error {
    return [self.jsonWireClient getAppStringsWithBundleId:bundleId session:self.session.sessionId error:error];
}

-(void) setElementValue:(NSString*)value element:(SEWebElement*)element {
    [self setElementValue:value element:element isUnicode:NO];
}

-(void) setElementValue:(NSString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode {
    NSError *error;
    [self setElementValue:value element:element isUnicode:isUnicode error:&error];
    [self addError:error];
}

-(void) setElementValue:(NSString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode error:(NSError**)error
{
    [self.jsonWireClient postSetValueForElement:element value:value isUnicode:isUnicode session:self.session.sessionId error:error];

}

-(void) replaceElementValue:(NSString*)value element:(SEWebElement*)element {
    [self replaceElementValue:value element:element isUnicode:NO];
}

-(void) replaceElementValue:(NSString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode {
    NSError *error;
    [self replaceElementValue:value element:element isUnicode:isUnicode error:&error];
    [self addError:error];
}

-(void) replaceElementValue:(NSString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode error:(NSError**)error
{
    [self.jsonWireClient postReplaceValueForElement:element value:value isUnicode:isUnicode session:self.session.sessionId error:error];
    
}

-(void) setAppiumSettings:(NSDictionary*)settings {
    NSError *error;
    [self setAppiumSettings:settings error:&error];
    [self addError:error];
}

-(void) setAppiumSettings:(NSDictionary*)settings error:(NSError**)error {
    [self.jsonWireClient postSetAppiumSettings:settings session:self.session.sessionId error:error];
}

-(NSDictionary*) appiumSettings {
    NSError *error;
    NSDictionary *settings = [self appiumSettingsWithError:&error];
    [self addError:error];
    return settings;
}

-(NSDictionary*) appiumSettingsWithError:(NSError**)error {
    return [self.jsonWireClient getAppiumSettingsWithSession:self.session.sessionId error:error];
}

@end
