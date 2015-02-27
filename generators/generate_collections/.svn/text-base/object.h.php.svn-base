/**
 * <?= $object_name ?>.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created <?= $date ?>.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface <?= $object_name ?> : AbstractRestRequestedModel {
    NSString *<?= lcfirst($object_name) ?>Id;
<? foreach ($camel_cased_fields as $field): ?>
    NSString *<?= $field ?>;  
<? endforeach; ?>
}

@property (nonatomic, copy) NSString *<?= lcfirst($object_name) ?>Id;
<? foreach ($camel_cased_fields as $field): ?>
@property (nonatomic, copy) NSString *<?= $field ?>;
<? endforeach; ?>

@end
