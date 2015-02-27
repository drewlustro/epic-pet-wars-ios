/**
 * <?= $object_name ?>.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created <?= $date ?>.
 */

#import "<?= $object_name ?>.h"


@implementation <?= $object_name ?> 
@synthesize <?= lcfirst($object_name) ?>Id, <?= implode(', ', $camel_cased_fields) ?>;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [<?= $object_name ?> class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"set<?= $object_name?>Id:", @"id",
<? for ($i = 0; $i < count($fields); $i += 1): ?>
<? $camel_field = $camel_cased_fields[$i]; ?>
<? $field = $fields[$i]; ?>
                    @"set<?= ucwords($camel_field) ?>:", @"<?= $field ?>",
<? endfor; ?>
                    nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
    [<?= lcfirst($object_name) ?>Id release];
<? foreach ($camel_cased_fields as $field): ?>
    [<?= $field ?> release];
<? endforeach; ?>
    [super dealloc];
}


@end
