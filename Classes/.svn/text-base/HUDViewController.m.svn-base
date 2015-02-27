/**
 * HUDViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * HUDViewController manages the hudview.  It shows the heads up display
 * that is common to all screens
 *
 * @author Amit Matani
 * @created 1/19/09
 */

#import "HUDViewController.h"
#import "HUDComaViewController.h"
#import "PDColoredProgressView.h"
#import "BlinkingUILabel.h"
#import "BattleMasterViewController.h"

@implementation HUDViewController
@synthesize experienceProgressView, hpLabel, energyLabel, yenLabel, moodLabel, posseLabel, respectPointsLabel, lvlLabel,
            experienceLabel, cashFlowLabel, refreshEnergyLabel, atkLabel, defLabel,
			respectButton, refreshMoneyLabel, cashFlowKeyLabel, refreshHpLabel, hpProgressView, bankFundsLabel, 
			ownerViewController = _ownerViewController;

static NSTimer *hudTimer;
static BOOL canShowTimers;
static int timerCount;

+ (void)initialize {
    if (self = [HUDViewController class]) {
        hudTimer = [[NSTimer timerWithTimeInterval:2 target:self selector:@selector(setCanShowTimers:) userInfo:nil repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:hudTimer forMode:NSDefaultRunLoopMode];
        //blinkQueue = [[NSMutableArray alloc] initWithCapacity:5];
    }
}

+ (void)setCanShowTimers:(NSTimer *)timer {
    if (timerCount < 2) {
        canShowTimers = NO;
        timerCount += 1;        
    } else {
        canShowTimers = YES;
        timerCount = 0;
    }
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:@"HUDView" bundle:[NSBundle mainBundle]]) {
        // Custom initialization
       [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [[BRSession sharedManager] registerObserverForProtagonistAnimal:self];
		comaController = [[HUDComaViewController alloc] init];
		comaController.hudViewController = self;
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reset];
    [respectButton addTarget:self action:@selector(respectButtonClicked) 
                   forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)respectButtonClicked {
//    [[[BRAppDelegate sharedManager] tabManager] showBattleMaster];
	BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
	[_ownerViewController presentModalViewControllerWithNavigationBar:bmvc];
	[bmvc release];	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
        change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"protagonistAnimal"]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [self reset];
        return;
    }
    ProtagonistAnimal *protagonistAnimal = [[BRSession sharedManager] protagonistAnimal]; 
    // todo change this so it gives some sort of visual notification like mob wars           
    NSString *temp;
    if ([keyPath isEqualToString:@"hp"] || [keyPath isEqualToString:@"hpMax"] || 
		[keyPath isEqualToString:@"hpMaxBoost"]) {
        temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonistAnimal.hp, protagonistAnimal.hpMax + protagonistAnimal.hpMaxBoost];
        [hpLabel setTextAndBlink:temp];
        [temp release];
		
		if (protagonistAnimal.hp == 0) {
			[self showComaOverlay];
		} else {
			[self hideComaOverlay];
		}
        
        float percentage = 1.0 * protagonistAnimal.hp / (protagonistAnimal.hpMax + protagonistAnimal.hpMaxBoost);
		[hpProgressView animateProgressTo:percentage];
        UIColor *tintColor;
        if (percentage > 0.75) {
            tintColor = [UIColor greenColor];
        } else if (percentage > .25) {
            tintColor = [UIColor yellowColor];            
        } else {
            tintColor = [UIColor redColor];            
        }
        [hpProgressView setTintColor:tintColor];
    } else if ([keyPath isEqualToString:@"energy"] || [keyPath isEqualToString:@"energyMax"] || 
			   [keyPath isEqualToString:@"energyMaxBoost"]) {
        temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonistAnimal.energy, protagonistAnimal.energyMax + protagonistAnimal.energyMaxBoost];
        [energyLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"money"]) {
//        yenLabel.text = [[NSString alloc] initWithFormat:@"¥%d", protagonistAnimal.money];
        temp = [[NSString alloc] initWithFormat:@"¥%d", protagonistAnimal.money];    
		[yenLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"mood"]) {
        temp = [[NSString alloc] initWithFormat:@"%d%%", protagonistAnimal.mood];
        [moodLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"posseSize"]) {
        temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.posseSize];
        [posseLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"respectPoints"]) {
        temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.respectPoints];
		[respectPointsLabel setTextAndBlink:temp];        
        [temp release];
    } else if ([keyPath isEqualToString:@"level"]) {
        temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.level];
        [lvlLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"experience"] || [keyPath isEqualToString:@"expNextLevel"]) {
        temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonistAnimal.experience, protagonistAnimal.expNextLevel];
        [experienceLabel setTextAndBlink:temp];
        [temp release];
		[experienceProgressView animateProgressTo:1.0 * protagonistAnimal.experience / protagonistAnimal.expNextLevel];
    } else if ([keyPath isEqualToString:@"timeLeftToEnergyRefresh"]) {
        int secondsLeft = protagonistAnimal.timeLeftToEnergyRefresh;        
        if (canShowTimers && secondsLeft != 0) {
            temp = [[NSString alloc] initWithFormat:@"More In: %d:%02d", secondsLeft / 60, secondsLeft % 60];
            refreshEnergyLabel.text = temp;
            [temp release];
            refreshEnergyLabel.hidden = NO;
            energyLabel.hidden = YES;
        } else {
            refreshEnergyLabel.hidden = YES;            
            energyLabel.hidden = NO;
        }
    } else if ([keyPath isEqualToString:@"timeLeftToHpRefresh"]) {
        int secondsLeft = protagonistAnimal.timeLeftToHpRefresh;
        if (canShowTimers && secondsLeft != 0) {
            temp = [[NSString alloc] initWithFormat:@"More In: %d:%02d", secondsLeft / 60, secondsLeft % 60];
            refreshHpLabel.text = temp;
            [temp release];
            refreshHpLabel.hidden = NO;
            hpLabel.hidden = YES;
        } else {
            refreshHpLabel.hidden = YES;            
            hpLabel.hidden = NO;
        }
    } else if ([keyPath isEqualToString:@"timeLeftToMoneyRefresh"]) {
        int secondsLeft = protagonistAnimal.timeLeftToMoneyRefresh;
        if (canShowTimers && secondsLeft != 0) {
            temp = [[NSString alloc] initWithFormat:@"More In: %d:%02d", secondsLeft / 60, secondsLeft % 60];
            refreshMoneyLabel.text = temp;
            [temp release];
            refreshMoneyLabel.hidden = NO;
            yenLabel.hidden = YES;
        } else {
            refreshMoneyLabel.hidden = YES;            
            yenLabel.hidden = NO;
        }
    } else if ([keyPath isEqualToString:@"atk"] || [keyPath isEqualToString:@"atkBoost"]) {
        temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.atk + protagonistAnimal.atkBoost];
        [atkLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"def"] || [keyPath isEqualToString:@"defBoost"]) {
        temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.def + protagonistAnimal.defBoost];
        [defLabel setTextAndBlink:temp];
        [temp release];
    } else if ([keyPath isEqualToString:@"income"]) {
        [self configureCashFlowDisplay:YES];          
    } else if ([keyPath isEqualToString:@"bankFunds"]) {
        temp = [[NSString alloc] initWithFormat:@"¥%qu", protagonistAnimal.bankFunds];
        [bankFundsLabel setTextAndBlink:temp];
        [temp release];
    }
}

