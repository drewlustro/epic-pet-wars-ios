/**
 * InviteContactsViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/8/09.
 */

#import "InviteContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "Consts.h"
#import "CheckableContactTableViewCell.h"
#import "BRAppDelegate.h"
#import "Notifier.h"
#import "BRRestClient.h"
#import "Contact.h"
#import "Utility.h"
#import "ActionResult.h"
#import "BRSession.h"
#import "ItemReceivedViewController.h"
#import "Animal.h"
#import "ResizeableViewWithAnchoredBottom.h"

@implementation InviteContactsViewController
@synthesize myTableView;

static NSArray *alphabet;

#define NAME_FIELD 13

+ (void)initialize {
	if (self = [InviteContactsViewController class]) {
		alphabet = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", 
													@"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", 
													@"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", 
													@"Y", @"Z", nil];
	}
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super init]) {
		ABAddressBookRef addressBook = ABAddressBookCreate(); 
		CFArrayRef people            = ABAddressBookCopyArrayOfAllPeople(addressBook);
		
		
		int total = CFArrayGetCount(people);		
/*		CFMutableArrayRef people = CFArrayCreateMutableCopy( 
					   kCFAllocatorDefault, 
					   total, 
					   unsortedPeople 
					   ); */
//        [people sortUsingFunction:ABPersonComparePeopleByName context:ABPersonSortOrdering];
//        ABPersonSortOrdering sortOrdering = ABPersonGetSortOrdering();         
//        [people sortUsingFunction:ABPersonComparePeopleByName context:(void *)sortOrdering];
        
		contacts = [[NSMutableArray alloc] initWithCapacity:100];
		numSections = 0;
		numChecked = 0;
        BOOL sortByFirstName = ABPersonGetSortOrdering() == kABPersonSortByFirstName;
		
		// prune out the bad stuff and put everything in a contacts array
		for (int i = 0; i < total; i += 1) {
			ABRecordRef record = (ABRecordRef)CFArrayGetValueAtIndex(people, i);
			record = CFRetain(record);	
			
			ABMultiValueRef emailMulti = ABRecordCopyValue(record, kABPersonEmailProperty);
			Contact *contact = [[Contact alloc] init];
            contact.sortByFirstName = sortByFirstName;
			if (emailMulti != nil) {
				if (ABMultiValueGetCount(emailMulti) > 0) {
					CFStringRef email = ABMultiValueCopyValueAtIndex(emailMulti, 0);
					contact.email = (NSString *)email;
					CFRelease(email);
				}
				CFRelease(emailMulti);
			}

			if (contact.email !=  nil || contact.phoneNumber != nil) {
				CFStringRef firstName  = ABRecordCopyValue(record, kABPersonFirstNameProperty);				
				CFStringRef lastName  = ABRecordCopyValue(record, kABPersonLastNameProperty);
				if (firstName != nil || lastName != nil) {
					contact.firstName = (NSString *)firstName;
					contact.lastName = (NSString *)lastName;
					[contacts addObject:contact];
					if (firstName != nil) {
						CFRelease(firstName);
					}
					if (lastName != nil) {
						CFRelease(lastName);
					}
				}
			}
			CFRelease(record);
			[contact release];
		}
        
        CFRelease(people);         
		CFRelease(addressBook);
        
        [contacts sortUsingSelector:@selector(compareContact:)];
        
//		[self setupOffsets];

        //CFRelease(people);

    }

    return self;
}
/*
- (void)setupOffsets {
	offsets = (int *)malloc(26 * sizeof(int));
	for (int i = 0; i < 27; i += 1) {
		offsets[i] = 0;
	}
	
	
	int j = 1, total = [contacts count];
	unichar firstChar = 'a';
	unichar firstCharCap = firstChar - 32;
	
    
	for (int i = 0; i < total; i += 1) {
		Contact *contact = (Contact *) [contacts objectAtIndex:i];
		NSString *orderedWith;
		ABPersonSortOrdering order = ABPersonGetSortOrdering();
		if (order == kABPersonSortByFirstName) {
			if (contact.firstName == nil) {
				orderedWith = contact.lastName;
			} else {
				orderedWith = contact.firstName;					
			}
		} else {
			if (contact.lastName == nil) {
				orderedWith = contact.firstName;					
			} else {
				orderedWith = contact.lastName;
			}
		}
		
		unichar startsWith = [orderedWith characterAtIndex:0];
		
		if (startsWith != firstChar && startsWith != firstCharCap) {
			int count = startsWith - (startsWith == firstChar ? firstChar : firstCharCap);
			for (int r = j; r < j + count && r <= 26; r += 1) {
				offsets[r] = i;
			}
			j += count;
			firstChar += count;
			firstCharCap += count;
			numSections += 1;
		}
	}
	if (j < 26 && j > 0) {
		while (j < 26) {
			offsets[j] = total;
			j += 1;
		}
	}
	for (int i = 0; i < 26; i += 1) {
		debug_NSLog(@"offset %d", offsets[i]);
	}
	offsets[26] = total;
}*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	ResizeableViewWithAnchoredBottom *view = [[ResizeableViewWithAnchoredBottom alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = view;	
	debug_NSLog(@"loading the ardtwthc");
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
														  style:UITableViewStylePlain];
	myTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	self.myTableView = tableView;
	[tableView release];
	
	myTableView.rowHeight = 70;
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.sectionIndexMinimumDisplayRowCount = 0;
	
	debug_NSLog(@"frame height %f", self.view.frame.size.height);
	myTableView.frame = CGRectMake(0, 0, FRAME_WIDTH, 260);
	view.resizeableView = myTableView;

#define PADDING 10
#define BUTTON_FONT_SIZE 14
	UIColor *shadowColor = WEBCOLOR(0x264700FF);
	sendButton = [[UIButton alloc] init];
	int y = myTableView.frame.origin.y + myTableView.frame.size.height + PADDING;
	sendButton.titleShadowOffset = CGSizeMake(0, -1);
	sendButton.font = [UIFont boldSystemFontOfSize: BUTTON_FONT_SIZE];
	[sendButton setFrame:CGRectMake(20, y,	280, 46)];
	[sendButton setTitle:@"Send Invites" forState:UIControlStateNormal];
	[sendButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[sendButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[sendButton setBackgroundImage:[UIImage imageNamed:@"new_account_button.png"] forState:UIControlStateNormal];
	[sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	sendButton.enabled = NO;
	view.anchoredView = sendButton;
	
	self.title = @"Invite Contacts";
	[view release];
    [self performSelector:@selector(getHeader) withObject:nil afterDelay:0];
}

- (void)getHeader {
	loadHeaderOperation = [[[BRRestClient sharedManager] callRemoteMethod:@"posse.getEmailContactsHeader" params:nil nonRetainedDelegate:self] retain];	
}


- (void)sendEmails {
	NSMutableArray *selectedContacts = [[NSMutableArray alloc] initWithCapacity:numChecked];
	for (Contact *contact in contacts) {
		if (contact.checked) {
			[selectedContacts addObject:contact];
		}
	}
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Sending"];
	[[BRRestClient sharedManager] posse_sendInvites:selectedContacts name:_name target:self 
                                   finishedSelector:@selector(finishedSendingInvites:parsedResponse:) 
                                     failedSelector:@selector(failedSendingInvites)];
	[selectedContacts release];    
}

- (void)sendButtonClicked {
    // THIS IS SUPER UGLY, find a cleaner way
    if (!_name) {
        UIAlertView *noNameAlert = 
        [[UIAlertView alloc] initWithTitle:@"Name" 
                                   message:@"Please enter your real name.  This name will appear in the invites.\n\n\n" 
                                  delegate:self cancelButtonTitle:@"Done"
                                otherButtonTitles:nil];
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(14, 100, 255, 30)];
        nameField.borderStyle = UITextBorderStyleBezel;
        nameField.textColor = [UIColor blackColor];
        nameField.font = [UIFont systemFontOfSize:16];
        
        nameField.backgroundColor = [UIColor whiteColor];
        nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        nameField.keyboardType = UIKeyboardTypeEmailAddress;
        nameField.keyboardAppearance = UIKeyboardAppearanceAlert;
        nameField.delegate = self;
        nameField.tag = NAME_FIELD;
        [nameField becomeFirstResponder];
        
        [noNameAlert addSubview:nameField];
        
        [noNameAlert show];
        [noNameAlert release];
        [nameField release];
    } else {
        [self sendEmails];
    }
}

- (void)finishedSendingInvites:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
		
		if (![Utility stringIfNotEmpty:actionResult.popupHTML]) {
			if (actionResult.item) {
				ItemReceivedViewController *irvc = [[ItemReceivedViewController alloc] initWithItem:actionResult.item];
				[self presentModalViewController:irvc animated:YES];
				[irvc release];
			} else {
				[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
													  withWidth:[actionResult.formattedResponseWidth floatValue]
													  andHeight:[actionResult.formattedResponseHeight floatValue]];
			}
		}
		
		
		for (Contact *contact in contacts) {
			contact.checked = NO;
		}
		numChecked = 0;
		sendButton.enabled = NO;
		[myTableView reloadData];
	} else {
		[self failedSendingInvites];
	}
}

- (void)failedSendingInvites {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
}

#pragma mark table associated methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return fmin(26, numSections);
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//	return alphabet;
//}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	int index = [self sectionToIndex:section];
	char letter = (index + 65);
    return [NSString stringWithFormat:@"%c", letter];
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contacts count];
//	int index = [self sectionToIndex:section];		
//    debug_NSLog(@"section: %d, %d", index, offsets[index + 1] - offsets[index]);
//	return offsets[index + 1] - offsets[index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [self tableviewCellWithReuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

/**
 * tableviewCellWithReuseIdentifier: returns a cell based on an identifier.
 * By default it will just use a normal cell, but when subclassed out
 * the implementing class can return custom UITableViewCell objects
 * based on the identifier
 * @param NSString *identifier - the identifier string
 * @return UITableViewCell * - the cell
 */
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[CheckableContactTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:identifier] autorelease];
}

