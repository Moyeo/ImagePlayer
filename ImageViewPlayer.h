//
//  ImageViewPlayer.h
//  ImagePlayer
//
//  Created by zhangpei on 14/12/5.
//  Copyright (c) 2014年 zhangpei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewPlayerDelegate <NSObject>

- (void)imageViewPlayerDidSelectedAtIndex:(NSInteger)index withImageInfo:(NSDictionary *)dictionary;

@end


@interface ImageViewPlayer : UIView

@property (nonatomic, assign) id <ImageViewPlayerDelegate>imageViewPlayerDelegate;

- (id)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array;

@end
