//
//  FQViewController.h
//  Frequency
//
//  Created by Zach Leach on 7/8/14.
//  Copyright (c) 2014 Zach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrtcClient.h"
#import "TGSineWaveToneGenerator.h"

@interface FQViewController : UIViewController <OrtcClientDelegate> {
    NSString *currentChannel;
    TGSineWaveToneGenerator *toneGenerator;

    @private
        OrtcClient* ortcClient;
        void (^onMessage)(OrtcClient* ortc, NSString* channel, NSString* message);
}


@end
