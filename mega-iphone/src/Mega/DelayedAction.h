#import "Mega/MegaGlobal.h"
/**
 * DelayedAction is a private class that holds a selector
 * and a target object so they can be stored with the key
 * that they are requesting
 */
@interface DelayedAction : NSObject {
    SEL selector, failedSelector;
    id target;
}
@property (assign) SEL selector;
@property (assign) SEL failedSelector;
@property (assign) id target;

@end