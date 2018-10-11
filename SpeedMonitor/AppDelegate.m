//
//  AppDelegate.m
//  SpeedMonitor
//
//  Created by Charles Wu on 3/23/16.
//  Copyright © 2016 Charles Wu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
													  target: self
													selector: @selector(updateStatusItem)
													userInfo: nil
													 repeats: YES];
	[timer fire];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (id)init {
	self = [super init];
	memset(&ifdata, 0, sizeof(ifdata));

	return self ? self : nil;
}

- (void)awakeFromNib {
	[self createStatusItem];
}

- (void)createStatusItem {
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  statusMenu = [[NSMenu alloc] init];
   
  quit       = [[NSMenuItem alloc] initWithTitle:@"quit"
										  action:@selector(terminate:)
								   keyEquivalent:@"q"];

  //[statusItem setAttributedTitle:speedString];
  [statusItem setEnabled:NO];
  [statusItem setMenu:statusMenu];
  [statusMenu insertItem:quit atIndex:0];

    

  [self updateStatusItem];
}

- (void)updateStatusItem {
  [statusItem setEnabled:YES];

  struct ifmibdata ifmib;
  struct human_readble_string string = {0, NULL};

  fill_interface_data(&ifmib);
  size_t rx_bytes = ifmib.ifmd_data.ifi_ibytes - ifdata.ifi_ibytes;
  size_t tx_bytes = ifmib.ifmd_data.ifi_obytes - ifdata.ifi_obytes;
    
  //update by liu,2018.10.9
    //NSLog( @"Here is a test message upd: '%d'",tmp );
    //NSRect NSMakeRect(CGFloat x, CGFloat y, CGFloat w, CGFloat h);
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 60, 40)];
    [view setWantsLayer:YES];
    [statusItem setView:view];
    
    //CGRect CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
    NSTextField *textUp =  [[NSTextField alloc] initWithFrame:CGRectMake(0, 10, 60, 11)];

    [textUp setFont:[NSFont boldSystemFontOfSize:9]];
    textUp.backgroundColor = [NSColor clearColor];
    textUp.bordered=false;
    [view setNeedsDisplay:NO];

    NSTextField *textDown =  [[NSTextField alloc] initWithFrame:CGRectMake(0, 1, 60, 11)];
    textDown.backgroundColor = [NSColor clearColor];
    [textDown setFont:[NSFont boldSystemFontOfSize:9]];

    textDown.bordered=false;
    
    humanize_digit(tx_bytes, &string);
    [textUp setStringValue:[NSString stringWithFormat:@"↑ %4.0Lf%s",
                          string.number,
                          string.suffix
                          ]];

    humanize_digit(rx_bytes, &string);
    [textDown setStringValue:[NSString stringWithFormat:@"↓ %4.0Lf%s",
                          string.number,
                          string.suffix
                          ]];
    
    [view addSubview:textUp];
    [view addSubview:textDown];
    
  ifdata = ifmib.ifmd_data;
}

@end
