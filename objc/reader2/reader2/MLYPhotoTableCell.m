//
//  MLYPhotoTableCell
//  Michael Wells
//  michael@michaelosity.com
//

#import "MLYPhotoTableCell.h"
#import "MLYPhoto.h"

@implementation MLYPhotoTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        const CGFloat padding = 10.0f;

        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_photoImageView setBackgroundColor:[UIColor darkGrayColor]];
        [_photoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_photoImageView];

        _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_userImageView setBackgroundColor:[UIColor darkGrayColor]];
        [_userImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_userImageView];

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userNameLabel setNumberOfLines:0];
        [_userNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_userNameLabel];

        // todo: some of these would simplify by using VLM

        // -- photo constraints

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                attribute:NSLayoutAttributeWidth
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                toItem:nil
                attribute:NSLayoutAttributeNotAnAttribute
                multiplier:1.0f
                constant:200.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                attribute:NSLayoutAttributeWidth
                relatedBy:NSLayoutRelationLessThanOrEqual
                toItem:nil
                attribute:NSLayoutAttributeNotAnAttribute
                multiplier:1.0f
                constant:300.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                attribute:NSLayoutAttributeHeight
                relatedBy:NSLayoutRelationEqual
                toItem:_photoImageView
                attribute:NSLayoutAttributeWidth
                multiplier:1.0f
                constant:0.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                attribute:NSLayoutAttributeLeft
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                toItem:self.contentView
                attribute:NSLayoutAttributeLeft
                multiplier:1.0f
                constant:padding]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImageView
                attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual
                toItem:self.contentView
                attribute:NSLayoutAttributeTop
                multiplier:1.0f
                constant:padding]];

        // -- user profile image constraints

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView
                attribute:NSLayoutAttributeWidth
                relatedBy:NSLayoutRelationEqual
                toItem:nil
                attribute:NSLayoutAttributeNotAnAttribute
                multiplier:1.0f
                constant:50.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView
                attribute:NSLayoutAttributeHeight
                relatedBy:NSLayoutRelationEqual
                toItem:nil
                attribute:NSLayoutAttributeNotAnAttribute
                multiplier:1.0f
                constant:50.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView
                attribute:NSLayoutAttributeBottom
                relatedBy:NSLayoutRelationEqual
                toItem:_photoImageView
                attribute:NSLayoutAttributeBottom
                multiplier:1.0f
                constant:50.0f + padding]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userImageView
                attribute:NSLayoutAttributeLeft
                relatedBy:NSLayoutRelationEqual
                toItem:self.contentView
                attribute:NSLayoutAttributeLeft
                multiplier:1.0f
                constant:padding]];

        // -- user name label constraints

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual
                toItem:self.userImageView
                attribute:NSLayoutAttributeTop
                multiplier:1.0f
                constant:0.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                attribute:NSLayoutAttributeBottom
                relatedBy:NSLayoutRelationEqual
                toItem:self.userImageView
                attribute:NSLayoutAttributeBottom
                multiplier:1.0f
                constant:0.0f]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                attribute:NSLayoutAttributeLeft
                relatedBy:NSLayoutRelationEqual
                toItem:self.userImageView
                attribute:NSLayoutAttributeRight
                multiplier:1.0f
                constant:padding]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                attribute:NSLayoutAttributeRight
                relatedBy:NSLayoutRelationLessThanOrEqual
                toItem:self.contentView
                attribute:NSLayoutAttributeRight
                multiplier:1.0f
                constant:padding]];

    }

    return self;
}

- (void)updateWithPhoto:(MLYPhoto *)photo
{
    if (!photo)
    {
        return;
    }

    [self.userNameLabel setText:photo.userName];
    [self.photoImageView setImage:nil];
    [self.userImageView setImage:nil];

    [photo loadPhotoImage:^(UIImage *image)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.photoImageView setImage:image];
        });
    }];

    [photo loadProfileImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userImageView setImage:image];
        });
    }];
}

@end