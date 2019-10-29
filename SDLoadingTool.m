






#import "SDLoadingTool.h"

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height
#define KLoadingWidth 30
#define KLineWidth 2

@interface SDLoadingTool()

@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, strong) CALayer *circlelayer;

@end

@implementation SDLoadingTool


+(instancetype)share{
    // 保存在静态存储区
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+(void)showCircleLoadingAt:(UIView *)view{
    
    CGFloat loading_W = KLoadingWidth;
    CGFloat loading_H = KLoadingWidth;
    CGFloat loading_X = (KScreenW - loading_W)*0.5;
    CGFloat loading_Y = (KScreenH - loading_H)*0.5;
    CGFloat radius = (loading_W*0.5 - KLineWidth);

    SDLoadingTool *loading = [SDLoadingTool share];

    //圆环背景
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(loading_X, loading_Y, loading_W, loading_H);
    backgroundLayer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;

    //创建圆环
    UIBezierPath *bgBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(loading_W*0.5, loading_W*0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *bgShapeLayer = [CAShapeLayer layer];
    bgShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bgShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    bgShapeLayer.lineWidth = KLineWidth;
    bgShapeLayer.strokeStart = 0;
    bgShapeLayer.strokeEnd = 1;
    bgShapeLayer.lineCap = kCALineCapRound;
    bgShapeLayer.lineDashPhase = 0.8;
    bgShapeLayer.path = bgBezierPath.CGPath;
    [backgroundLayer setMask:bgShapeLayer];
    
    

    //带缺口的圆环
    CALayer *circlelayer = [CALayer layer];
    circlelayer.frame = CGRectMake(loading_X, loading_Y, loading_W, loading_H);
    //缺口圆环的颜色
    circlelayer.backgroundColor = [UIColor darkTextColor].CGColor;
    //创建圆环
    UIBezierPath *circleBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(loading_W*0.5, loading_W*0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *circleShapeLayer = [CAShapeLayer layer];
    circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    circleShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleShapeLayer.lineWidth = KLineWidth;
    circleShapeLayer.strokeStart = 0;
    circleShapeLayer.strokeEnd = 0.9;
    circleShapeLayer.lineCap = kCALineCapRound;
    circleShapeLayer.lineDashPhase = 0.8;
    circleShapeLayer.path = circleBezierPath.CGPath;
    [circlelayer setMask:circleShapeLayer];
    
    
    [view.layer addSublayer:backgroundLayer];
    [view.layer addSublayer:circlelayer];
    
    loading.backgroundLayer = backgroundLayer;
    loading.circlelayer = circlelayer;
    
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 1;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circlelayer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
    
    
}

+(void)dismiss{
    
    SDLoadingTool *loading = [SDLoadingTool share];

    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    alphaAnimation.repeatCount = 1;
    alphaAnimation.duration = 0.5;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [loading.circlelayer addAnimation:alphaAnimation forKey:@"opacityAnnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loading.circlelayer removeAllAnimations];
        [loading.backgroundLayer removeFromSuperlayer];
        [loading.circlelayer removeFromSuperlayer];
        
    });
    
}


@end
