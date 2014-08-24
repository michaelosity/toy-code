//
// MLYViewController
// Michael Wells
// michael@michaelosity.com
//

#import "MLYViewController.h"
#import "MLYFeedParser.h"
#import "MLYAppDelegate.h"
#import "MLYConstants.h"
#import "MLYFeedManager.h"

@interface MLYViewController ()

@property (nonatomic) NSArray *posts;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

static CGFloat kRowHeight = 175.0f;

@implementation MLYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _posts = [[NSMutableArray alloc] init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"EEEE, MMMM dd, YYYY 'at' h:mm a"];

    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self reload];

    // watch for feed update notifications and reload
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdated:) name:MLYNotifyFeedUpdate object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // unsubscribe from notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MLYNotifyFeedUpdate object:nil];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self reload];
}

#pragma mark - API

- (void)feedUpdated:(NSNotification *)notification
{
    NSLog(@"got notification to reload the ui");

    // NOTE: we serialize on the ui thread in reload
    [self reload];
}

- (void)reload
{
    NSString *filePath = [[MLYFeedManager sharedInstance] filePath];
    MLYFeedParser *parser = [[MLYFeedParser alloc] initWithFilePath:filePath callback:^(NSArray *posts)
    {
        self.posts = posts;
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView reloadData];
        });
    }];
    [parser parse];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const int kTitleLabelTag = 1;
    const int kDescriptionLabelTag = 2;
    const int kDateLabelTag = 3;

    const CGFloat kMargin = 8.0f;
    const CGFloat kTitleLabelHeight = 40.0f;
    const CGFloat kDateLabelHeight = 20.0f;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLYViewController"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MLYViewController"];

        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setNumberOfLines:0];
        [titleLabel setTag:kTitleLabelTag];
        [titleLabel setTextColor:[UIColor colorWithRed:0/255.0f green:166/255.0f blue:233/255.0f alpha:1.0f]];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]];
        [cell.contentView addSubview:titleLabel];

        UILabel *dateLabel = [[UILabel alloc] init];
        [dateLabel setTag:kDateLabelTag];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [dateLabel setTextColor:[UIColor darkGrayColor]];
        [cell.contentView addSubview:dateLabel];

        UILabel *descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setNumberOfLines:0];
        [descriptionLabel setTag:kDescriptionLabelTag];
        [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [cell.contentView addSubview:descriptionLabel];
    }

    NSDictionary *item = self.posts[(NSUInteger) indexPath.row];
    if (item)
    {
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:kTitleLabelTag];
        [titleLabel setText:item[MLYPostTitleTag]];
        [titleLabel setFrame:CGRectMake(
                kMargin,
                kMargin,
                CGRectGetWidth(cell.frame) - kMargin * 2,
                kTitleLabelHeight)];

        UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:kDescriptionLabelTag];
        [descriptionLabel setText:item[MLYPostDescriptionTag]];
        [descriptionLabel setFrame:CGRectMake(
                kMargin * 2.0f,
                titleLabel.frame.origin.y + CGRectGetHeight(titleLabel.frame) + kMargin,
                CGRectGetWidth(cell.frame) - kMargin * 3,
                kRowHeight - kTitleLabelHeight - kDateLabelHeight - kMargin * 3.0f)];

        NSDate *date = item[MLYPostDateTag];
        NSString *dateString = @"";
        if (date && ![date isEqual:[NSNull null]])
        {
            dateString = [self.dateFormatter stringFromDate:date];
        }

        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:kDateLabelTag];
        [dateLabel setText:dateString];
        [dateLabel setFrame:CGRectMake(
                kMargin,
                kRowHeight - kMargin - kDateLabelHeight,
                CGRectGetWidth(cell.frame) - kMargin * 2,
                kDateLabelHeight)];
    }

    return cell;
}

@end
