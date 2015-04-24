//
//  MapAroundUsersViewController.m
//  IMMapAroundUsers
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "MapAroundUsersViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "IMMyself+Around.h"
#import "IMUserLocation.h"
#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"
#import "UserInfoController.h"

@interface MapAroundUsersViewController()<MKMapViewDelegate ,IMAroundDelegate>

@end

@implementation MapAroundUsersViewController {
    MKMapView *_mapView;
    
    UIButton *_logoutBtn;
    UIButton *_updateBtn;
    UIButton *_nextBtn;
}

- (void)dealloc
{
    [g_pIMMyself setAroundDelegate:nil];
    
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView setDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, 40, 40)];
    
    [_logoutBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_logoutBtn setAlpha:0.5];
    [[_logoutBtn layer] setCornerRadius:20];
    
    [_logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[_logoutBtn titleLabel] setFont:[UIFont systemFontOfSize:13]];
    
    _updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 20, 40, 40)];
    
    [_updateBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_updateBtn setAlpha:0.5];
    [[_updateBtn layer] setCornerRadius:20];
    [_updateBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [_updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[_updateBtn titleLabel] setFont:[UIFont systemFontOfSize:13]];
    
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 20, 40, 40)];
    
    [_nextBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_nextBtn setAlpha:0.5];
    [[_nextBtn layer] setCornerRadius:20];
    [_nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[_nextBtn titleLabel] setFont:[UIFont systemFontOfSize:10]];
    
    [_logoutBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_updateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:YES];
    [[self view] addSubview:_mapView];
    
    [g_pIMMyself setAroundDelegate:self];
    [g_pIMMyself updateOnSuccess:^(NSArray *aroundUserLocationList) {
        NSLog(@"success");
    } failure:^(NSString *error) {
        NSLog(@"failed");
    }];
    
    [[self view] addSubview:_logoutBtn];
    [[self view] addSubview:_updateBtn];
    [[self view] addSubview:_nextBtn];
}

- (void)didUpdate:(NSArray *)aroundUserLocationList {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (IMUserLocation *location in aroundUserLocationList) {
       
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        annotation.title = location.customUserID;
        
        [_mapView addAnnotation:annotation];
        
        if ([[location customUserID] isEqualToString: [g_pIMMyself customUserID]]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
            // 显示尺寸span
            MKCoordinateSpan span = MKCoordinateSpanMake(0.04, 0.04);
            _mapView.region = MKCoordinateRegionMake(coordinate, span);
        }

    }
}

- (void)didNextPage:(NSArray *)aroundUserLocationList {
    for (IMUserLocation *location in aroundUserLocationList) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        annotation.title = location.customUserID;
        
        [_mapView addAnnotation:annotation];
        
        if ([[location customUserID] isEqualToString: [g_pIMMyself customUserID]]) {
            // 显示尺寸span
            MKCoordinateSpan span = MKCoordinateSpanMake(0.04, 0.04);
            _mapView.region = MKCoordinateRegionMake(coordinate, span);
            
        }
        
    }
}

- (void)nextPageFailedWithError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取地理位置失败" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

- (void)updateFailedWithError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取地理位置失败" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

- (void)buttonClick:(id)sender {
    if (sender == _logoutBtn) {
        [g_pIMMyself logout];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender == _updateBtn) {
        [g_pIMMyself update];
    } else if (sender == _nextBtn) {
        [g_pIMMyself nextPage];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    CustomAnnotationView *annView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"imsdk.im"];
    if (annView == NULL) {
        annView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"imsdk.im"] ;
        
    }
    
    [annView setCustomUserID:[annotation title]];
    
    return annView;
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [_mapView selectAnnotation:[(CustomAnnotationView *)sender.view annotation] animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [_mapView deselectAnnotation:view.annotation animated:YES];
    
    UserInfoController *controller = [[UserInfoController alloc] init];
    
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *)view;
        
        [controller setCustomUserID:[annotationView customUserID]];
    }
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [navi setTitle:@"个人资料"];
    
    [self presentViewController:navi animated:YES completion:nil];
}


@end
