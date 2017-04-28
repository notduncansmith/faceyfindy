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

- (NSString *)predict:(UIImage*)img confidence:(double *)confidence;

- (NSArray *)updateWithFace:(UIImage *)img name:(NSString *)name;

- (NSArray *)labels;

@end
