//
//  BookViewController.m
//  Proxy_ios
//
//  Created by E-Bans on 15/11/18.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import "BookViewController.h"
#import "BookModel.h"
#import "BATableView.h"
#import "BookTableViewCell.h"
#import "BookDetailedViewController.h"

@interface BookViewController () <MyRequestDelegate,BATableViewDelegate,UISearchBarDelegate>
{
    UIView* popView;
    NSMutableArray* showArray;
    NSMutableArray* dataArray;
    NSMutableArray* temporaryArray;
    NSMutableArray* sortingRowEnd;
}

@property (nonatomic, strong) BATableView *contactTableView;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title_Str;
    sortingRowEnd = [[NSMutableArray alloc] init];
    [self createTableView];
    [self requestShowDataList];
    temporaryArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    self.searchBarBook.delegate = self;
    [self.searchBarBook setKeyboardType:UIKeyboardTypeEmailAddress];
    self.searchBarBook.returnKeyType = UIReturnKeyDone;
}
- (void)requestShowDataList
{
    [popView removeFromSuperview];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [temporaryArray removeAllObjects];
    temporaryArray = [[NSMutableArray alloc] init];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"GETALLPERSONINFO",@"Action", nil];
    MyRequest *manager = [MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@%@/ProxyMobile/MobileFrame.ashx",HTTPIP,SLRD] withParameter:dict];
    manager.delegate = self;
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        if ([[dictt objectForKey:@"success"] integerValue] == 1) {
            for (NSDictionary* modelDict in [[dictt objectForKey:@"Data"] objectForKey:@"R"]) {
                [temporaryArray addObject:[BookModel initWithAddData:modelDict]];
            }
            [self sortingData:temporaryArray];
        }else{
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"errorMsg"]];
        }
    };
}

