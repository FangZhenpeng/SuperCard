//
//  PlayingCardView.h
//  SuperCard
//
//  Created by 方振鹏 on 13-11-23.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) unsigned int rank;
@property (strong, nonatomic) NSString * suit;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;

- (void) pinch:(UIPinchGestureRecognizer *)gesture;

@end
