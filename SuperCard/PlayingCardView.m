//
//  PlayingCardView.m
//  SuperCard
//
//  Created by 方振鹏 on 13-11-23.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end


@implementation PlayingCardView


@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACECARD_SCALE_FACTOR 0.85
#define CORNER_RADIUS 12.0
#define CORNER_TEXT_PADDING 2.0
#define CORNER_SIZE_PERCETAGE 0.20


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if ([self isFaceUp]) {
        NSString * imageName = [NSString stringWithFormat:@"%@%@.png", [self rankAsString], self.suit];
        UIImage * faceImage = [UIImage imageNamed:imageName];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1 - self.faceCardScaleFactor), self.bounds.size.height * (1 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        [self drawCorners];
    }else {
        [[UIImage imageNamed:@"stanford.png"] drawInRect:self.bounds];
    }

}

- (void) drawCorners{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont * cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * CORNER_SIZE_PERCETAGE];
    NSString * cornerString = [NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit];
    NSDictionary * cornerTextAttribute = @{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont};
    
    NSAttributedString * cornerText = [[NSAttributedString alloc] initWithString:cornerString attributes:cornerTextAttribute];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(CORNER_TEXT_PADDING, CORNER_TEXT_PADDING);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
    
}

- (void) pushContextAndRotateUpsideDown{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void) popContext{
//    UIGraphicsPopContext();
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#define PIP_FONT_SCALE_FACTION 0.20
#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void) drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown{
    if (upsideDown) {
        [self pushContextAndRotateUpsideDown];
    }
    
    CGFloat boundWidth = self.bounds.size.width;
    CGFloat boundHeight = self.bounds.size.height;
    CGPoint middle = CGPointMake(boundWidth / 2, boundHeight / 2);
    
    UIFont * pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTION];
    NSAttributedString * attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName : pipFont}];
    
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width / 2 - hoffset * boundWidth, middle.y - pipSize.height / 2 - voffset * boundHeight);
    
    [attributedSuit drawAtPoint:pipOrigin];
    
    if (hoffset) {
        pipOrigin.x += hoffset * 2 * boundWidth;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    
    if (upsideDown) {
        [self popContext];
    }
}

- (void) drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically{
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}

- (void) drawPips{
    if (self.rank == 1 || self.rank == 3 || self.rank == 5 || self.rank == 9) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:0 upsideDown:NO];
    }
    
    if (self.rank == 6 || self.rank == 7 || self.rank == 8) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:0 upsideDown:NO];
    }
    
    if (self.rank == 2 || self.rank == 3 || self.rank == 7 || self.rank == 8 || self.rank == 10) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE upsideDown:self.rank != 7];
    }
    
    if (self.rank >= 4 && self.rank <= 10) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVertically:YES];
    }
    
    if (self.rank == 9 || self.rank == 10) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET1_PERCENTAGE mirroredVertically:YES];
    }
}


#pragma mark - Initialization

- (void) setup{
    
}

- (void) awakeFromNib{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

#pragma mark - Getter and Setter
- (void) setRank:(unsigned int)rank{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void) setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void) setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat) faceCardScaleFactor{
    if (!_faceCardScaleFactor) {
        _faceCardScaleFactor = DEFAULT_FACECARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

- (NSString *) rankAsString{
    NSArray * rankStringArray = @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    NSLog(@"rank : %d\n", self.rank);
    return rankStringArray[self.rank - 1];
}


- (void) pinch:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}

@end
