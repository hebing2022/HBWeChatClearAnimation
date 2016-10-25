//
//  ClearView.m
//  HBWeChatClearAnimation
//
//  Created by hebing on 16/10/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "ClearView.h"
@interface ClearView()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) CAShapeLayer *animationLayer;

@property (nonatomic, strong) CAShapeLayer *blueCakeLayer;

@property (nonatomic, strong) CAShapeLayer *greenCakeLayer;

@property (nonatomic, strong) CADisplayLink *playLink;

@property (nonatomic, assign) NSInteger ratio;

@property (nonatomic, copy) NSString *ratioStr;

@end
@implementation ClearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.layer addSublayer:self.circleLayer];
        [self.layer addSublayer:self.animationLayer];
        
        [self startCircleAnimation];
        
        [self textStartAnimation];
    }
    return self;
}
#pragma mark - 外圈
- (CAShapeLayer *)circleLayer
{
    if (!_circleLayer) {
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.lineWidth = 3.0f;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.1].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:self.center radius:60 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _circleLayer.path = path.CGPath;
    }
    
    return _circleLayer;
}
#pragma mark - 滑块
- (CAShapeLayer *)animationLayer
{
    if (!_animationLayer) {
        
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.lineWidth = 3.0f;
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
        _animationLayer.position = self.center;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(0, 0) radius:60 startAngle:0 endAngle:M_PI_4 clockwise:YES];
        _animationLayer.path = path.CGPath;
    }
    
    return _animationLayer;
}
- (CAShapeLayer *)greenCakeLayer
{
    if (!_greenCakeLayer) {
        
        _greenCakeLayer = [CAShapeLayer layer];
        _greenCakeLayer.strokeColor = [UIColor greenColor].CGColor;
        _greenCakeLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:self.center radius:31 startAngle:-M_PI_2 endAngle:-M_PI_2 + 2*M_PI*0.1 clockwise:YES];
        _greenCakeLayer.path = path.CGPath;
        _greenCakeLayer.lineWidth = 62;
        _greenCakeLayer.strokeEnd = 0;
        [self.layer addSublayer:_greenCakeLayer];
    }
    
    return _greenCakeLayer;
}
- (CAShapeLayer *)blueCakeLayer
{
    if (!_blueCakeLayer) {
        
        _blueCakeLayer = [CAShapeLayer layer];
        _blueCakeLayer.fillColor = [UIColor clearColor].CGColor;
        _blueCakeLayer.strokeColor = [UIColor blueColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:self.center radius:30 startAngle:-M_PI_2 + 2*M_PI*0.1 endAngle:-M_PI_2 + 2*M_PI*0.1 + 2*M_PI*0.6 clockwise:YES];
        _blueCakeLayer.path = path.CGPath;
        _blueCakeLayer.lineWidth = 60;
        _blueCakeLayer.strokeEnd = 0;
        [self.layer addSublayer:_blueCakeLayer];
    }
    
    return _blueCakeLayer;
}
#pragma mark - 滑块滑动动画
- (void)startCircleAnimation
{
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    circleAnimation.duration = 2.5f;
    circleAnimation.repeatCount = MAXFLOAT;
    circleAnimation.toValue = @(M_PI*2);
    [_animationLayer addAnimation:circleAnimation forKey:nil];
}
- (void)textStartAnimation
{
    self.playLink.paused = NO;
}
- (void)textStopAnimation
{
    self.playLink.paused = YES;
    [self.playLink invalidate];
    self.playLink = nil;
}
- (CADisplayLink *)playLink
{
    if (!_playLink) {
        
        _playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(textAnimation:)];
        _playLink.paused = YES;
        [_playLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return _playLink;
}
- (void)textAnimation:(CADisplayLink *)palyLink
{
    self.ratio++;
    self.ratioStr = [NSString stringWithFormat:@"%@%ld%%",@"正在加载",self.ratio];
    if (self.ratio > 100) {
        
        self.ratio = 0;
        self.ratioStr = @"正在清理缓存";
        [self textStopAnimation];
        [self performSelector:@selector(textFinishedAnimation) withObject:nil afterDelay:1.0f];
        
    }

    [self setNeedsDisplay];
    
}
- (void)textFinishedAnimation
{
    self.ratioStr = @"已清理缓存800KB";
    [self setNeedsDisplay];
    [self performSelector:@selector(cakeAnimation) withObject:nil afterDelay:1.0f];
}
#pragma mark - 饼状图动画
- (void)cakeAnimation
{
    [self.animationLayer removeAllAnimations];
    [self.animationLayer removeFromSuperlayer];
    
    self.ratioStr = @"";
    [self setNeedsDisplay];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.center radius:30 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI*2 clockwise:YES];
    _circleLayer.path = path.CGPath;
    self.circleLayer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
    self.circleLayer.lineWidth = 60;
    self.circleLayer.strokeEnd = 0;
    
    
    CABasicAnimation *cakeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    cakeAnimation.duration = 2.0f;
    cakeAnimation.fromValue = @(0);
    cakeAnimation.toValue = @(1);
    cakeAnimation.fillMode = kCAFillModeForwards;
    cakeAnimation.removedOnCompletion = NO;
    [self.circleLayer addAnimation:cakeAnimation forKey:nil];
    cakeAnimation.duration = 2*0.1;//根据占的百分比计算时间
    [self.greenCakeLayer addAnimation:cakeAnimation forKey:nil];
    //让动画时间同步
    [self performSelector:@selector(bluCakeAnimation:) withObject:cakeAnimation afterDelay:0.2f];


}
- (void)bluCakeAnimation:(id)animation
{
    CABasicAnimation *cakeAnimation = (CABasicAnimation *)animation;
    cakeAnimation.duration = 2*0.6;
    [self.blueCakeLayer addAnimation:cakeAnimation forKey:nil];
}
#pragma mark - 文字动画
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    UIFont *font = [UIFont systemFontOfSize:13];
    UIColor *color = [[UIColor grayColor] colorWithAlphaComponent:0.5];

    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    //获得size
    CGSize strSize = [self.ratioStr sizeWithAttributes:attributes];
    CGRect textRect = CGRectMake(self.center.x - strSize.width/2, self.center.y - strSize.height/2, 110, 30);
    [self.ratioStr drawInRect:textRect withAttributes:attributes];
}
@end
