/**
 * AnimalTypeDetailViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AnimalTypeDetailViewController displays a detail view of the animaltype 
 * the user selected in the AnimalTypeSelectionController table.  The 
 * AnimalTypeSelectionController passes over the AnimalType object and
 * it is displayed in greater detail than could be possible on a table cell.
 * The user can decide to use this animal or go back.  If the user decides to
 * use the current animal it moves forward on the account creation
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "AnimalTypeDetailViewController.h"
#import "AnimalType.h"
#import "BRAppDelegate.h"
#import "RemoteImageViewWithFileStore.h"
#import "BRSession.h"
#import "NewAnimalSetupViewController.h"
#import "Utility.h"

#define PADDING 20
#define ANIMAL_IMAGE_WIDTH 150


@implementation AnimalTypeDetailViewController

/**
 * initWithAnimalType inits the object while saving the animalType
 * @param AnimalType *_animalType
 * @return id - the newly created object
 */
- (id)initWithAnimalType:(AnimalType *)_animalType {
    if (self = [super init]) {
        animalType = [_animalType retain];
        self.title = animalType.name;
    }
    return self;
}



- (void)loadView {
    [myScrollView release];
    myScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	myScrollView.backgroundColor = [UIColor whiteColor];
	
	UIImageView *gradientBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient_gray_bg.png"]];
	gradientBg.frame = CGRectMake(0, 0, 320, 480);
	[myScrollView addSubview:gradientBg];
	[gradientBg release];	
	
    self.view = myScrollView;
    
    [animalImageView release];
    animalImageView = [[RemoteImageViewWithFileStore alloc] initWithFrame:CGRectMake(85, 20, ANIMAL_IMAGE_WIDTH, ANIMAL_IMAGE_WIDTH)];
    animalImageView.hasBorder = NO;
    [animalImageView loadImageWithUrl:animalType.imageSquare150];

    [self.view addSubview:animalImageView];
	
	
	CGPoint p = CGPointMake(0, ANIMAL_IMAGE_WIDTH + PADDING);
	p = [self setupKeyValueAtPoint:p key:@"Health" value:[NSString stringWithFormat:@"%@/%@", animalType.baseHp, animalType.baseHp]];
	p = [self setupKeyValueAtPoint:p key:@"Energy" value:[NSString stringWithFormat:@"%@/%@", animalType.baseEnergy, animalType.baseEnergy]];
	p = [self setupKeyValueAtPoint:p key:@"Mood" value:[NSString stringWithFormat:@"%@/%@", animalType.baseMood, animalType.baseMood]];
	p = [self setupKeyValueAtPoint:p key:@"Energy Refresh" value:[NSString stringWithFormat:@"%@ secs.", animalType.baseEnergyRefreshSeconds]];
	p = [self setupKeyValueAtPoint:p key:@"Money Refresh" value:[NSString stringWithFormat:@"%@ secs.", animalType.baseMoneyRefreshSeconds]];
	p = [self setupKeyValueAtPoint:p key:@"Health Refresh" value:[NSString stringWithFormat:@"%@ secs.", animalType.baseHpRefreshSeconds]];
	p = [self setupKeyValueAtPoint:p key:@"Attack" value:animalType.baseAttack];
	p = [self setupKeyValueAtPoint:p key:@"Defense" value:animalType.baseDefense];
	p.y += PADDING;
    
    // switch these when doing the real thing, might need to do the resizing thing
	UIColor *shadowColor = WEBCOLOR(0x244400FF);
    acceptPetButton = [[UIButton alloc] init];
    NSString *buttonTitle = [[NSString alloc] initWithFormat:@"Adopt %@", animalType.name];
	acceptPetButton.frame = CGRectMake(PADDING, p.y, 280, 46);
	acceptPetButton.titleShadowOffset = CGSizeMake(0, -1);
	acceptPetButton.font = [UIFont boldSystemFontOfSize:16];
	[acceptPetButton setBackgroundImage:[UIImage imageNamed:@"new_account_button.png"] forState:UIControlStateNormal];
	[acceptPetButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[acceptPetButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[acceptPetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptPetButton setTitle:buttonTitle forState:UIControlStateNormal];
    [acceptPetButton addTarget:self action:@selector(showNewAnimalSetup) 
                      forControlEvents:UIControlEventTouchUpInside];
    
	[self.view addSubview:acceptPetButton];
	[buttonTitle release];
	
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
}

- (CGPoint)setupKeyValueAtPoint:(CGPoint)p key:(NSString *)keyString value:(NSString *)valueString {

#define VALUE_FONT_SIZE 12
#define LABEL_HEIGHT 20
#define VALUE_WIDTH 80
#define KEY_WIDTH 140
	
	UIFont *keyFont = [UIFont boldSystemFontOfSize:VALUE_FONT_SIZE];
	UIColor *keyColor = [UIColor darkGrayColor];
	
	UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(p.x + PADDING * 3, p.y, KEY_WIDTH, LABEL_HEIGHT)];
	keyLabel.font = keyFont;
	keyLabel.textColor = keyColor;
	keyLabel.text = keyString;
	keyLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:keyLabel];
	[keyLabel release];
	
	UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(p.x + PADDING + KEY_WIDTH, p.y, VALUE_WIDTH, LABEL_HEIGHT)];
	valueLabel.font = keyFont;
	valueLabel.text = valueString;
	valueLabel.textAlignment = UITextAlignmentRight;
	valueLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:valueLabel];
	[valueLabel release];
	
	//p.x += PADDING * 2 + KEY_WIDTH + VALUE_WIDTH;
	//p.y += LABEL_HEIGHT;
	p.y += LABEL_HEIGHT;
	return p;
}

/**
 * showNewAccountSetup creates a NewAccountSetupViewController object and
 * pushes its view on top of the navigation stack.
 */ 
- (void)showNewAnimalSetup {
	UIViewController *newAccountVC =
		[[NewAnimalSetupViewController alloc] initWithAnimalType:animalType];		
	
    [[self navigationController] pushViewController:newAccountVC animated:YES];
	
    [newAccountVC release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [animalType release];
	[animalImageView release];
    [acceptPetButton release];
	//[acceptPetButton release];
    [super dealloc];
}


@end
