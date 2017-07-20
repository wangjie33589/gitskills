//
//  SearchViewController.m
//  SmartHome
//
//  Created by SciyonSoft_WangJie on 16/8/12.
//
//

#import "SearchViewController.h"
#import "TypeDetilTableViewCell.h"
#import "TppeDetil_twoViewController.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{

    NSString *searStr;
   NSMutableArray *_deviceArray;
    NSArray *_showArray;

}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备搜索";
    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    self.searchBar.delegate=self;
    self.searchBar.returnKeyType=UIReturnKeyDone;
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    [self.myTable registerNib:[UINib nibWithNibName:@"TypeDetilTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.myTable.rowHeight=50;
    
    
}
-(void)backBtn{
    [self dismissViewControllerAnimated:YES completion:nil];




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
            [btn addTarget:self action:@selector(cancel) forControlEvents: UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
-(void)cancel{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{ searStr=@"";
    searStr=searchBar.text;
    [self requestShowData];
    [self.view endEditing:YES];
}



-(void)requestShowData{
    
    _showArray=nil;
           NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10405\",\"serverid\":\"%@\",\"devname\":\"%@\",\"userid\":\"%@\",\"isadmin\":\"1\"}",SERVERID,searStr,USER_ID];
    NSLog(@"urlstring======%@",urlstring);
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];

    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        [SVProgressHUD dismiss];
        
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            //_AreaArray=dictt[@"DATA"];
            _showArray=dictt[@"DATA"];
            //NSLog(@"_AreaArray====%@",_AreaArray);
            [self.myTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _showArray.count;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TypeDetilTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    cell.img.image=[UIImage imageNamed:@"2"];
    //    cell.firstLab.text=_titleArray[indexPath.row];
    //    cell.secondLab.text=[NSString stringWithFormat:@"六键开关      大厅"];
    //    ／／lamp_on lamp_off
    cell.titleLab.text=_showArray[indexPath.row][@"devicename"];
    
    if ([_showArray[indexPath.row][@"status"]integerValue]==1) {
        cell.imgView.image=[UIImage imageNamed:@"lamp_on"];
    }else{
        cell.imgView.image=[UIImage imageNamed:@"lamp_off"];
    }
    NSString *earname;
    if ([_showArray[indexPath.row][@"areaname"] isKindOfClass:[NSNull class]]) {
        earname=@"未分区";
    }else{
        
        earname=_showArray[indexPath.row][@"areaname"];
        
    }
    
    cell.rightlab.text =[NSString stringWithFormat:@"%@  %@  ",_showArray[indexPath.row][@"typename"],earname];
    
    
    return cell;


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    TppeDetil_twoViewController *vc =[[TppeDetil_twoViewController alloc]initWithDic:_showArray[indexPath.row] andArr:_showArray];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

@end
