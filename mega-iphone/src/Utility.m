//
//  Utility.m
//  miraphonic
//
//  Created by Amit Matani on 9/11/08.
//  Copyright 2008 Miraphonic. All rights reserved.
//

#import "Mega/MegaGlobal.h"
#import <CommonCrypto/CommonDigest.h>
#import <SBJson.h>
#define TAKE_CAMERA_PHOTO_TITLE @"Take Photo"
#define CHOOSE_EXISTING_PHOTO_TITLE @"Choose Existing Photo"

@implementation Utility

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
        ];
}

/*
+ (NSString *)convertToNSString:(id *)mixed {	
	if ([id isSubclassOfClass:[NSDecimalNumber
}
 */

+ (UIActionSheet *)generateCameraChooserActionSheetWithTitle:(NSString *)title delegate:(id)delegate {
	// open a dialog with just an OK button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
									delegate:delegate cancelButtonTitle:nil 
									destructiveButtonTitle:nil
									otherButtonTitles:nil];
    int cancelIndex = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:TAKE_CAMERA_PHOTO_TITLE];
        cancelIndex += 1;
    } 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [actionSheet addButtonWithTitle:CHOOSE_EXISTING_PHOTO_TITLE];
        cancelIndex += 1;
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = cancelIndex;
    
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    return actionSheet;
}

+ (UIImagePickerController *)generateImagePickerWithActionSheet:(UIActionSheet*)actionSheet 
                             clickedButtonAtIndex:(NSInteger)buttonIndex
                             delegate:(id)delegate {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = delegate;    
    if ([title isEqualToString:TAKE_CAMERA_PHOTO_TITLE] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([title isEqualToString:CHOOSE_EXISTING_PHOTO_TITLE] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;                   
    } else {
        [imagePicker release];
        imagePicker = nil;
    }
    return imagePicker;
}

+ (BOOL)isNumber:(NSNumber *)number sameAsInt:(NSInteger)integer {
    NSNumber *otherNumber = [[NSNumber alloc] initWithInteger:integer];
    BOOL areSame = [number compare:otherNumber] == NSOrderedSame;
    [otherNumber release];
    return areSame;
}


+ (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 480; // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }

        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;

    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize. height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize. width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }

    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }

    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageCopy;
}

+ (void)displayWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
       cancelButtonTitle:(NSString *)cancelButtonTitle 
       otherButtonTitles:(NSString *)otherButtonTitle {
    UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:title message:message 
                                  delegate:delegate cancelButtonTitle:cancelButtonTitle 
                         otherButtonTitles:otherButtonTitle, nil];
    [alertView show];
    [alertView release];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self displayWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];    
}

+ (NSString *)getUDID {
	return @"7f91bdb3e05db187349d2abc95241aa1d08dcfb6";
	//return @"testtesttesttesttesttesttesttesttest0001";
    return [[UIDevice currentDevice] uniqueIdentifier];
}

+ (void)internetConnectionFailed {
    UIImageView *internetConnectionRequired = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash_fullscreen_connection_required.png"]];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:internetConnectionRequired];
    [internetConnectionRequired release];
}

+ (BOOL)isStringTrue:(NSString *)response {
    return (id)response != [NSNull null] && [response isEqualToString:@"1"];
}

+ (NSString *)stringIfNotEmpty:(NSString *)string {
    if ((id)string != [NSNull null] && string != nil && ![string isEqualToString:@""]) {
        return string;
    }
    return nil;
}

+ (NSDictionary *)decodeJSON:(NSString *)jsonString {
    SBJsonParser *json = [SBJsonParser new];
    NSError *error;
	id parsedJsonResponse = [json objectWithString:jsonString error:&error];
	// TODO make this more robust
	if (![parsedJsonResponse isKindOfClass:[NSDictionary class]]) {
        debug_NSLog(@"ERROR - SHOULD NOT BE AN ARRAY");
        [json release];
        [jsonString release];
        [parsedJsonResponse release];
		return nil;
	} else if (parsedJsonResponse == nil && error != NULL) {
        debug_NSLog(@"ERROR - PARSING ERROR");
        [json release];
        [jsonString release];        
        [parsedJsonResponse release];        
		return nil;
	}
    debug_NSLog(@"parsed");
    [json release];
	return parsedJsonResponse;
}

@end