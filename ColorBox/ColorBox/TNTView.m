	//
//  TNTView.m
//  ColorBox
//
//  Created by Travis Thieman on 6/7/14.
//  Copyright (c) 2014 com.example. All rights reserved.
//

#import "stdlib.h"

#import "TNTView.h"

@interface TNTView()

@property double gravityX;
@property double gravityY;
@property double gravityZ;

@end

@implementation TNTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)updateColorsX:(double)gravityX Y:(double)gravityY Z:(double)gravityZ {
    self.gravityX = gravityX;
    self.gravityY = gravityY;
    self.gravityZ = gravityZ;
    [self setNeedsDisplay];
}

- (NSMutableArray *)getDrawBoxes {
    float screenHeight = (float)[[UIScreen mainScreen] bounds].size.height;
    float screenWidth = (float)[[UIScreen mainScreen] bounds].size.width;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    int boxesAcross = 40;
    int boxesDown = 71;
    float boxWidth = screenWidth / (float)boxesAcross;
    float boxHeight = screenHeight / (float)boxesDown;

    for (int row = 0; row < boxesDown; row++) {
        for (int column = 0; column < boxesAcross; column++) {
            CGRect newRect = CGRectMake((float)column * boxWidth, (float)row * boxHeight, boxWidth, boxHeight);
            [result addObject:[NSValue valueWithCGRect:newRect]];
        }
    }
    
    return result;
}

- (NSArray *)sortDrawBoxes:(NSMutableArray *)drawBoxes ForRotationByAngle:(double)angle {
    return [drawBoxes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGRect rect1 = [obj1 CGRectValue];
        CGRect rect2 = [obj2 CGRectValue];
        double x1 = (rect1.origin.x * cos(angle)) - (rect1.origin.y * sin(angle));
        double y1 = (rect1.origin.x * sin(angle)) + (rect1.origin.y * cos(angle));
        double x2 = (rect2.origin.x * cos(angle)) - (rect2.origin.y * sin(angle));
        double y2 = (rect2.origin.x * sin(angle)) + (rect2.origin.y * cos(angle));
        if (x1 == x2) {
            return y1 > y2;
        } else {
            return x1 > x2;
        }
    }];
}

- (void)drawRect:(CGRect)rect {
    
    // x of 0 = bottom to ground, x of 1 = right edge to ground, x of -1 = left side to ground
    // y of 0 = flat, -1 = bottom to ground, +1 = top to ground
    
    NSMutableArray *drawBoxes = [self getDrawBoxes];
    double angleOfRotation = atan2(self.gravityY, self.gravityX);
    NSArray *sortedDrawBoxes = [self sortDrawBoxes:drawBoxes ForRotationByAngle:angleOfRotation];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [sortedDrawBoxes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect newRect;
        [obj getValue:&newRect];
        UIColor *boxColor = [UIColor colorWithHue:fmod(((float)idx / (float)[drawBoxes count]) - 0.1, 1)
                                       saturation:0.8 brightness:1.0 alpha:1.0];
        CGContextSetFillColorWithColor(context, boxColor.CGColor);
        CGContextFillRect(context, newRect);
    }];
}

@end
