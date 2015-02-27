/**
 * OwnedItemTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "OwnedItemTableViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "OwnedItemTableViewCell.h"
#import "OwnedEquipmentSet.h"
#import "ItemRemoteCollection.h"
#import "BRRestClient.h"

@implementation OwnedItemTableViewController

- (id)init {
    EquipmentSet *equipment = [[[BRSession sharedManager] protagonistAnimal] equipment];
    if (self = [super initWithEquipmentSet:equipment withInitialSource:[equipment useable]]) {

    }
    return self;
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[OwnedItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (NSString *)noneAvailableString {
    return [NSString stringWithFormat:@"You do not have any %@ items yet.  Go to the Item Shop to purchase some!", 
            ((ItemRemoteCollection *)dataSource).category];
}

- (void)dealloc {
    [super dealloc];
}



@end
