//
//  schoolScheduleQuerryViewController.m
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "schoolScheduleQuerryViewController.h"

@interface schoolScheduleQuerryViewController (){
    NSDictionary *_scheDic;
    XYLoadingView *loadingView;
    SRRefreshView *_refreshView;
}

@end

@implementation schoolScheduleQuerryViewController

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
    if (!_scheDic) {
        _scheDic = [[publicInfoController new] getSchoolScheduleList];

    }
    if (([[[_scheDic allValues] objectAtIndex:0] count] + [[[_scheDic allValues] objectAtIndex:1] count] + [[[_scheDic allValues] objectAtIndex:2] count]) == 0) {
        [self startToFreshFromServer];
    }
    if (!_refreshView) {
        _refreshView = [[SRRefreshView alloc] init];
    }
    
    _refreshView.delegate = self;
    //_refreshView.upInset = 44;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor blackColor];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor blackColor];
    [self.tableView addSubview:_refreshView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_scheDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [[_scheDic objectForKey:[NSString stringWithFormat:@"%d",importantEventType]] count];
            break;
        case 1:
            return [[_scheDic objectForKey:[NSString stringWithFormat:@"%d",examType]] count];
            break;
        case 2:
            return [[_scheDic objectForKey:[NSString stringWithFormat:@"%d",vacationType]] count];
            break;
        default:
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
    case 0:
        return @"重要事件";
        break;
    case 1:
        return @"考试周";
        break;
    case 2:
        return @"假期";
        break;
    default:
        return nil;
        break;
    }

}
- (PrettyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"xiaoli";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    schoolScheduleDataModel *schModel = nil;
    switch (indexPath.section) {
        case 0:
            schModel = [[schoolScheduleDataModel alloc] initWithLocalJson:[[_scheDic objectForKey:[NSString stringWithFormat:@"%d",importantEventType]] objectAtIndex:indexPath.row]];
            break;
        case 1:
            schModel = [[schoolScheduleDataModel alloc] initWithLocalJson:[[_scheDic objectForKey:[NSString stringWithFormat:@"%d",examType]] objectAtIndex:indexPath.row]];
            break;
        case 2:
            schModel = [[schoolScheduleDataModel alloc] initWithLocalJson:[[_scheDic objectForKey:[NSString stringWithFormat:@"%d",vacationType]] objectAtIndex:indexPath.row]];
            break;
        default:
            return nil;
            break;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy MM dd";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
    lblTitle.text = schModel.sjnr;
    
    UILabel *lblStartDate = (UILabel *)[cell viewWithTag:2];
    lblStartDate.text = [formatter stringFromDate:schModel.startTime];

    UILabel *lblendDate = (UILabel *)[cell viewWithTag:3];
    lblendDate.text = [formatter stringFromDate:schModel.endTime];

    // Configure the cell...
    cell.tableViewBackgroundColor = tableView.backgroundColor;
    cell.gradientStartColor = [UIColor colorWithHex:0xEEEEEE];
    cell.gradientEndColor = [UIColor colorWithHex:0xDEDEDE];
    [cell prepareForTableView:tableView indexPath:indexPath];
    
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

- (IBAction)btnFresh:(id)sender{
    [self startToFreshFromServer];
}
- (void)fresh{
    _scheDic = [[publicInfoController new] getSchoolScheduleList];
    [self.tableView reloadData];
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
    [[publicInfoController new] freshFromServer:FRESH_XIAOLI];
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
