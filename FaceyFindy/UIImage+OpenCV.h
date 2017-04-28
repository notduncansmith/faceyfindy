//
//  UIImage+OpenCV.h
//  FaceyFindy
//
//  Created by Duncan Smith on 4/21/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>


@interface UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)mat;

- (cv::Mat)cvMatRepresentationColor;
- (cv::Mat)cvMatRepresentationGray;

@end
