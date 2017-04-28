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

@property (nonatomic, strong) NSMutableDictionary *labelsDictionary;

@end

@implementation FFFaceRecognizer

+ (FFFaceRecognizer *)lbphRecognizer {
    FFFaceRecognizer *fr = [FFFaceRecognizer new];
    
    fr->_faceClassifier = createLBPHFaceRecognizer();
  
    return fr;
}


- (NSString *)predict:(UIImage*)img confidence:(double *)confidence {
    
    cv::Mat src = [img cvMatRepresentationGray];
    int label;
  
    self->_faceClassifier->predict(src, label, *confidence);
    
    return _labelsDictionary[@(label)];
}

- (NSArray *)updateWithFace:(UIImage *)img name:(NSString *)name {
    cv::Mat src = [img cvMatRepresentationGray];
    
    NSSet *keys = [_labelsDictionary keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return ([name isEqual:obj]);
    }];
    
    NSInteger label;
    
    if (keys.count) {
        label = [[keys anyObject] integerValue];
    }
    else {
        label = _labelsDictionary.allKeys.count;
        _labelsDictionary[@(label)] = name;
    }
    
    vector<cv::Mat> images = vector<cv::Mat>();
    images.push_back(src);
    vector<int> labels = vector<int>();
    labels.push_back((int)label);
    
    self->_faceClassifier->update(images, labels);
    
    return [self labels];
}

- (NSArray *)labels {
    cv::Mat labels = _faceClassifier->getMat("labels");
    
    if (labels.total() == 0) {
        return @[];
    }
    else {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (MatConstIterator_<int> itr = labels.begin<int>(); itr != labels.end<int>(); ++itr ) {
            int lbl = *itr;
            [mutableArray addObject:@(lbl)];
        }
        return [NSArray arrayWithArray:mutableArray];
    }
}
@end
