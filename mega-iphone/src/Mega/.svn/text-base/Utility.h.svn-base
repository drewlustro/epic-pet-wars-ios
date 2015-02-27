/*
 *  MegaGlobal.h
 *  mega framework
 *
 *  Created by Amit Matani on 4/19/09.
 *  Copyright 2009 Miraphonic, Inc. All rights reserved.
 *
 */

#import "Mega/MegaGlobal.h"

@interface Utility : NSObject {

}

+ (NSString *)md5:(NSString *)str;
+ (UIActionSheet *)generateCameraChooserActionSheetWithTitle:(NSString *)title delegate:(id)delegate;
+ (UIImagePickerController *)generateImagePickerWithActionSheet:(UIActionSheet*)actionSheet 
                             clickedButtonAtIndex:(NSInteger)buttonIndex
                             delegate:(id)delegate;
+ (BOOL)isNumber:(NSNumber *)number sameAsInt:(NSInteger)otherNumber;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (void)displayWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
       cancelButtonTitle:(NSString *)cancelButtonTitle 
       otherButtonTitles:(NSString *)otherButtonTitles;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;

+ (NSString *)getUDID;
+ (void)internetConnectionFailed;
+ (BOOL)isStringTrue:(NSString *)response;
+ (NSString *)stringIfNotEmpty:(NSString *)string;
+ (NSDictionary *)decodeJSON:(NSString *)jsonString;
	
@end

#define WEBCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
								green:((c>>16)&0xFF)/255.0 \
								blue:((c>>8)&0xFF)/255.0 \
								alpha:((c)&0xFF)/255.0]

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0];


