//
//  schoolBusQuerryViewController.m
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "schoolBusQuerryViewController.h"

@interface schoolBusQuerryViewController (){
    NIDropDown *dropStart,*dropEnd;
    NSArray *_busArr;
    NSMutableArray *_campusArr;
    enum schoolCampus _start,_end;
    XYLoadingView *loadingView;
}

@end

@implementation schoolBusQuerryViewController
@synthesize btnSelectEnd,btnSelectStart,busTableView;
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
    btnSelectStart.layer.cornerRadius = 5;
    //btnSelectStart.layer.borderWidth = 1;
    //btnSelectStart.layer.borderColor = [[UIColor blackColor] CGColor];
    btnSelectEnd.layer.cornerRadius = 5;
    //btnSelectEnd.layer.borderWidth = 1;
    //btnSelectEnd.layer.borderColor = [[UIColor blackColor] CGColor];
    if (!_campusArr) {
         _campusArr = [NSMutableArray array];
    }
    
    for (int i =0; i < 5; i++) {
        enum schoolCampus campus = (enum schoolCampus)i;
        switch (campus) {
            case ZiJinGangCampus:
                [_campusArr addObject:@"紫金港校区"];
                break;
            case YuQuanCampus:
                [_campusArr addObject:@"玉泉校区"];
                break;
            case XiXICampus:
                [_campusArr addObject:@"西溪校区"];
                break;
            case ZhiJiangCampus:
                [_campusArr addObject:@"之江校区"];
                break;
            case HuaJiaChiCampus:
                [_campusArr addObject:@"华家池校区"];
                break;
            default:
                break;
        }
    }
    _start = (enum schoolCampus)[[NSUserDefaults standardUserDefaults] integerForKey:@"school_bus_start"];
    _end = (enum schoolCampus)[[NSUserDefaults standardUserDefaults] integerForKey:@"school_bus_end"];
    if (_start == _end) {
        _start = ZiJinGangCampus;
        _end = YuQuanCampus;
    }
    [btnSelectStart setTitle:[_campusArr objectAtIndex:_start] forState:UIControlStateNormal];
    [btnSelectEnd setTitle:[_campusArr objectAtIndex:_end] forState:UIControlStateNormal];
    
    if (!_busArr) {
        _busArr = [[publicInfoController new] getSchoolBusListFrom:_start to:_end];
        if ([_busArr count] == 0) {
            [self startToFreshFromServer];
        }
    }
    }
- (void)viewDidAppear:(BOOL)animated{
    
}
- (void)viewDidDisappear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnSelectStart:nil];
    [self setBtnSelectEnd:nil];
    [super viewDidUnload];
}
#pragma mark niDropDownDelegate
-(void)niDropDownDelegateMethod:(NIDropDown *)sender{
    if ([sender isEqual:dropStart]) {
        _start = sender.selectedRow;
    }
    if ([sender isEqual:dropEnd]) {
        _end = sender.selectedRow;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:_start forKey:@"school_bus_start"];
    [[NSUserDefaults standardUserDefaults] setInteger:_end forKey:@"school_bus_end"];
    [self fresh];
}
- (IBAction)pressSelectBtn:(id)sender {
    if (![sender isKindOfClass:[UIButton class]]) return;
    UIButton *lblSender = (UIButton *)sender;
    
    if (lblSender.tag == 1) {
        if (!dropStart) {
            dropStart = [[NIDropDown alloc]init];
            dropStart.delegate = self;
            CGFloat f = 200;
            [dropStart showDropDown:sender height:&f names:_campusArr];
        }
        else if(!dropStart.isDropped) {
            CGFloat f = 200;
            [dropStart showDropDown:sender height:&f names:_campusArr];            
        }
        else {
            [dropStart hideDropDown:sender];
        }
    }
    else{
        if (!dropEnd) {
            dropEnd = [[NIDropDown alloc]init];
            dropEnd.delegate = self;
            CGFloat f = 200;
            [dropEnd showDropDown:sender height:&f names:_campusArr];
        }
        else if(!dropEnd.isDropped) {
            CGFloat f = 200;
            [dropEnd showDropDown:sender height:&f names:_campusArr];
        }
        else {
            [dropEnd hideDropDown:sender];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_busArr count] == 0 ? 1:[_busArr count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0 && [_busArr count] != 0) {
       return  @"可用校车";
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if ([_busArr count] == 0) {
        return @"当前木有可用校车";
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_busArr count] == 0 ? 0:1;
}

- (PrettyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"xiaoche";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    schoolBusDataModel *dataModel = [[schoolBusDataModel alloc] initWithLocalJson:[_busArr objectAtIndex:indexPath.section]];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"H:mm";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    
    UILabel *lblStartTime = (UILabel *)[cell viewWithTag:1];
    lblStartTime.text = [formatter stringFromDate:dataModel.fcsj];
    
    UILabel *lblch = (UILabel *)[cell viewWithTag:2];
    lblch.text = dataModel.ch;
    
    // Configure the cell...
    cell.tableViewBackgroundColor = tableView.backgroundColor;
    //cell.gradientStartColor = [UIColor colorWithHex:0xEEEEEE];
    //cell.gradientEndColor = [UIColor colorWithHex:0xDEDEDE];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if ([destination respondsToSelector:@selector(set_schoolBus:)]) {
        NSIndexPath *selectedRow = [busTableView indexPathForCell:sender];
        [destination setValue:[[schoolBusDataModel alloc] initWithLocalJson:[_busArr objectAtIndex:selectedRow.section]] forKey:@"_schoolBus"];
    }
    
}

- (IBAction)btnFresh:(id)sender {
    [self startToFreshFromServer];
}

-(void)fresh{
    _busArr = nil;
    _busArr = [[publicInfoController new] getSchoolBusListFrom:_start to:_end];
    [busTableView reloadData];
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
    [[publicInfoController new] freshFromServer:FRESH_XIAOCHE];
    [self performSelectorOnMainThread:@selector(endFreshing) withObject:nil waitUntilDone:NO];
}
-(void)endFreshing{
    if (loadingView.isLoading) {
        [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:0.2f];
    }
    
    [self fresh];
}

@end
