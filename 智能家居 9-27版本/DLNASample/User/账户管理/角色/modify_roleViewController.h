//
//  modify_roleViewController.h
//  SmartHome
//
//  Created by sciyonSoft on 16/6/22.
//
//

#import <UIKit/UIKit.h>
@protocol modify_roleViewDelegate <NSObject>
@end
@interface modify_roleViewController : UIViewController
@property id<modify_roleViewDelegate> userDelegate;
@property (strong, nonatomic) IBOutlet UIButton *headerImg;


@property(nonatomic,strong)NSString *menuIds;//上个界面传过来的roleids

- (id)initWithRoleMenuIds:(NSString *)menuIds;
@end
