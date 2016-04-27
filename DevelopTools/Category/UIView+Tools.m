//
//  viewCategory.m
//  cloud
//
//  Created by jack ray on 11-4-16.
//  Copyright 2011年 oulin. All rights reserved.
//

#import "UIView+Tools.h"
#import <QuartzCore/QuartzCore.h>


#import <objc/runtime.h>
//#import "SDWebImageOperation.h"


#define showProgressIndicator_width 250
#define alertKey @"alertKey"
#define dismissKey @"dismissKey"

@implementation UIView(Tools)
static char SizeRatio = 'p';


+ (instancetype)createLineView:(CGRect)frame color:(UIColor *)color;
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = color;
    return lineView;
}

- (void)addResignFirstResponderGesture;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    [self addGestureRecognizer:tap];
}

- (void)hiddenKeyboard
{
    RESIGN_FIRST_RESPONDER;
}

-(void)roundCorner
{
    self.layer.masksToBounds = YES;  
    self.layer.cornerRadius = 3.0;  
    self.layer.borderWidth = 1.0;
}

-(void)rotateViewStart;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 5 * 2 ];
    rotationAnimation.duration = 5;
    //rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0; 
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)rotateViewStop
{
    
    [self.layer removeAllAnimations];
}

- (void)removeAnimation:(id)obj
{
    [self.layer removeAllAnimations];
}

-(void)addSubviews:(UIView *)view,... NS_REQUIRES_NIL_TERMINATION
{
    [self addSubview:view];
    va_list ap;
    va_start(ap, view);
    UIView *akey=va_arg(ap,id);
    while (akey) {
        [self addSubview:akey];
        akey=va_arg(ap,id);
    }
    va_end(ap);
}

#define transformScale(scale) [NSValue valueWithCATransform3D:[self transform3DScale:scale]]
- (CATransform3D)transform3DScale:(CGFloat)scale
{
    CATransform3D currentTransfrom = CATransform3DScale(self.layer.transform, scale, scale, 1.0f);
    return currentTransfrom;
}

- (CAKeyframeAnimation *)animationWithValues:(NSArray*)values times:(NSArray*)times duration:(CGFloat)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [animation setValues:values];
    [animation setKeyTimes:times];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setRemovedOnCompletion:NO];
    [animation setDuration:duration];
    
    return animation;
}

- (void)animationAlertSmall
{
    NSArray *frameValues = @[transformScale(0.9f), transformScale(1.1f), transformScale(1.0f)];
    NSArray *frameTimes = @[@(0.3f), @(0.5f), @(1.0f)];
    CAKeyframeAnimation *keyanimation = [self animationWithValues:frameValues times:frameTimes duration:0.4f];
    [self.layer addAnimation:keyanimation forKey:alertKey];
    [self.layer performSelector:@selector(removeAnimationForKey:) withObject:alertKey afterDelay:keyanimation.duration];
}

- (void)animationAlert
{
    NSArray *frameValues = @[transformScale(0.1f), transformScale(1.15f), transformScale(0.9f), transformScale(1.0f)];
    NSArray *frameTimes = @[@(0.0f), @(0.5f), @(0.9f), @(1.0f)];
    CAKeyframeAnimation *keyanimation = [self animationWithValues:frameValues times:frameTimes duration:0.4f];
    [self.layer addAnimation:keyanimation forKey:alertKey];
    [self.layer performSelector:@selector(removeAnimationForKey:) withObject:alertKey afterDelay:keyanimation.duration];
}

- (void)animationDismiss
{
    NSArray *frameValues = @[transformScale(1.0f), transformScale(0.95f), transformScale(0.5f)];
    NSArray *frameTimes = @[@(0.0f), @(0.2f), @(0.3f)];
    
    CAKeyframeAnimation *keyanimation = [self animationWithValues:frameValues times:frameTimes duration:0.3f];
 
    [keyanimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:keyanimation forKey:dismissKey];
    [self.layer performSelector:@selector(removeAnimationForKey:) withObject:dismissKey afterDelay:keyanimation.duration];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:keyanimation.duration];
}

-(void)startAnimationWithCurve:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:startPoint];
    
    [bezierPath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(endPoint.x-startPoint.x+10, endPoint.x-startPoint.x-100)];
   
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 0.3;
    animation.path = bezierPath.CGPath;
    animation.delegate=self;
 
    [self.layer addAnimation:animation forKey:nil];
    
}

- (void)makeAPhoneCall:(NSString *)phoneNumber;
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    [self addSubview:callWebview];
}

- (void)loadImageUrlString:(NSString *)urlString placeholderImage:(UIImage *)image;
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (id)self;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:image options:SDWebImageHighPriority];
    }
}

#pragma mark - property
- (void)setSizeRatio:(NSString *)sizeRatio
{
    objc_setAssociatedObject(self, &SizeRatio, sizeRatio, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)sizeRatio
{
    return objc_getAssociatedObject(self, &SizeRatio);
}
@end
