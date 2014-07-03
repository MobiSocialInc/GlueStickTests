Glue Stick Test
This is a iPhone/iPad app that deploys to iOS 7.0 and iOS 7.1.  They contain a couple tests which will allow you to send some example objects to the Omlet app.  Below are relevant snippets of code.  

##Getting this app to show up in the App Drawer
You can follow the instructions here to get your app to show in Omlet's app drawer.
http://www.omlet.me/docs/#register_app

##Sharing to Omlet

When opening an app through Omlet, Omlet will pass a URL that can be used to return to the Omlet screen where the user came from.

You can find GlueStick files here: https://github.com/MobiSocialInc/GlueStick

I added this function to the AppDelegate's implementation.  When your app opens through Omlet, this is the entry point.

```objc
- (BOOL)application:(UIApplication *)application
        openURL:(NSURL *)url
        sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    _callbackURLForSourceApp = [GlueStick callbackURLFromPasteboardURL:url];
    return YES;
}
```

I then store that URL in `callbackURLForSourceApp`, a proprety in my App Delegate's interface:

```objc
@property (strong, nonatomic) NSURL* callbackURLForSourceApp;
```

If you launch your app through Omlet, the URL saved to `callbackURLForSourceApp` can be used to return to Omlet.  You can use the following code to access the `callbackURLForSourceApp` from the AppDelegate:

```obcj
NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
```

##Using Gluestick to Send Content Back to Omlet
For iOS 7, we make use of the General Pasteboard to send information back to Omlet.  The following code snippets are examples of how put data on the pasteboard that the Omlet app can understand.

###Sending Images
```objc
UIPasteboard* pb = [UIPasteboard generalPasteboard];
UIImage* exampleImage = [UIImage imageNamed:@"exampleImage.png"];
[pb setImage: exampleImage];
```

###Sending Gifs
```objc
UIPasteboard* pb = [UIPasteboard generalPasteboard];
NSString *filePath = [[NSBundle mainBundle] pathForResource:@"exampleGif" ofType:@"gif"];
NSData* exampleGif = [NSData dataWithContentsOfFile:filePath];
[pb setData:exampleGif forPasteboardType:@"com.compuserve.gif"];
```

###Sending RDLs

```objc
UIImage* exampleImage = [UIImage imageNamed:@"exampleIcon.png"];

RichDeepLink* rdl = [RichDeepLink new];

rdl.noun = @"glue stick test";
rdl.displayTitle = @"Glue Stick Test";
rdl.displayText = @"Click here to run the Glue Stick tests.  Glue Stick is a tool for native iOS apps to     integrate with Omlet Chat!";
rdl.displayThumbnail = exampleImage;
rdl.thumbnailData = UIImagePNGRepresentation(exampleImage);
rdl.displayCaption = @"A native iOS app";
rdl.appName = @"Glue Stick Test";
rdl.callback = @"sfGlueStickTest://";
rdl.webCallback = @"http://www.omlet.me/index.html";

[GlueStick putPasteboardRDL: rdl];
```

From my iOS app, I can then return to Omlet.  When Omlet launches, it will use the URL you pass it to figure out what to do.  Using the `returnURL`, Omlet will send information passed thorugh pasteboard to the Feed the user came from.  Using `omlet://app/content`, the user will be given a choice of which feed they would like to send their data to.
```objc
NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
if( returnURL )
{
    [[UIApplication sharedApplication] openURL:returnURL];
}
else
{
    NSURL* omletURL = [NSURL URLWithString:@"omlet://app/content"];
    [[UIApplication sharedApplication] openURL:omletURL];
}
```
