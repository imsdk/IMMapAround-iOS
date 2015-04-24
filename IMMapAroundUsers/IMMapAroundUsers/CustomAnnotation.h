//
//  CustomAnnotation.h
//  IMMapAroundUsers
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotation : MKPointAnnotation

@property (nonatomic, copy) NSString *customUserID;

@end
