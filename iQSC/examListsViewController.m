//
//  examListsViewController.m
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "examListsViewController.h"

@interface examListsViewController (){
    NSArray *_exams;
    NSInteger _selected;
    XYLoadingView *loadingView;
    SRRefreshView *_refreshView;
}

@end

@implementation examListsViewController

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;

}
- (void)viewWillAppear:(BOOL)animated{

    if (!_exams) _exams = [[[examQuerryController alloc] initWithDefaultUserOutline] getExamLists];
    _selected = 0;
    if ([_exams count] == 0) {
        [self startToFreshFromServer];
    }
    else{
        [self.tableView reloadData];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    _exams = nil;
    _refreshView = nil;
    loadingView = nil;
    //_selected = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_exams count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (PrettyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"kaoshi_style1";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    examsDataModel *examModel = [[examsDataModel alloc] initWithJson:[_exams objectAtIndex:indexPath.section]];
    // Configure the cell...
    UILabel *lblCourseName = (UILabel *)[cell viewWithTag:4];
    lblCourseName.text = examModel.kcmc;
    UILabel *lblPlace = (UILabel *)[cell viewWithTag:1];
    if ([examModel.ksdd isEqualToString:@" "]) lblPlace.text = @"地点：待定";
    else lblPlace.text = examModel.ksdd;
    UILabel *lblTime = (UILabel *)[cell viewWithTag:2];
    lblTime.text = examModel.kssj;
    UILabel *lblSeatIndex = (UILabel *)[cell viewWithTag:3];
    if ([examModel.kszwh isEqualToString:@" "]) lblSeatIndex.text = @"座位号：待定";
    else lblSeatIndex.text = [NSString stringWithFormat:@"座位号：%@",examModel.kszwh];

    [cell prepareForTableView:tableView indexPath:indexPath];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150 + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
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
   // [self performSegueWithIdentifier:@"gotoDetail" sender:self];
    _selected = indexPath.row;
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    //send current view
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(set_exam:)]) {
        NSIndexPath *selectedRow = [self.tableView indexPathForCell:sender];
        [destination setValue:[[examsDataModel alloc] initWithJson:[_exams objectAtIndex:selectedRow.section]] forKey:@"_exam"];
    }
    _selected = 0;
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
    _exams = nil;
    _exams = [[[examQuerryController alloc] initWithDefaultUserOutline] getExamLists];
    _selected = 0;
    [self.tableView reloadData];
}

-(void)startToFreshFromServer{
    
    loadingView = [XYLoadingView loadingViewWithMessage:MSG_LOADING_EXAM_LIST];
    [loadingView show];
    [NSThread detachNewThreadSelector:@selector(freshingFromServer) toTarget:self withObject:nil];
}
-(void)freshingFromServer{
    if (reachable ==  NotReachable) {
        XYShowAlert(MSG_UNCONNECT);
        return;
    }
    [[[examQuerryController alloc] initWithDefaultUser] freshFromServer];
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
