//
//  classTableViewController.m
//  iQSC
//
//  Created by zy on 13-2-6.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "classTableViewController.h"

@interface classTableViewController (){
    NSArray *_weekArr;//data source
    NSMutableArray *_dropdownArr;
    NSInteger _currentPage;
    NSInteger _currentWeek;
    classTableController *_tbController;
    dateTypeDataModel *_dateType;
    NSMutableArray *_tableViewArr;//array containing the table views
    XYLoadingView *loadingView;
    NIDropDown *dropView;
}

@end

@implementation classTableViewController
@synthesize scrollView,btnFresh,btnTermType,toolBar,segWeekType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //data
    _tbController = [[classTableController alloc] initWithDefaultUserOutline];
    _weekArr = [_tbController getWeekClassTables];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"e";
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    _currentPage = [[f stringFromDate:[NSDate date]] integerValue];
    _currentPage = (_currentPage-2) == -1 ? 6: (_currentPage -2);
    _dropdownArr = [NSMutableArray arrayWithArray:@[@"春学期",@"夏学期",@"秋学期",@"冬学期"]];
    _dateType = [[publicInfoController new] getDateType];
    //label
    [btnTermType setTitle:[_dropdownArr objectAtIndex:_dateType.periodType] forState:UIControlStateNormal];
    //seg
    segWeekType.selectedSegmentIndex = _dateType.isOdd ? 0 : 1;
    //scrollview
    scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height - 44 );
    scrollView.delegate = self;
    //scrollView.bounces = NO;
    //scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*7, scrollView.frame.size.height-44);
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    [scrollView setContentOffset:CGPointMake(_currentPage*scrollView.frame.size.width , 0) animated:YES];
    //create table
    for (int i = 0; i<7 ; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, scrollView.frame.size.width, scrollView.frame.size.height - 44)];
        tableView.scrollEnabled = YES;
        tableView.showsHorizontalScrollIndicator = tableView.showsVerticalScrollIndicator = NO;
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.bounces = YES;
        tableView.clipsToBounds = YES;
        [scrollView addSubview:tableView];
        [_tableViewArr addObject:tableView];
        [tableView becomeFirstResponder];
    }
    //[self fresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setBtnTermType:nil];
    [self setBtnFresh:nil];
    [self setToolBar:nil];
    [self setSegWeekType:nil];
    [super viewDidUnload];
}
#pragma mark Table View Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor whiteColor];
    CGFloat cellHeight ;
    if (indexPath.row == 0) {
        cellHeight = 44.0;
        cell.frame = CGRectMake(0, 0,tableView.frame.size.width , cellHeight);

        UILabel *lblWeekDay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width,cell.frame.size.height)];
        lblWeekDay.textAlignment = NSTextAlignmentCenter;
        lblWeekDay.tag = 1;
        switch (tableView.tag) {
            case 0:
                lblWeekDay.text = @"星期一";
                break;
            case 1:
                lblWeekDay.text = @"星期二";
                break;
            case 2:
                lblWeekDay.text = @"星期三";
                break;
            case 3:
                lblWeekDay.text = @"星期四";
                break;
            case 4:
                lblWeekDay.text = @"星期五";
                break;
            case 5:
                lblWeekDay.text = @"星期六";
                break;
            case 6:
                lblWeekDay.text = @"星期日";
                break;
            default:
                break;
        }
        [cell addSubview:lblWeekDay];
        
    }
    else{
        cellHeight = 44.0;
        cell.frame = CGRectMake(0, 0,tableView.frame.size.width , cellHeight);
        //if (![_weekArr objectAtIndex:tableView.tag] || ![[_weekArr objectAtIndex:tableView.tag] count]) return cell;

        
        for (NSDictionary *class in [_weekArr objectAtIndex:tableView.tag]) {
            classTableDataModel *classModel = [[classTableDataModel alloc] initWithJson:class];
            //[[plistController new] savePlistFile:_weekArr arrayName:[NSString stringWithFormat:@"kebiao.plist"]];
            if ([classModel.time isKindOfClass:[NSArray class]] && [class count]) {
                for (NSString *timeStr in classModel.time) {
                    if ([timeStr isKindOfClass:[NSString class]] && [timeStr isEqualToString:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                        cellHeight = 100.0;
                        cell.frame = CGRectMake(0, 0,tableView.frame.size.width , cellHeight);
                        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(70,0, cell.frame.size.width - 70,0.5*cellHeight)];
                        lblName.textAlignment = NSTextAlignmentLeft;
                        lblName.tag = 1;
                        lblName.text = classModel.name;
                        [cell addSubview:lblName];
                        cell.frame = CGRectMake(0, 0,tableView.frame.size.width , cellHeight);
                        UILabel *lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(70,0.5*cellHeight, cell.frame.size.width - 70,0.5*cellHeight)];
                        lblPlace.textAlignment = NSTextAlignmentLeft;
                        lblPlace.tag = 2;
                        lblPlace.text = classModel.place;
                        [cell addSubview:lblPlace];
                        
                    }
                }
            }
        }
        UILabel *lblDayNo = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60,cellHeight)];
        lblDayNo.textAlignment = NSTextAlignmentLeft;
        lblDayNo.tag = 2;
        lblDayNo.textColor = [UIColor redColor];
        lblDayNo.text = [NSString stringWithFormat:@"%d",indexPath.row];
        [cell addSubview:lblDayNo];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row ) {
        case 0:
            return 44;
            break;
        default:
            for (NSDictionary *class in [_weekArr objectAtIndex:tableView.tag]) {
                classTableDataModel *classModel = [[classTableDataModel alloc] initWithJson:class];
                if ([classModel.time isKindOfClass:[NSArray class]] && [class count]) {
                    for (NSString *timeStr in classModel.time) {
                        if ([timeStr isKindOfClass:[NSString class]] && [timeStr isEqualToString:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                            return 100;
                        }
                    }
                }
            }
            return 44;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)stepperDay:(id)sender {
}

- (IBAction)segWeekType:(id)sender {
    UISegmentedControl *seg = sender;
    _dateType.isOdd = seg.selectedSegmentIndex == 0 ? YES:NO;
    _weekArr = nil;
    _weekArr = [_tbController getWeekClassTables:_dateType];
    [self fresh];
}

- (IBAction)btnFresh:(id)sender {
    [self startToFreshFromServer];
}
#pragma mark NIDropDown delegate
-(void)niDropDownDelegateMethod:(NIDropDown *)sender{
    _dateType.periodType = sender.selectedRow;
    _weekArr = nil;
    _weekArr = [_tbController getWeekClassTables:_dateType];
    [self fresh];

}
- (IBAction)btnTermType:(id)sender {
    if (!dropView) {
        dropView = [[NIDropDown alloc]init];
        dropView.delegate = self;
        CGFloat f = 40*[_dropdownArr count];
        [dropView showDropDown:sender height:&f names:_dropdownArr];
    }
    else if(!dropView.isDropped) {
        CGFloat f = 40*[_dropdownArr count];
        [dropView showDropDown:sender height:&f names:_dropdownArr];
    }
    else {
        [dropView hideDropDown:sender];
    }
}
-(void)fresh{
    for (UITableView *tbView in _tableViewArr) {
        [scrollView delete:tbView];
    }
    [_tableViewArr removeAllObjects];
    for (int i = 0; i<7 ; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        tableView.scrollEnabled = YES;
        tableView.showsHorizontalScrollIndicator = tableView.showsVerticalScrollIndicator = NO;
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        [scrollView addSubview:tableView];
        [_tableViewArr addObject:tableView];
    }
}
-(void)startToFreshFromServer{
    if (reachable ==  NotReachable) {
        XYShowAlert(MSG_UNCONNECT);
        return;
    }
    loadingView = [XYLoadingView loadingViewWithMessage:MSG_LOADING_EXAM_LIST];
    [loadingView show];
    [NSThread detachNewThreadSelector:@selector(freshingFromServer) toTarget:self withObject:nil];
}
-(void)freshingFromServer{
    [[[classTableController alloc] initWithDefaultUser] freshFromServer];
    [self performSelectorOnMainThread:@selector(endFreshing) withObject:nil waitUntilDone:NO];
}
-(void)endFreshing{
    if (loadingView.isLoading) {
        [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:0.2f];
    }
    _weekArr = nil;
    [_tbController freshCache];
    //_tbController = nil;
    //_tbController = [[classTableController alloc] initWithDefaultUserOutline];
    _weekArr = [_tbController getWeekClassTables];
    [self fresh];
}

@end