/**
 * configureCell:forIndexPath configures the cell at the indexPath.
 * This should be subclassed out
 * @param UITableViewCell *cell - the cell to configure
 * @param NSIndexPath *indexPath - the index path that the cell will be located at
 */
- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    CheckableContactTableViewCell *cell = (CheckableContactTableViewCell *)_cell;
	
	//int index = offsets[[self sectionToIndex:indexPath.section]] + indexPath.row;
	Contact *contact = (Contact *)[contacts objectAtIndex:indexPath.row];

	cell.contact = contact;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CheckableContactTableViewCell *cell = (CheckableContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	cell.contact.checked = !cell.contact.checked;
	
//	int index = offsets[[self sectionToIndex:indexPath.section]] + indexPath.row;
//	Contact *contact = (Contact *)[contacts objectAtIndex:index];
//	Contact *contact = (Contact *)[contacts objectAtIndex:indexPath.row];    
//	contact.checked = cell.checked;
	numChecked += cell.contact.checked ? 1 : -1;
	sendButton.enabled = numChecked > 0;
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellAccessoryDisclosureIndicator;
//}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (UITableViewStyle)tableViewStyle {
	return UITableViewStylePlain;
}
/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return [self indexToSection:index];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
/*
- (int)sectionToIndex:(int)section {
	int i = -1;
	for (int j = 1; j <= 26; j += 1) {
		if (offsets[j] != offsets[j - 1]) {
			i += 1;
			if (i == section) {
				return j - 1;
			}
		}
	}
	return 0;
}

- (int)indexToSection:(int)index {
	if (offsets[index] != offsets[index + 1]) {
		return index;
	} else {
		index -= 1;
		while (index >= 0) {
			if (offsets[index] != offsets[index + 1]) {
				return index;
			}
			index -= 1;
		}
		return 0;
	}
}
*/
#pragma mark UIAlertViewDelegate methods
- (void)willPresentAlertView:(UIAlertView *)alertView {
    alertView.frame = CGRectMake(alertView.frame.origin.x, 50, alertView.frame.size.width, alertView.frame.size.height);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UITextField *nameField = (UITextField *)[alertView viewWithTag:NAME_FIELD];
    if (nameField) {
        [_name release];
        _name = [nameField.text copy];
        
        [self sendEmails];
    }
}


- (void)dealloc {
//	free(offsets);
	[contacts release];
    [sendButton release];
	[myTableView release];
    [_name release];
	[loadHeaderOperation cancel];
	[loadHeaderOperation release];
    [super dealloc];
}

#pragma mark RestResponseDelegate


- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
	if (responseCode == RestResponseCodeSuccess) {
		CGFloat height = [(NSString *)[parsedResponse objectForKey:@"height"] floatValue];
		LoadingUIWebView *headerView = [[LoadingUIWebView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, height)];
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path];  		
        [headerView loadHTMLString:[parsedResponse objectForKey:@"html"] baseURL:baseURL];		
		
		self.myTableView.tableHeaderView = headerView;
		
		[headerView release];
	} else {
		
	}    
}

- (void)remoteMethodDidFail:(NSString *)method {
    
}



@end
