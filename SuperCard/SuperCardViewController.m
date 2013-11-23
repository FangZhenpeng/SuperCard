//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by 方振鹏 on 13-11-23.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import "SuperCardViewController.h"
#import "PlayingCardView.h"

@interface SuperCardViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView * playingCardView;

@end

@implementation SuperCardViewController

- (void) setPlayingCardView:(PlayingCardView *)playingCardView{
    _playingCardView = playingCardView;
    playingCardView.rank = 9;
    playingCardView.suit = @"♥";
    playingCardView.faceUp = YES;
    [playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:playingCardView action:@selector(pinch:)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    [UIView transitionWithView:self.playingCardView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.playingCardView.faceUp = !self.playingCardView.faceUp;
    } completion:NULL];
}

@end