- (void)configureCashFlowDisplay:(BOOL)animate {
    int income = [[[BRSession sharedManager] protagonistAnimal] income];        
    if (income == 0) {
        cashFlowLabel.hidden = YES;
        cashFlowKeyLabel.hidden = YES;
        return;
    } 
    NSString *temp;
    if (income < 0) {
        temp = [[NSString alloc] initWithFormat:@"-¥%d", abs(income)];
        cashFlowLabel.textColor = WEBCOLOR(0xffbfbdff);
    } else {
        temp = [[NSString alloc] initWithFormat:@"¥%d", income];
        cashFlowLabel.textColor = WEBCOLOR(0xc2ffbdff);
    }
    if (animate) {
        [cashFlowLabel setTextAndBlink:temp];
    } else {
        cashFlowLabel.text = temp;
    }
    cashFlowLabel.hidden = NO;
    cashFlowKeyLabel.hidden = NO;
    [temp release];                
}


/** 
 * Reset will reload all data in the views to conform to the
 * data in the session.  This is called usually on login
 */
- (void)reset {
    ProtagonistAnimal *protagonistAnimal = [[BRSession sharedManager] protagonistAnimal];
    NSString *temp = [[NSString alloc] initWithFormat:@"¥%qu", protagonistAnimal.money]; 
    yenLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d%%", protagonistAnimal.mood];       
    moodLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.posseSize];
    posseLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.respectPoints];
    respectPointsLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.level];
    lvlLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonistAnimal.experience, protagonistAnimal.expNextLevel];
    experienceLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"¥%qu", protagonistAnimal.bankFunds];
    bankFundsLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonistAnimal.hp, protagonistAnimal.hpMax + protagonistAnimal.hpMaxBoost];
	hpLabel.text = temp;
    [temp release];
	if (protagonistAnimal.hp == 0) {
		[self showComaOverlay];
	} else {
		[self hideComaOverlay];
	}
    
    float percentage = 1.0 * protagonistAnimal.hp / (protagonistAnimal.hpMax + protagonistAnimal.hpMaxBoost);
    [hpProgressView animateProgressTo:percentage];
    UIColor *tintColor;
    if (percentage > 0.75) {
        tintColor = [UIColor greenColor];
    } else if (percentage > .25) {
        tintColor = [UIColor yellowColor];            
    } else {
        tintColor = [UIColor redColor];            
    }
    [hpProgressView setTintColor:tintColor];
    
    temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonistAnimal.energy, protagonistAnimal.energyMax + protagonistAnimal.energyMaxBoost];
    energyLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.atk + protagonistAnimal.atkBoost];
    atkLabel.text = temp;
    [temp release];
    
    temp = [[NSString alloc] initWithFormat:@"%d", protagonistAnimal.def + protagonistAnimal.defBoost];
    defLabel.text = temp;
    [temp release];    
    
	int secondsLeft = protagonistAnimal.timeLeftToEnergyRefresh;
    temp = [[NSString alloc] initWithFormat:@"More In: %d:%02d", secondsLeft / 60, secondsLeft % 60];
    refreshEnergyLabel.text = temp;
    [temp release];
    
    refreshEnergyLabel.hidden = ![protagonistAnimal doesAnimalNeedMoreEnergy];
	
	experienceProgressView.progress = 1.0 * protagonistAnimal.experience / protagonistAnimal.expNextLevel;
    
    [self configureCashFlowDisplay:NO]; 
    refreshHpLabel.hidden = YES;
    hpLabel.hidden = NO;
    refreshMoneyLabel.hidden = YES;
    yenLabel.hidden = NO;
    refreshEnergyLabel.hidden = YES;
    energyLabel.hidden = NO;
}

- (void)showComaOverlay {
	[self.view addSubview:comaController.view];
}

- (void)hideComaOverlay {
	[comaController.view removeFromSuperview];	
}

- (void)cleanup {
    [[[BRSession sharedManager] protagonistAnimal] unregisterObserver:self]; 
    [[BRSession sharedManager] removeObserver:self forKeyPath:@"protagonistAnimal"];
}

- (void)blinkLabel:(UILabel *)label {
    
}

- (void)dealloc {
    debug_NSLog(@"deallocing the hud");
    [comaController cleanup];
 	[comaController release];
    
    // IBOutlets
    [hpLabel release];
    [energyLabel release];
    [yenLabel release];
    [moodLabel release];
    [posseLabel release];
    [respectPointsLabel release];
    [lvlLabel release];
    [experienceLabel release];
    [cashFlowLabel release];    
    [refreshEnergyLabel release];
    [atkLabel release];
    [defLabel release];
    [experienceProgressView release];
    [respectButton release];
    [refreshHpLabel release];
    [refreshMoneyLabel release];
    [cashFlowKeyLabel release];
    [hpProgressView release];
    [bankFundsLabel release];
    //[blinkQueue release];
    
    [super dealloc];
}


@end
