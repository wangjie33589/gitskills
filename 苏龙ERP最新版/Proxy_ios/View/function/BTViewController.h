//
//  BTViewController.h
//  MYsearchdisplaycontroller
//

#import <UIKit/UIKit.h>

@interface BTViewController : UIViewController{
    UIView *refreshFooterView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;






}

-(id)initWithALLMODELARRAY:(NSMutableArray *)ARRATY  DataSourse:(NSArray *)array;
@property (nonatomic, strong) UIView *refreshFooterView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;
@property (nonatomic, strong) NSString *textNoMore;
@property (nonatomic) BOOL hasMore;

@property(nonatomic ,retain)NSMutableArray *DaTAarray;
@property(nonatomic,assign)int flag;
@property(nonatomic,retain)NSMutableArray *AllTaskArray;

- (void)setupStrings;
- (void)addPullToRefreshFooter;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
@end

