//
//  OpenCVWrapper.mm
//  FaceyFindy
//
//  Created by Duncan Smith on 4/20/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

#import <opencv2/opencv.hpp>

#import "FFFaceRecognizer.h"
#import "UIImage+OpenCV.h"

//using namespace std;
using namespace cv;

@interface FFFaceRecognizer () {
    Ptr<FaceRecognizer> _faceClassifier;
}

@end

@implementation FFFaceRecognizer

+ (FFFaceRecognizer *)lbphRecognizer {
    FFFaceRecognizer *fr = [FFFaceRecognizer new];
    
    fr->_faceClassifier = createLBPHFaceRecognizer();
  
    return fr;
}


- (int)predict:(UIImage *)img distance:(double *)distance {
    
    cv::Mat src = [img cvMatRepresentationGray];
    int label;
  
    self->_faceClassifier->predict(src, label, *distance);
    
    return label;
}

- (void)updateWithFace:(UIImage *)img label:(int)label {
    cv::Mat src = [img cvMatRepresentationGray];
  
    vector<cv::Mat> images = vector<cv::Mat>();
    images.push_back(src);
    vector<int> labels = vector<int>();
    labels.push_back(label);
    
    self->_faceClassifier->update(images, labels);
}
@end
