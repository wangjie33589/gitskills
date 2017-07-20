//
//  GDAddPhotoTableViewCell.h
//  添加照片Cell
//
//  Created by 郭之栋 on 15/12/28.
//  Copyright © 2015年 郭之栋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry_Xcode5/Masonry.h"
#import "GDAddPhotoCollectionViewCell.h"

@interface GDAddPhotoTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
{
    
}
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)NSMutableArray *photoBtnArr;
@property (nonatomic,strong)UICollectionView *photoCollectionView;

- (void)PhotoArrAdd:(UIImage *)ima;
-(void)PotoArrArray:(NSMutableArray*)array;
@end
