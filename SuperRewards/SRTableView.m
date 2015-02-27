/*
 * Copyright 2009 Miraphonic
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SRTableView.h"


@implementation SRTableView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (int i = 0; i< [self.subviews count]; i++) {
        CGPoint convertedPoint = [self convertPoint:point toView:[self.subviews objectAtIndex:i]];
        
        UIView *subview = [[self.subviews objectAtIndex:i] hitTest:convertedPoint withEvent:event];
        if ([subview isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView *)subview;
        }
    }
    return [super hitTest:point withEvent:event];
}


@end
