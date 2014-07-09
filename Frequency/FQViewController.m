//
//  FQViewController.m
//  Frequency
//
//  Created by Zach Leach on 7/8/14.
//  Copyright (c) 2014 Zach. All rights reserved.
//

#import "FQViewController.h"

@interface FQViewController ()

@end

@implementation FQViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    const double amplitude = 0.5;
    const double frequency = 850;

    toneGenerator = [[TGSineWaveToneGenerator alloc] initWithFrequency:frequency amplitude:amplitude];
    
    currentChannel = @"my_channel";
    
    // Instantiate Messaging Client
    ortcClient = [OrtcClient ortcClientWithConfig:self];
    
    // Set connection properties
    [ortcClient setConnectionMetadata:@"clientConnMeta"];
    [ortcClient setClusterUrl:@"http://ortc-developers.realtime.co/server/2.1/"];
    
    // Connect
    [ortcClient connect:@"gcfS2U"
    authenticationToken:@"paNrPBFNdii7"];
}

- (void) onConnected:(OrtcClient*) ortc
{
    // Messaging client is connected
    __weak typeof(toneGenerator) weakTone = toneGenerator;

    onMessage = ^(OrtcClient* ortc, NSString* channel, NSString* message) {
        if([message isEqualToString:@"START_BEEP"])[weakTone play];
        if([message isEqualToString:@"END_BEEP"])[weakTone stop];
    };
    
    [ortcClient  subscribe:currentChannel
    subscribeOnReconnected:YES
                 onMessage:onMessage];
}

- (void) onSubscribed:(OrtcClient*) ortc channel:(NSString*) channel
{
    [ortcClient send:currentChannel message:@"iOS CONNECTED"];
}

- (void) onDisconnected:(OrtcClient*) ortc
{
    // Disconnected
}

- (void) onReconnecting:(OrtcClient*) ortc
{
    // Trying to reconnect
}

- (void) onReconnected:(OrtcClient*) ortc
{
    // Reconnected
}

- (void) onUnsubscribed:(OrtcClient*) ortc channel:(NSString*) channel
{
    // Unsubscribed from the channel 'channel'
    [ortcClient disconnect];
}

- (void) onException:(OrtcClient*) ortc error:(NSError*) error
{
    // Exception occurred
}

// BEEPING
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [ortcClient send:currentChannel message:@"START_BEEP"];
    
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [ortcClient send:currentChannel message:@"END_BEEP"];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end
