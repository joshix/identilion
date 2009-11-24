#import <UIKit/UIKit.h>

// Hacked here - status.net doesn't have OAuth yet.
#undef ENABLE_OAUTH

int main(int argc, char *argv[]) {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"NTLNAppDelegate");
	[pool release];
	return retVal;
}
