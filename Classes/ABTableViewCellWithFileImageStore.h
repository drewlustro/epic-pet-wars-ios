/**
 * ABTableViewCellWithFileImageStore.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */


#import <UIKit/UIKit.h>
#import "ABTableViewCellWithSingleRemoteImage.h"

@interface ABTableViewCellWithFileImageStore : ABTableViewCellWithSingleRemoteImage {

}

- (void)loadImageWithUrl:(NSString *)url;

@end
