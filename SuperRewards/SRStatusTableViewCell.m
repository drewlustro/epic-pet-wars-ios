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

#import "SuperRewards/SRGlobal.h"
#import "SRStatusTableViewCell.h"


@implementation SRStatusTableViewCell
@synthesize loading;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)_title subTitle:(NSString *)_subTitle {
    if (statusTitle == nil) {
        CGRect rect = CGRectMake(40, 20, 280, 16);
        statusTitle = [[UILabel alloc] initWithFrame:rect];
        statusTitle.font = [UIFont boldSystemFontOfSize:16];
        statusTitle.textColor = WEBCOLOR(0x0767baff);
        statusTitle.adjustsFontSizeToFitWidth = YES;
        statusTitle.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:statusTitle];
    }
    if (statusSubtitle == nil) {
		CGRect rect = CGRectMake(40, statusTitle.frame.origin.y + statusTitle.frame.size.height, 280, 20);
		statusSubtitle = [[UILabel alloc] initWithFrame:rect];
		statusSubtitle.font = [UIFont systemFontOfSize:12];
		statusSubtitle.textColor = [UIColor grayColor];
		statusSubtitle.adjustsFontSizeToFitWidth = YES;
		statusSubtitle.highlightedTextColor = [UIColor lightGrayColor];
		[self.contentView addSubview:statusSubtitle];
    }
    
    statusTitle.hidden = NO;
    statusSubtitle.hidden = NO;
    
    statusTitle.text = _title;
    statusSubtitle.text = _subTitle;
    [self setNeedsLayout];
}

- (void)setLoading:(BOOL)isLoading {
    loading = isLoading;
    if (loading) {
        if (loadingIndicatorView == nil) {
            loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.contentView addSubview:loadingIndicatorView];
        }
        
        [loadingIndicatorView startAnimating];
        statusTitle.hidden = YES;
        statusSubtitle.hidden = YES;
    } else {
        [loadingIndicatorView stopAnimating];
        statusTitle.hidden = NO;
        statusSubtitle.hidden = NO;        
    }
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    loadingIndicatorView.center = self.contentView.center;
}

- (void)dealloc {
    [super dealloc];
}


@end
