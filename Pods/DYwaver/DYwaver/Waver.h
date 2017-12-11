//
//  Waver.h
//  DYwaver
//
//  Created by huyangyang on 2017/12/11.
//  Copyright © 2017年 HuYangYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Waver : UIView

@property (nonatomic) CGFloat level;

@property (nonatomic, copy) void (^waverLevelCallback)(Waver * waver);

-(instancetype)initWithFrame:(CGRect)frame andNumberOfWaves:(NSUInteger)numberOfWaves andWavesColors:(NSArray*)colorsAry andDecorativeWavesWidth:(CGFloat)decorativeWavesWidth;
@end
