






#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLoadingTool : NSObject


/**
 显示圆环加载动画

 @param view 要显示的view
 */
+(void)showCircleLoadingAt:(UIView *)view;


/**
 隐藏
 */
+(void)dismiss;

@end

NS_ASSUME_NONNULL_END
