//
//  MLYViewController
//  Michael Wells
//  michael@michaelosity.com
//

#import "MLYViewController.h"
#import "MLYFeedManager.h"
#import "MLYPhoto.h"
#import "MLYPhotoTableCell.h"

@interface MLYViewController ()

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MLYViewController

static const CGFloat kRowHeight = 375.0f;

static NSString *kCellIdentifier = @"MLYPhotoTableCell";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0f green:166/255.0f blue:233/255.0f alpha:1.0f]];

    self.photos = [[NSArray alloc] init];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView registerClass:[MLYPhotoTableCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:self.tableView];

    [self.view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|[_tableView]|"
            options:NSLayoutFormatDirectionLeadingToTrailing
            metrics:nil
            views:NSDictionaryOfVariableBindings(_tableView)]];

    [self.view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-[_tableView]|"
            options:NSLayoutFormatDirectionLeadingToTrailing
            metrics:nil
            views:NSDictionaryOfVariableBindings(_tableView)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^
    {
        [[MLYFeedManager sharedInstance] downloadFeed:^(NSArray *photos, NSError *error) {
            self.photos = photos;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLYPhotoTableCell *cell = (MLYPhotoTableCell *) [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    MLYPhoto *photo = self.photos[(NSUInteger) indexPath.row];

    [cell updateWithPhoto:photo];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

@end
