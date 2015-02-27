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

#import "SuperRewards/SRDataSource.h"
#import "SuperRewards/SROffer.h"



@implementation SRDataSource
@synthesize delegate, offersPerPage, mode, offers, isLoading, numPages, problemsUrl, currency, hasCompletedInitialLoad;

// private
- (void)reportErrorToDelegate {
    if ([delegate respondsToSelector:@selector(offersFailedLoadingFromDataSource:page:)]) {
        [delegate offersFailedLoadingFromDataSource:self];
        isLoading = NO;
        errorLoading = YES;
    }
}

// public
- (id)initWithGameId:(NSString *)_gameId userId:(NSString *)_userId mode:(SRMode)_mode 
       offersPerPage:(NSInteger)_offersPerPage {
    if (self = [super init]) {
        gameId = [_gameId copy];
        userId = [_userId copy];
        mode = _mode;
        offersPerPage = _offersPerPage;
        
        switch (mode) {
            case SRModeFree:
                modeString = @"free";
                break;                
            case SRModePaid:
                modeString = @"paid";
                break;
            case SRModeMobile:
                modeString = @"mobile";
                break;                
            default:
                modeString = @"all";                
                break;
        }
        offers = [[NSMutableArray alloc] initWithCapacity:30];
        currentPage = 0;
    }
    return self;
}

- (void)loadNextPage {
    // check to see if the parser is doing work, if so stop
    if (isLoading) {
        return;
    }
    
    // make sure the page number is valid
    if (numPages != 0 && currentPage >= numPages) {
        [self reportErrorToDelegate];
        return;        
    }
    
    isLoading = YES;
    errorLoading = NO;
    
    NSThread *getDataThread = [[NSThread alloc] initWithTarget:self selector:@selector(getData) object:nil];
    [getDataThread start];
    [getDataThread release];
}

- (void)getData {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *urlString = 
        [[NSString alloc] initWithFormat:@"%@?h=%@&uid=%@&mode=%@&n_offers=%d&page=%d&iphone=1&xml=1&ip=4.2.2.2", 
     SR_BASE_URL, gameId, userId, modeString, offersPerPage, currentPage];

    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [myParser release];
    myParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [myParser setDelegate:self];
    
    [myParser setShouldProcessNamespaces:NO];
    [myParser setShouldReportNamespacePrefixes:NO];
    [myParser setShouldResolveExternalEntities:NO];
    
    [url release];
    [urlString release];
    
    [myParser parse];
    
    NSError *parseError = [myParser parserError];
    if (parseError) {
        [self reportErrorToDelegate];
    } else {
        currentPage += 1;    
    }
    
    [pool release];
}

#pragma mark Parser Delegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [delegate offersFinishedLoadingFromDataSource:self];
    isLoading = NO;
    hasCompletedInitialLoad = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
        qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    [currentElementName release];
    currentElementName = nil;
    
    if ([elementName isEqualToString:@"offers"]) {
        [currency release];
        currency = [[attributeDict objectForKey:@"currency"] copy];
        
        numPages = [[attributeDict objectForKey:@"n_pages"] intValue];
        
        [problemsUrl release];
        problemsUrl = [[attributeDict objectForKey:@"problems_page"] copy];
    } else if ([elementName isEqualToString:@"offer"]) {
        [activeOffer release];
        activeOffer = [[SROffer alloc] init];
        
    } else {
        [contentsOfCurrentElement release]; 
        contentsOfCurrentElement = [[NSMutableString alloc] initWithCapacity:100];
        
        currentElementName = [elementName copy];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
        namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"offers"]) {
        
    } else if ([elementName isEqualToString:@"offer"]) {
        [offers addObject:activeOffer];
    } else if ([elementName isEqualToString:@"id"]) {
        activeOffer.offerId = contentsOfCurrentElement;
    } else if ([elementName isEqualToString:@"name"]) {
        activeOffer.name = contentsOfCurrentElement;
    } else if ([elementName isEqualToString:@"description"]) {
        activeOffer.description = contentsOfCurrentElement;
    } else if ([elementName isEqualToString:@"requirements"]) {
        activeOffer.requirements = contentsOfCurrentElement;
    } else if ([elementName isEqualToString:@"payout"]) {
        activeOffer.payout = [contentsOfCurrentElement intValue];
    } else if ([elementName isEqualToString:@"type"]) {
        if ([contentsOfCurrentElement isEqualToString:@"free"]) {
            activeOffer.type = SROfferTypeFree;
        } else if ([contentsOfCurrentElement isEqualToString:@"pay"]) { 
            activeOffer.type = SROfferTypePaid;            
        } else if ([contentsOfCurrentElement isEqualToString:@"mobile"]) { 
            activeOffer.type = SROfferTypeMobile;            
        }
    } else if ([elementName isEqualToString:@"url"]) {
        activeOffer.url = contentsOfCurrentElement;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [self reportErrorToDelegate];
    
    [activeOffer release];
    activeOffer = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (currentElementName) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [contentsOfCurrentElement appendString:string];
    }
}

- (void)dealloc {
    [contentsOfCurrentElement release];
    [currentElementName release];
    [gameId release];
    [userId release];
    [myParser release];
    [activeOffer release];
    [problemsUrl release];
    [currency release];
    [offers release];
    
    [super dealloc];
}

@end