// 创建tableView
- (void) createTableView {
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 44, LWidth, LHeight-44)];
    self.contactTableView.delegate = self;
    [self.view addSubview:self.contactTableView];
}
#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    NSMutableArray * indexTitles = [NSMutableArray array];
    for (NSDictionary * sectionDictionary in showArray) {
        [indexTitles addObject:sectionDictionary[@"indexTitle"]];
    }
    return indexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return showArray[section][@"indexTitle"];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return showArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [showArray[section][@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BookTableViewCell" owner:nil options:nil];
        for (id oneObject in nib)
        {
            if ([oneObject isKindOfClass:[BookTableViewCell class]])
            {
                cell = (BookTableViewCell *)oneObject;
            }
        }
    }
    tableView.rowHeight = 50;
    BookModel* model = [[showArray[indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@",model.userName];
    CGSize size = [self sizeWithString:cell.name.text font:cell.name.font];
    cell.name.frame = CGRectMake(cell.name.frame.origin.x, cell.name.frame.origin.y, size.width+10, cell.name.frame.size.height);
    [cell.phone setTitle:[[NSString stringWithFormat:@"%@",model.phone] stringByReplacingOccurrencesOfString:@";" withString:@""] forState:0];
    CGSize sizebtn = [self sizeWithString:cell.phone.titleLabel.text font:cell.phone.titleLabel.font];
    cell.phone.frame = CGRectMake(cell.name.frame.origin.x+cell.name.frame.size.width, cell.phone.frame.origin.y, sizebtn.width+10, cell.phone.frame.size.height);
    cell.jobs.text = [NSString stringWithFormat:@"%@-%@",model.dept,model.positionName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel* model = [[showArray[indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    BookDetailedViewController* bookVC = [[BookDetailedViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:bookVC animated:YES];
}
#pragma mark ------------------ UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    [self sortingData:temporaryArray];
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0 || [searchText isEqualToString:@""]) {
        [self sortingData:temporaryArray];
    }else{
        if ([self IsChinese:searchText]) {
            NSMutableArray *tempResults = [NSMutableArray array];
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            for (NSInteger i = 0; i < temporaryArray.count; i++) {
                BookModel* model = temporaryArray[i];
                NSString *storeString = model.userName;
                NSRange storeRange = NSMakeRange(0, storeString.length);
                NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
                if (foundRange.length) {
                    [tempResults addObject:model];
                }
                
            }
            if (tempResults.count < 1) {
                [SVProgressHUD showErrorWithStatus:@"没有找到您想找的人~"];
                [self sortingData:temporaryArray];
            }else{
                [showArray removeAllObjects];
                showArray = [[NSMutableArray alloc] init];
                [showArray addObject:@{@"indexTitle":@"",@"data":tempResults}];
                [self.contactTableView reloadData];
            }
        }else{
            NSMutableArray *tempResults = [NSMutableArray array];
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            for (NSInteger i = 0; i < temporaryArray.count; i++) {
                BookModel* model = temporaryArray[i];
               
                NSString *storeString = model.pinYin;
                NSRange storeRange = NSMakeRange(0, storeString.length);
                NSRange foundRange = [storeString rangeOfString:[searchText uppercaseString] options:searchOptions range:storeRange];
                if (foundRange.length) {
                    [tempResults addObject:model];
                }
            }
            if (tempResults.count < 1) {
                [self sortingData:temporaryArray];
            }else{
                [showArray removeAllObjects];
                showArray = [[NSMutableArray alloc] init];
                [showArray addObject:@{@"indexTitle":@"",@"data":tempResults}];
                [self.contactTableView reloadData];
            }
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

#pragma mark ------  自适应
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(LWidth-100, LHeight)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}
#pragma mark ------------------------- 网络环境不可用时的页面
- (void)RequestErrorViewController
{
    [SVProgressHUD dismiss];
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LWidth, LHeight)];
    popView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    UIImageView* imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 160)];
    imag.center = popView.center;
    imag.image = [UIImage imageNamed:@"02e9868d724dae529e06525edbaf024e.png"];
    [popView addSubview:imag];
    [self.view addSubview:popView];
    UITapGestureRecognizer* regiontapGestureT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestShowDataList)];
    [popView addGestureRecognizer:regiontapGestureT];
}
- (void)sortingData:(NSMutableArray *)array//整理数据排列
{
    [showArray removeAllObjects];
    showArray = [[NSMutableArray alloc] init];
    NSMutableArray* rowA = [[NSMutableArray alloc] init];
    NSMutableArray* rowB = [[NSMutableArray alloc] init];
    NSMutableArray* rowC = [[NSMutableArray alloc] init];
    NSMutableArray* rowD = [[NSMutableArray alloc] init];
    NSMutableArray* rowE = [[NSMutableArray alloc] init];
    NSMutableArray* rowF = [[NSMutableArray alloc] init];
    NSMutableArray* rowG = [[NSMutableArray alloc] init];
    NSMutableArray* rowH = [[NSMutableArray alloc] init];
    NSMutableArray* rowI = [[NSMutableArray alloc] init];
    NSMutableArray* rowJ = [[NSMutableArray alloc] init];
    NSMutableArray* rowK = [[NSMutableArray alloc] init];
    NSMutableArray* rowL = [[NSMutableArray alloc] init];
    NSMutableArray* rowM = [[NSMutableArray alloc] init];
    NSMutableArray* rowN = [[NSMutableArray alloc] init];
    NSMutableArray* rowO = [[NSMutableArray alloc] init];
    NSMutableArray* rowP = [[NSMutableArray alloc] init];
    NSMutableArray* rowQ = [[NSMutableArray alloc] init];
    NSMutableArray* rowR = [[NSMutableArray alloc] init];
    NSMutableArray* rowS = [[NSMutableArray alloc] init];
    NSMutableArray* rowT = [[NSMutableArray alloc] init];
    NSMutableArray* rowU = [[NSMutableArray alloc] init];
    NSMutableArray* rowV = [[NSMutableArray alloc] init];
    NSMutableArray* rowW = [[NSMutableArray alloc] init];
    NSMutableArray* rowX = [[NSMutableArray alloc] init];
    NSMutableArray* rowY = [[NSMutableArray alloc] init];
    NSMutableArray* rowZ = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < array.count; index ++) {//首字母排列
        BookModel* model = array[index];
        if ([[model.pinYin substringToIndex:1] isEqualToString:@"A"])[rowA addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"B"])[rowB addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"C"]&![[model.userName substringToIndex:1] isEqualToString:@"沈"])[rowC addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"D"])[rowD addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"E"])[rowE addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"F"])[rowF addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"G"])[rowG addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"H"])[rowH addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"I"])[rowI addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"J"])[rowJ addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"K"])[rowK addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"L"])[rowL addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"M"])[rowM addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"N"])[rowN addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"O"])[rowO addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"P"])[rowP addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"Q"])[rowQ addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"R"])[rowR addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"S"]||[[model.userName substringToIndex:1] isEqualToString:@"沈"])[rowS addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"T"])[rowT addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"U"])[rowU addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"V"])[rowV addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"W"])[rowW addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"X"])[rowX addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"Y"])[rowY addObject:model];
        else if ([[model.pinYin substringToIndex:1] isEqualToString:@"Z"])[rowZ addObject:model];
        if (index == array.count-1) {//for结束后放入大致排序数组
            if (rowA.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"A",@"data":[NSArray arrayWithArray:[self sortingRow:rowA]]}];
            if (rowB.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"B",@"data":[NSArray arrayWithArray:[self sortingRow:rowB]]}];
            if (rowC.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"C",@"data":[NSArray arrayWithArray:[self sortingRow:rowC]]}];
            if (rowD.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"D",@"data":[NSArray arrayWithArray:[self sortingRow:rowD]]}];
            if (rowE.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"E",@"data":[NSArray arrayWithArray:[self sortingRow:rowE]]}];
            if (rowF.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"F",@"data":[NSArray arrayWithArray:[self sortingRow:rowF]]}];
            if (rowG.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"G",@"data":[NSArray arrayWithArray:[self sortingRow:rowG]]}];
            if (rowH.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"H",@"data":[NSArray arrayWithArray:[self sortingRow:rowH]]}];
            if (rowI.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"I",@"data":[NSArray arrayWithArray:[self sortingRow:rowI]]}];
            if (rowJ.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"J",@"data":[NSArray arrayWithArray:[self sortingRow:rowJ]]}];
            if (rowK.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"K",@"data":[NSArray arrayWithArray:[self sortingRow:rowK]]}];
            if (rowL.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"L",@"data":[NSArray arrayWithArray:[self sortingRow:rowL]]}];
            if (rowM.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"M",@"data":[NSArray arrayWithArray:[self sortingRow:rowM]]}];
            if (rowN.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"N",@"data":[NSArray arrayWithArray:[self sortingRow:rowN]]}];
            if (rowO.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"O",@"data":[NSArray arrayWithArray:[self sortingRow:rowO]]}];
            if (rowP.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"P",@"data":[NSArray arrayWithArray:[self sortingRow:rowP]]}];
            if (rowQ.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"Q",@"data":[NSArray arrayWithArray:[self sortingRow:rowQ]]}];
            if (rowR.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"R",@"data":[NSArray arrayWithArray:[self sortingRow:rowR]]}];
            if (rowS.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"S",@"data":[NSArray arrayWithArray:[self sortingRow:rowS]]}];
            if (rowT.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"T",@"data":[NSArray arrayWithArray:[self sortingRow:rowT]]}];
            if (rowU.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"U",@"data":[NSArray arrayWithArray:[self sortingRow:rowU]]}];
            if (rowV.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"V",@"data":[NSArray arrayWithArray:[self sortingRow:rowV]]}];
            if (rowW.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"W",@"data":[NSArray arrayWithArray:[self sortingRow:rowW]]}];
            if (rowX.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"X",@"data":[NSArray arrayWithArray:[self sortingRow:rowX]]}];
            if (rowY.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"Y",@"data":[NSArray arrayWithArray:[self sortingRow:rowY]]}];
            if (rowZ.count>0)[sortingRowEnd removeAllObjects];[showArray addObject:@{@"indexTitle":@"Z",@"data":[NSArray arrayWithArray:[self sortingRow:rowZ]]}];
            [self.contactTableView reloadData];
        }
    }
}
- (NSString *)firstCharactor:(NSString *)aString//返回拼音首字母
{
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *pinYin = [str capitalizedString];
    NSMutableArray* array = [NSMutableArray arrayWithArray:[pinYin componentsSeparatedByString:@" "]];
    NSString* pinYinStr = @"";
    for (NSInteger index = 0; index < array.count; index ++) {
        if (![[array objectAtIndex:index] isEqualToString:@""]) {
            pinYinStr = [NSString stringWithFormat:@"%@%@",pinYinStr,[[array objectAtIndex:index] substringToIndex:1]];
        }
    }
    return pinYinStr;
}
- (NSMutableArray *)sortingRow:(NSMutableArray *)row//重新列队
{
    NSMutableArray* newsArray = [[NSMutableArray alloc] init];
    if (row.count != 0) {
        [sortingRowEnd addObject:row[0]];
        NSString* A = [[row[0] userName] substringToIndex:1];
        
        for (NSInteger s = 1; s < row.count; s ++) {
            NSString* B = [[row[s] userName] substringToIndex:1];
            if ([B isEqualToString:A]) {
                [sortingRowEnd addObject:row[s]];
            }else{
                [newsArray addObject:row[s]];
            }
            if (s == row.count-1) {
                [self sortingRows:newsArray];
            }
        }
    }
    return sortingRowEnd;
}
- (void)sortingRows:(NSMutableArray *)array
{
    NSMutableArray* newsArray = [[NSMutableArray alloc] init];
    if (array.count != 0) {
        [sortingRowEnd addObject:array[0]];
        NSString* A = [[array[0] userName] substringToIndex:1];
        
        for (NSInteger s = 1; s < array.count; s ++) {
            NSString* B = [[array[s] userName] substringToIndex:1];
            if ([B isEqualToString:A]) {
                [sortingRowEnd addObject:array[s]];
            }else{
                [newsArray addObject:array[s]];
            }
            if (s == array.count-1 & array.count != 0) {
                [self sortingRows:newsArray];
            }
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[App ddMenu] setEnableGesture:NO];
}
- (BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.Action=
}

@end
