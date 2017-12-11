//
//  ViewController.m
//  DYSowVolumeWaver
//
//  Created by huyangyang on 2017/12/11.
//  Copyright © 2017年 HuYangYang.com. All rights reserved.
//

#import "ViewController.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "SampleBufferToVolumeLevelsEngine.h"
#import "DYwaver.h"
@interface ViewController ()

@property (nonatomic ,strong) KSYMoviePlayerController* player;
@property (nonatomic ,strong) Waver* waver;

@property (nonatomic ,assign) float audioVolume;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    

    [self creatMediaPlayer];
    [self creatWaverView];
}
-(void)creatMediaPlayer{
    __weak typeof(self) weakSelf = self;
    _player = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://music.fffffive.com/1500458888991.mp3"]];
    [_player setShouldAutoplay:true];
    [_player setShouldLoop:true];
    _player.audioDataBlock= ^(CMSampleBufferRef buf){
        float volume = [SampleBufferToVolumeLevelsEngine getVolumeLevelsFromeSampleBuffer:buf];
        weakSelf.audioVolume = volume;
    };
    [_player prepareToPlay];
}

-(void)creatWaverView{
    __weak typeof(self) weakSelf = self;
    UIColor* redColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor* orangeColor = [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor* yellowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor* greenColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor* cyanColor = [UIColor colorWithRed:0.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor* blueColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor* purpleColor = [UIColor colorWithRed:139.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSArray* colorsAry = [NSArray arrayWithObjects:redColor,orangeColor,yellowColor,greenColor,cyanColor,blueColor,purpleColor, nil];
    _waver = [[Waver alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2.0 - 40.0, [UIScreen mainScreen].bounds.size.width, 80.0) andNumberOfWaves:7 andWavesColors:colorsAry andDecorativeWavesWidth:1.0];
    [_waver setUserInteractionEnabled:false];
    [self.view addSubview:_waver];
    __weak Waver * weakWaver = _waver;
    _waver.waverLevelCallback = ^(Waver * waver) {
        
        if (weakSelf.audioVolume) {
            float normalizedValue = pow(10, weakSelf.audioVolume/40000) - 1.0;
            weakWaver.level = normalizedValue * 1.0;
        }
        
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
