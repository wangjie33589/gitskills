//
//  BYSelectionDetails.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYDetailsList.h"
#import "BYListItem.h"

@interface BYDetailsList()

@property (nonatomic,strong) UIView *sectionHeaderView;

@property (nonatomic,strong) NSMutableArray *allItems;

@property (nonatomic,strong) BYListItem *itemSelect;

@end

@implementation BYDetailsList

-(void)setListAll:(NSMutableArray *)listAll{
    _listAll = listAll;
    self.showsVerticalScrollIndicator = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *listTop = listAll[0];
    [[App ddMenu] setEnableGesture:NO];
    
     __weak typeof(self) unself = self;
    NSInteger count1 = listTop.count;
    for (int i =0; i <count1; i++) {
        BYListItem *item = [[BYListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i% itemPerLine), padding+(kItemH + padding)*(i/itemPerLine), kItemW, kItemH)];
        item.longPressBlock = ^(){
            if (unself.longPressedBlock) {
                unself.longPressedBlock();
            }
        };
        item.operationBlock = ^(animateType type, NSString *itemName, int index){
            if (self.opertionFromItemBlock) {
                self.opertionFromItemBlock(type,itemName,index);
            }
        };
        item.itemName = listTop[i];
        item.location = top;
        [self.topView addObject:item];
        item->locateView = self.topView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        item.hitTextLabel = self.sectionHeaderView;
        [self addSubview:item];
        [self.allItems addObject:item];
        
        if (!self.itemSelect) {
            [item setTitleColor:[UIColor redColor] forState:0];
            self.itemSelect = item;
        }
    }
    self.contentSize = CGSizeMake(kScreenW, 10);
}

-(void)itemRespondFromListBarClickWithItemName:(NSString *)itemName{
    for (int i = 0 ; i<self.allItems.count; i++) {
        BYListItem *item = (BYListItem *)self.allItems[i];
        if ([itemName isEqualToString:item.itemName]) {
            [self.itemSelect setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
            [item setTitleColor:[UIColor redColor] forState:0];
            self.itemSelect = item;
        }
    }
}

-(NSMutableArray *)allItems{
    if (_allItems == nil) {
        _allItems = [NSMutableArray array];
    }
    return _allItems;
}

-(NSMutableArray *)topView{
    if (_topView == nil) {
        _topView = [NSMutableArray array];
    }
    return _topView;
}

-(NSMutableArray *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [NSMutableArray array];
    }
    return _bottomView;
}

@end
