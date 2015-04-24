//
//  CustomAnnotationView.m
//  IMMapAroundUsers
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "IMSDK+MainPhoto.h"

@implementation CustomAnnotationView {
    UIImageView *_imageView;
}

- (id)initWithAnnotation:(id)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //大头针的图片
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        [_imageView setImage:[UIImage imageNamed:@"IM_head_default"]];
        [[_imageView layer] setCornerRadius:20.0f];
        [_imageView setClipsToBounds:YES];
        [self addSubview:_imageView];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 40, 40)];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [gesture setDelegate:self];
        [_imageView addGestureRecognizer:gesture];
    }
    
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    
}

- (void)setCustomUserID:(NSString *)customUserID {
    _customUserID = customUserID;
    
    if ([g_pIMSDK mainPhotoOfUser:customUserID]) {
        [_imageView setImage:[g_pIMSDK mainPhotoOfUser:customUserID]];
    } else {
        [_imageView setImage:[UIImage imageNamed:@"IM_head_default"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"IMReloadMainPhotoNotification" object:nil];
}

- (void)reloadData:(NSNotification *)note {
    if ([note.object isEqualToString:_customUserID]) {
        if ([g_pIMSDK mainPhotoOfUser:_customUserID]) {
            [_imageView setImage:[g_pIMSDK mainPhotoOfUser:_customUserID]];
        } else {
            [_imageView setImage:[UIImage imageNamed:@"IM_head_default"]];
        }
    }
}

@end
