//
//  SxlCollectionViewCell.m
//  WeatherRequest
//
//  Created by sxl on 2017/1/20.
//  Copyright © 2017年 didi. All rights reserved.
//

#import "SxlCollectionViewCell.h"

@implementation SxlCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 70, 70)];
//        _topImage.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_topImage];
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_botlabel];
    }
    
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    _botlabel.textAlignment = NSTextAlignmentCenter;
    _botlabel.textColor = [UIColor blueColor];
    _botlabel.font = [UIFont systemFontOfSize:15];
    _botlabel.frame = CGRectMake(10, 80, 70, 30);
    
    
}

//- (void)awakeFromNib{
//    // Initialization code
//}

@end
