/**
 * sharemail
 *
 * Created by Victor Cordero Utrilla
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "ComVcordSharemailModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation ComVcordSharemailModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"3dba0af9-3f0b-41eb-828d-e07790e841a7";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.vcord.sharemail";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)displayOptions:(id)args
{
    ENSURE_UI_THREAD(displayOptions, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *title       = [args objectForKey:@"title"];
    NSString *message     = [args objectForKey:@"message"];
    NSArray  *fileArray   = [args objectForKey:@"files"];
    
    NSMutableArray *activityItems = [[NSMutableArray alloc] init]; // Our activity items handler
    
    if ( (fileArray != nil || [fileArray count] == 0) )
    {
        if ( [fileArray count] > 0 )
        {
            NSData *data;
            for (id file in fileArray )
            {
                if ([file isKindOfClass:[TiBlob class]])
                {
                    NSString *path = [file path];
                    if (path==nil)
                    {
                        path = @"attachment";
                    }
                    else
                    {
                        path = [path lastPathComponent];
                    }
                    NSURL *fileUrl = [NSURL fileURLWithPath:path];
                    [data writeToURL:fileUrl atomically:YES]; // save the file
                    [activityItems addObject:fileUrl];
                }
                else
                {
                    TiFile *fileAttachment = (TiFile*)file;
                    NSString *path = [fileAttachment path];
                    NSURL *fileUrl = [NSURL fileURLWithPath:path];
                    [activityItems addObject:fileUrl];
                }
            }
        }
    }
    
    // Verify if there's a message to display
    if ( message.length != 0 )
    {
        [activityItems addObject:message];
    }

    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:activityItems
                                            applicationActivities:nil];
    // Exclude some unnecessary activities
    NSArray *exTypes = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                         UIActivityTypeMessage, UIActivityTypePrint,
                         UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,
                         UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList,
                         UIActivityTypePostToFlickr];

    activityVC.excludedActivityTypes = exTypes;
    
    NSString *mailSubject = title;
    [activityVC setValue:mailSubject forKey:@"subject"];
    
    TiThreadPerformOnMainThread(^{
        
        if ([TiUtils isIOS8OrGreater]) {
            [activityVC setModalPresentationStyle:UIModalPresentationPopover];
            [[[TiApp app]controller] presentViewController:activityVC animated:YES completion:nil];
            return;
        }
        
        // iOS 7 and below TODO
    }, YES);

}

@end
