//
//  Waver.m
//  DYwaver
//
//  Created by huyangyang on 2017/12/11.
//  Copyright © 2017年 HuYangYang.com. All rights reserved.
//

#import "Waver.h"
@interface Waver ()

@property (nonatomic) NSUInteger numberOfWaves;

@property (nonatomic) UIColor * waveColor;

@property (nonatomic) CGFloat mainWaveWidth;

@property (nonatomic) CGFloat decorativeWavesWidth;

@property (nonatomic) CGFloat idleAmplitude;

@property (nonatomic) CGFloat frequency;

@property (nonatomic) CGFloat density;

@property (nonatomic) CGFloat phaseShift;


@property (nonatomic) CGFloat phase;
@property (nonatomic) CGFloat amplitude;
@property (nonatomic) NSMutableArray * waves;
@property (nonatomic) CGFloat waveHeight;
@property (nonatomic) CGFloat waveWidth;
@property (nonatomic) CGFloat waveMid;
@property (nonatomic) CGFloat maxAmplitude;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic ,strong) NSArray *colorsAry;

@end

@implementation Waver

-(instancetype)initWithFrame:(CGRect)frame andNumberOfWaves:(NSUInteger)numberOfWaves andWavesColors:(NSArray *)colorsAry andDecorativeWavesWidth:(CGFloat)decorativeWavesWidth{
    if (self = [super initWithFrame:frame]) {
        self.numberOfWaves = numberOfWaves;
        self.decorativeWavesWidth = decorativeWavesWidth;
        self.colorsAry = colorsAry;
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.waves = [NSMutableArray new];
    
    self.frequency = 1.2f;
    
    self.amplitude = 1.0f;
    self.idleAmplitude = 0.01f;
    
    self.phaseShift = -0.25f;
    self.density = 1.f;
    
    self.waveColor = [UIColor whiteColor];
    self.mainWaveWidth = 2.0f;
    
    self.waveHeight = CGRectGetHeight(self.bounds);
    self.waveWidth  = CGRectGetWidth(self.bounds);
    self.waveMid    = self.waveWidth / 2.0f;
    self.maxAmplitude = self.waveHeight - 4.0f;
}

- (void)setWaverLevelCallback:(void (^)(Waver * waver))waverLevelCallback {
    _waverLevelCallback = waverLevelCallback;
    
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(invokeWaveCallback)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    for(int i=0; i < self.numberOfWaves; i++)
    {
        CAShapeLayer *waveline = [CAShapeLayer layer];
        waveline.lineCap       = kCALineCapButt;
        waveline.lineJoin      = kCALineJoinRound;
        waveline.strokeColor   = [[UIColor clearColor] CGColor];
        waveline.fillColor     = [[UIColor clearColor] CGColor];
        [waveline setLineWidth:self.decorativeWavesWidth];
        UIColor *color = self.colorsAry[i];
        waveline.strokeColor = color.CGColor;
        [self.layer addSublayer:waveline];
        [self.waves addObject:waveline];
    }
    
}

- (void)invokeWaveCallback
{
    self.waverLevelCallback(self);
}

- (void)setLevel:(CGFloat)level
{
    _level = level;
    
    self.phase += self.phaseShift; // Move the wave
    
    self.amplitude = fmax( level, self.idleAmplitude);
    [self updateMeters];
}


- (void)updateMeters
{
    self.waveHeight = CGRectGetHeight(self.bounds);
    self.waveWidth  = CGRectGetWidth(self.bounds);
    self.waveMid    = self.waveWidth / 2.0f;
    self.maxAmplitude = self.waveHeight - 4.0f;
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    for(int i=0; i < self.numberOfWaves; i++) {
        
        UIBezierPath *wavelinePath = [UIBezierPath bezierPath];
        
        // Progress is a value between 1.0 and -0.5, determined by the current wave idx, which is used to alter the wave's amplitude.
        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
        CGFloat normedAmplitude = (1.5f * progress - 0.5f) * self.amplitude;
        
        
        for(CGFloat x = 0; x<self.waveWidth + self.density; x += self.density) {
            
            //Thanks to https://github.com/stefanceriu/SCSiriWaveformView
            // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
            CGFloat scaling = -pow(x / self.waveMid  - 1, 2) + 1; // make center bigger
            
            CGFloat y = scaling * self.maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / self.waveWidth) * self.frequency + self.phase) + (self.waveHeight * 0.5);
            
            if (x==0) {
                [wavelinePath moveToPoint:CGPointMake(x, y)];
            }
            else {
                [wavelinePath addLineToPoint:CGPointMake(x, y)];
            }
        }
        
        CAShapeLayer *waveline = [self.waves objectAtIndex:i];
        waveline.path = [wavelinePath CGPath];
    }
    
    UIGraphicsEndImageContext();
}

- (void)dealloc
{
    [_displayLink invalidate];
}



@end
