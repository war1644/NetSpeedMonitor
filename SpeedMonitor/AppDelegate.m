//
//  AppDelegate.m
//  SpeedMonitor
//
//  Created by Charles Wu on 3/23/16.
//  Copyright © 2016 Charles Wu. All rights reserved.
//
//  update by liu, support mac os 10.15+

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

  [statusItem setImage:[NSImage imageNamed:@"bandwidth-black.png"]];
  [statusItem setToolTip:@"StatusItem"];

  [statusItem setAttributedTitle:speedString];
  [statusItem setMenu:statusMenu];
  [statusMenu insertItem:quit atIndex:0];
    
    
  [self updateStatusItem];
}

- (void)updateStatusItem {

  struct ifmibdata ifmib;
  struct human_readble_string string = {0, NULL};

  fill_interface_data(&ifmib);
  size_t rx_bytes = ifmib.ifmd_data.ifi_ibytes - ifdata.ifi_ibytes;
  size_t tx_bytes = ifmib.ifmd_data.ifi_obytes - ifdata.ifi_obytes;
    
    //update by liu,2020.6.26 fix muti screen bug
    //update by liu,2018.10.9
    //NSLog( @"Here is a test message upd: '%d'",tmp );
    //Get menuBarHeight,Set Text height=menuBarHeight/2 weight=menuBarHeight*2
    CGFloat h = [[[NSApplication sharedApplication] mainMenu] menuBarHeight];
    CGFloat fs=10;
    //5个字符长度
    CGFloat w=45;
    CGFloat th=h/2;
    
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, w, h)];
    [view setWantsLayer:YES];
    [statusItem setView:view];

    CGFloat iw=0;
    CGFloat tx=iw;
    NSTextField *textUp =  [[NSTextField alloc] initWithFrame:CGRectMake(tx, th-1, w, th)];
    NSTextField *textDown =  [[NSTextField alloc] initWithFrame:CGRectMake(tx, 1, w, th)];
    
    [textUp setFont:[NSFont boldSystemFontOfSize:fs]];
    [textDown setFont:[NSFont boldSystemFontOfSize:fs]];
    //no border
    [textUp setBordered:false];
    [textDown setBordered:false];
    //pos
    [textUp setAlignment:NSTextAlignmentLeft];
    [textDown setAlignment:NSTextAlignmentLeft];
    //去除表层的阴影
    [textUp setBackgroundColor:[NSColor clearColor]];
    [textDown setBackgroundColor:[NSColor clearColor]];
    //只刷新部分区域
    [textUp setNeedsDisplay:YES];
    [textDown setNeedsDisplay:YES];
    //不可选中
    [textUp setSelectable:false];
    [textDown setSelectable:false];

    //deal with data
    humanize_digit(tx_bytes, &string);
    [textUp setStringValue:[NSString stringWithFormat:
                          @"↑ %3.Lf%s",
                          string.number,
                          string.suffix
                          ]];
    humanize_digit(rx_bytes, &string);
    [textDown setStringValue:[NSString stringWithFormat:
                          @"↓ %3.Lf%s",
                          string.number,
                          string.suffix
                          ]];
    
    [view setNeedsLayout:true];
    [view addSubview:textUp];
    [view addSubview:textDown];
  
// TODO arrow images cant refresh when theme color changed
//    NSImageView *imgView = [[NSImageView alloc]init];
//    imgView.frame = NSMakeRect(0, 0, iw, h);
//    NSAppearance *appearance = NSAppearance.currentAppearance;
//
//    if (@available(*, macOS 10.14)) {
//        if (appearance.name == NSAppearanceNameDarkAqua){
//            imgView.image = [NSImage imageNamed:@"bandwidth-white"];
//            //NSLog(@"dark");
//
//        }else{
//            //NSLog(@"white");
//            imgView.image = [NSImage imageNamed:@"bandwidth-black"];
//        }
//    }
//    [imgView setNeedsLayout:true];
//    [imgView setNeedsDisplay:YES];
//
//   // NSLog(@"%@", current().name);
//    [view addSubview:imgView];

    ifdata = ifmib.ifmd_data;
}

@end
