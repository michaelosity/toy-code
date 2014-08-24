//
//  MLYPhotoTableCell
//  Michael Wells
//  michael@michaelosity.com
//

#import <Foundation/Foundation.h>

@class MLYPhoto;

@interface MLYPhotoTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;

- (void)updateWithPhoto:(MLYPhoto *)photo;

@end