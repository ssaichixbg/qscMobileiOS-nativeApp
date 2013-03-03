//
//  pointsListViewController.m
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "pointsListViewController.h"

@interface pointsListViewController (){
    NSArray *_GPA;
    NSArray *_courses;
    XYLoadingView *loadingView;
    SRRefreshView *_refreshView;
}

@end

@implementation pointsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!_refreshView) _refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    //_refreshView.upInset = 44;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor blackColor];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor blackColor];
    [self.tableView addSubview:_refreshView];
    
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;


}
- (void)viewWillAppear:(BOOL)animated{
    if(!_GPA) _GPA = [[[pointsQuerryController alloc] initWithDefaultUserOutline] getGPALists];
    if(!_courses) _courses = [[[pointsQuerryController alloc] initWithDefaultUserOutline] getSingleCourseLists];
    if ([_GPA count] == 0) {
        [self startToFreshFromServer];
    }
    else{
        [self.tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    _GPA = nil;
    _courses = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"平均绩点";
    }
    else if(section == 1){
        return @"当前学期";
    }
    else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [_GPA count];
    }
    return [_courses count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88 + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}
- (PrettyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSString *CellIdentifier = nil;
    PrettyTableViewCell *cell =nil;
    if (section == 0) {
        CellIdentifier = @"GPA";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        pointsDataModel * pointModel =[[pointsDataModel alloc] initWithGPAJson:[_GPA objectAtIndex:indexPath.row]];
        UILabel *lblPeriod = (UILabel *)[cell viewWithTag:1];
        lblPeriod.text = pointModel.sj;
        UILabel *lblGPA = (UILabel *)[cell viewWithTag:2];
        lblGPA.text = [NSString stringWithFormat:@"均绩：%@",pointModel.jj];
        UILabel *lblXuefen = (UILabel *)[cell viewWithTag:3];
        lblXuefen.text = [NSString stringWithFormat:@"总学分：%@",pointModel.zxf];
    }
    else if(section == 1){
        CellIdentifier = @"singleCourse";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        pointsDataModel * pointModel =[[pointsDataModel alloc] initWithSingleCourseJson:[_courses objectAtIndex:indexPath.row]];
        UILabel *lblName = (UILabel *)[cell viewWithTag:1];
        lblName.text = pointModel.kcmc;
        UILabel *lblGrade = (UILabel *)[cell viewWithTag:2];
        lblGrade.text = [NSString stringWithFormat:@"成绩：%@",pointModel.cj];
        UILabel *lblPoint = (UILabel *)[cell viewWithTag:3];
        lblPoint.text = [NSString stringWithFormat:@"绩点：%@",pointModel.jd];
        UILabel *lblXuefen = (UILabel *)[cell viewWithTag:4];
        lblXuefen.text = [NSString stringWithFormat:@"学分：%@",pointModel.xf];
    }
    
    cell.tableViewBackgroundColor = tableView.backgroundColor;
    cell.gradientStartColor = [UIColor colorWithHex:0xEEEEEE];
    cell.gradientEndColor = [UIColor colorWithHex:0xDEDEDE];
    [cell prepareForTableView:tableView indexPath:indexPath];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (reachable ==  NotReachable) {
        [_refreshView endRefresh];
        XYShowAlert(MSG_UNCONNECT);
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(freshingFromServer) toTarget:self withObject:nil];
    
}

- (IBAction)btnFresh:(id)sender {
    [self startToFreshFromServer];
}

- (void)fresh{
    _GPA = nil;
    _GPA = [[[pointsQuerryController alloc] initWithDefaultUserOutline] getGPALists];
    _courses = nil;
    _courses = [[[pointsQuerryController alloc] initWithDefaultUserOutline] getSingleCourseLists];
    [self.tableView reloadData];
}

-(void)startToFreshFromServer{
    if (reachable ==  NotReachable) {
        [_refreshView endRefresh];
        XYShowAlert(MSG_UNCONNECT);
        return;
    }
    loadingView = [XYLoadingView loadingViewWithMessage:MSG_LOADING_EXAM_LIST];
    [loadingView show];
    [NSThread detachNewThreadSelector:@selector(freshingFromServer) toTarget:self withObject:nil];
}
-(void)freshingFromServer{
    [[[pointsQuerryController alloc] initWithDefaultUser] freshFromServer];
    [self performSelectorOnMainThread:@selector(endFreshing) withObject:nil waitUntilDone:NO];
}
-(void)endFreshing{
    if (loadingView.isLoading) {
        [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:0.2f];
    }
    if (_refreshView.loading) {
        [_refreshView performSelector:@selector(endRefresh)
                           withObject:nil afterDelay:0.2f
                              inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }

    [self fresh];
}
@end
