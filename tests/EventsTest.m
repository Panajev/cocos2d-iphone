//
// Event Tests
// a cocos2d example
// http://www.cocos2d-iphone.org
//

// cocos import
#import "cocos2d.h"

// local import
#import "EventsTest.h"

static int sceneIdx=-1;

static NSString *transitions[] = {
	@"KeyboardTest",
	@"MouseTest",

};

Class nextAction()
{
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	int total = ( sizeof(transitions) / sizeof(transitions[0]) );
	if( sceneIdx < 0 )
		sceneIdx += total;	
	
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}


@implementation EventTest
-(id) init
{
	if( (self = [super init])) {

		CGSize s = [[CCDirector sharedDirector] winSize];
			
		CCLabelTTF* label = [CCLabelTTF labelWithString:[self title] fontName:@"Arial" fontSize:32];
		[self addChild: label z:1];
		[label setPosition: ccp(s.width/2, s.height-50)];
		
		NSString *subtitle = [self subtitle];
		if( subtitle ) {
			CCLabelTTF* l = [CCLabelTTF labelWithString:subtitle fontName:@"Thonburi" fontSize:16];
			[self addChild:l z:1];
			[l setPosition:ccp(s.width/2, s.height-80)];
		}	
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
		
		menu.position = CGPointZero;
		item1.position = ccp( s.width/2 - 100,30);
		item2.position = ccp( s.width/2, 30);
		item3.position = ccp( s.width/2 + 100,30);
		[self addChild: menu z:1];	
	}

	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) restartCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [restartAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) nextCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [nextAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [backAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(NSString*) title
{
	return @"No title";
}

-(NSString*) subtitle
{
	return nil;
}
@end

#pragma mark Keyboard Test

@implementation KeyboardTest


-(id) init
{
	if( (self=[super init]) ) {
		
		self.isKeyboardEnabled = YES;		
	}
	
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(NSString *) title
{
	return @"Keyboard Test";
}

-(NSString *) subtitle
{
	return @"Press & Release keys. See console";
}

-(BOOL) ccFlagsChanged:(NSEvent*)event
{
	NSLog(@"flags changed: 0x%lx", [event modifierFlags] );
	return YES;
}

-(BOOL) ccKeyDown:(NSEvent *)event
{
	NSLog(@"key down: %@", [event characters] );
	return YES;
}

-(BOOL) ccKeyUp:(NSEvent *)event
{
	NSLog(@"key up: %@", [event characters] );
	return YES;
}
@end


#pragma mark Mouse Test

@implementation MouseTest

-(id) init
{
	if( (self=[super init]) ) {
		
		self.isMouseEnabled = YES;
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	cocos2dmacAppDelegate *delegate = [NSApp delegate];
	[[delegate window] setAcceptsMouseMovedEvents:YES];
}

-(void) onExit
{
	cocos2dmacAppDelegate *delegate = [NSApp delegate];
	[[delegate window] setAcceptsMouseMovedEvents:NO];

	[super onExit];
}

-(void) dealloc
{
	[super dealloc];
}

-(NSString *) title
{
	return @"Mouse Test";
}

-(NSString *) subtitle
{
	return @"Move the mouse. Press buttons. See the console";
}


-(BOOL) ccMouseDown:(NSEvent *)event
{
	NSLog(@"mouseDown: %@", event);
	return YES;
}

-(BOOL) ccMouseDragged:(NSEvent *)event
{
	NSLog(@"mouseDragged: %@", event);
	return YES;
}

-(BOOL) ccMouseUp:(NSEvent *)event
{
	NSLog(@"mouseUp: %@", event);
	return YES;
}

-(BOOL) ccMouseMoved:(NSEvent *)event
{
	NSLog(@"mouseMoved: %@", event);
	return YES;
}

- (BOOL)ccScrollWheel:(NSEvent *)event
{
	NSLog(@"scrollWheel: %@", event);
	return YES;
}

@end


#pragma mark -
#pragma mark Application Delegate - iPhone

// CLASS IMPLEMENTATIONS

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Turn on display FPS
	[director setDisplayFPS:YES];
	
	CCScene *scene = [CCScene node];
	[scene addChild: [nextAction() node]];

	[director runWithScene: scene];
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

// sent to background
-(void) applicationDidEnterBackground:(UIApplication*)application
{
	[[CCDirector sharedDirector] stopAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{	
	CC_DIRECTOR_END();
}

// sent to foreground
-(void) applicationWillEnterForeground:(UIApplication*)application
{
	[[CCDirector sharedDirector] startAnimation];
}

// purge memroy
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window release];
	[super dealloc];
}
@end


#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#pragma mark AppController - Mac

@implementation cocos2dmacAppDelegate

@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	CGSize originalSize	= CGSizeMake(8*100, 5*100); //If fullScreen is YES, the glView will be scaled to fill completely screen.
	//CGSize originalSize	= CGSizeZero; // No-scale
	BOOL fullScreen		= NO;
	
	/** Init cocos2d mac */
	/**
	 originalSize: sets the original size of the glView.
	 For example if you want to simulate a iPhone you should set CGSizeMake(480, 320)
	 
	 fullScreen: if fullScreen is NO a normal window will be showed with the original Size.
	 if fullScreen is YES then:
	 - originalSize == {0, 0}
	 the resize mode will be "No_scale"
	 - originalSize != {0, 0}
	 the resize mode will be "Auto-scale"
	 
	 CC_DIRECTOR_INIT configures the NSWindow and the resizing mode automatically.
	 
	 */
	CC_DIRECTOR_INIT(originalSize, fullScreen);
	
	// Enable "moving" mouse event. Default no.
	[window setAcceptsMouseMovedEvents:NO];
	
	CCDirector *director = [CCDirector sharedDirector];
	[director setDisplayFPS:YES];
	
	CCScene *scene = [CCScene node];
	[scene addChild: [nextAction() node]];
	
	[director runWithScene:scene];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
	return YES;
}

- (IBAction)toggleFullScreen: (id)sender
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}

@end
#endif

