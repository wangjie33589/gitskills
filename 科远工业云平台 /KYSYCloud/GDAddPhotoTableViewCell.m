//
//  GDAddPhotoTableViewCell.m
//  添加照片Cell
//
//  Created by 郭之栋 on 15/12/28.
//  Copyright © 2015年 郭之栋. All rights reserved.
//

#import "GDAddPhotoTableViewCell.h"

#define SCREENSHEIGHT [UIScreen mainScreen].bounds.size.width
#define BTNWIDTH ([UIScreen mainScreen].bounds.size.width)/5
#define BTNHEIGHT self.bounds.size.width/5/57*73

@implementation GDAddPhotoTableViewCell

////////注意 这个label可以不要  直接用系统方法cell.textlabel
#pragma mark 懒加载
- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc]init];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(BTNWIDTH/5);
            make.centerY.equalTo(self);
            make.size.mas_offset(CGSizeMake(BTNWIDTH, 80));
        }];
    }
    return _titleLab;
}

//////////第 3 部 重写init方法
#pragma mark 重写init方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//修改别选中状态
        
        ///////  4  给arr添加一张原始加号图片
        _photoBtnArr = [NSMutableArray array];
        UIImage *ima1 = [UIImage imageNamed:@"加号.jpg"];
        [_photoBtnArr addObject:ima1];
        
        
        ////////  5   创建layout  创建collectionview   collectionviewcell是封装的
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(BTNWIDTH, BTNHEIGHT);
        layout.minimumLineSpacing = BTNWIDTH/5;
        
        layout.sectionInset = UIEdgeInsetsMake((100-BTNHEIGHT)/2, BTNWIDTH/5, (self.bounds.size.height-BTNHEIGHT)/2, BTNWIDTH/5);
        
        _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100) collectionViewLayout:layout];
        _photoCollectionView.backgroundColor = [UIColor clearColor];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        
       // _photoCollectionView.backgroundColor = [UIColor lightGrayColor];
        [_photoCollectionView registerNib:[UINib nibWithNibName:@"GDAddPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
        [self addSubview:_photoCollectionView];
    }
    return self;
}

/////////  6  执行collectionview的协议
#pragma mark CollectionView的delegate和datasSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoBtnArr.count;////返回数组个数
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GDAddPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.CellImaView.image = [_photoBtnArr objectAtIndex:indexPath.row];
    
    return cell;
}

////// 7  执行点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _photoBtnArr.count-1)////如果选择的collectionviewCell是最后一个
    {
        if (_photoBtnArr.count<10)
        {
            //////////  8  调用ActionSheet
            [[NSNotificationCenter defaultCenter]postNotificationName:@"创建提示框" object:nil];
        }
        else
        {
            
            
            
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"提示" object:nil];

       
//弹出警示框 最多添加5张照片
        }
    }else{
        [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"row"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary *dict =[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"row"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"查看照片" object:nil userInfo:dict];
     
    }
}

-(void)PotoArrArray:(NSMutableArray*)array{
    
    NSLog(@"array-=-======%@",array);
    [_photoBtnArr removeAllObjects];
    UIImage *ima1 = [UIImage imageNamed:@"加号.jpg"];
    [_photoBtnArr addObject:ima1];
    for (UIImage *img in array) {
        [_photoBtnArr insertObject:img atIndex:0];
        
    }

    if (_photoBtnArr.count<5)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片不大于3张" object:nil];
        
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    }
    else if(_photoBtnArr.count<9&&_photoBtnArr.count>=5)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片不大于6张" object:nil];
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    }else if (_photoBtnArr.count<13&&_photoBtnArr.count>=7){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片不大于9张" object:nil];
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
        
        
        
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片大于9张" object:nil];
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    }

    
    [_photoCollectionView reloadData];





}
/////// 15  执行该方法  添加照片到数组index0的位置  刷新collectionview   
-(void)PhotoArrAdd:(UIImage *)ima
{
    [_photoBtnArr insertObject:ima atIndex:0];
    
    if (_photoBtnArr.count<5)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片不大于3张" object:nil];
        
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    }
    else if(_photoBtnArr.count<9&&_photoBtnArr.count>=5)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片不大于6张" object:nil];
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    }else if (_photoBtnArr.count<13&&_photoBtnArr.count>=7){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片不大于9张" object:nil];
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    
    
    
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"图片大于9张" object:nil];
        _photoCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    }
    
    [_photoCollectionView reloadData];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
