//
//  FFFaceRecognizer.h
//  FaceyFindy
//
//  Created by Duncan Smith on 4/20/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFaceRecognizer : NSObject

+ (FFFaceRecognizer *)lbphRecognizer;

- (int)predict:(UIImage*)img distance:(double *)distance;

- (void)updateWithFace:(UIImage *)img label:(int)label;

@end
