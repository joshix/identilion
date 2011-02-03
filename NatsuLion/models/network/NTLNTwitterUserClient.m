#import "NTLNTwitterUserClient.h"
#import "NTLNTwitterUserXMLReader.h"
#import "NTLNTwitterClient.h"
#import "NTLNAccount.h"
#import "NTLNHttpClientPool.h"

@implementation NTLNTwitterUserClient

@synthesize delegate;
@synthesize users;

- (void)dealloc {
	[users release];
	[delegate release];
	[super dealloc];
}

- (void)getUserInfo:(NSString*)q {
	NSString *url = [NSString stringWithFormat:@"%@users/show/%@.xml", [NTLNTwitterClient URLForTwitterWithAccount], q]; //could subclass or duplicate this fn to quell a build warn.
	[super requestGET:url];
}

- (void)getUserInfoForScreenName:(NSString*)screen_name {
	[self getUserInfo:screen_name];
}

- (void)getUserInfoForUserId:(NSString*)user_id {
	[self getUserInfo:user_id];
}

- (void)getFollowingsWithScreenName:(NSString*)screen_name page:(int)page {
	NSString *url = [NSString stringWithFormat:@"%@statuses/friends/%@.xml", [NTLNTwitterClient URLForTwitterWithAccount], screen_name];
	if (page > 1) {
		url = [NSString stringWithFormat:@"%@?page=%d", url, page];
	}
	[super requestGET:url];
}

- (void)getFollowersWithScreenName:(NSString*)screen_name page:(int)page {
	NSString *url = [NSString stringWithFormat:@"%@statuses/followers/%@.xml", [NTLNTwitterClient URLForTwitterWithAccount], screen_name];
	if (page > 1) {
		url = [NSString stringWithFormat:@"%@?page=%d", url, page];
	}
	[super requestGET:url];
}

- (void)requestSucceeded {
	if (statusCode == 200) {
		if (contentTypeIsXml) {
			NTLNTwitterUserXMLReader *xr = [[NTLNTwitterUserXMLReader alloc] init];
			[xr parseXMLData:recievedData];
			users = [xr.users retain];
			[xr release];
		}
	}
	
	[delegate twitterUserClientSucceeded:self];
	[[NTLNHttpClientPool sharedInstance] releaseClient:self];
}

- (void)requestFailed:(NSError*)error {
	[delegate twitterUserClientFailed:self];
	[[NTLNHttpClientPool sharedInstance] releaseClient:self];
}

@end
