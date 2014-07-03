//
//  ViewController.m
//  Glue Stick Test
//
//  Created by Sean Foo on 6/27/14.
//  Copyright (c) 2014 sf. All rights reserved.
//

#import "ViewController.h"
#import "GlueStick.h"
#import "AppDelegate.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    int screenCenterX = [[UIScreen mainScreen] bounds].size.width / 2 - 160 / 2;
    int screenCenterY = [[UIScreen mainScreen] bounds].size.height / 2 - 40 / 2;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(screenCenterX + 30, screenCenterY - 80.0f, 160, 40)];
    label.text = @"Glue Stick Test";
    [[self view] addSubview:label];
    
    //-- Button for sending image
    UIButton *ImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ImageButton addTarget:self
            action:@selector(sendImage)
            forControlEvents:UIControlEventTouchUpInside];
    [ImageButton setTitle:@"Send Example Image!" forState:UIControlStateNormal];
    ImageButton.frame = CGRectMake(screenCenterX, screenCenterY - 40.0f, 160.0, 40.0);
    [[self view] addSubview:ImageButton ];
    
    //-- Button for sending gif
    UIButton *GifButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [GifButton addTarget:self
               action:@selector(sendGif)
     forControlEvents:UIControlEventTouchUpInside];
    [GifButton setTitle:@"Send Example Gif!" forState:UIControlStateNormal];
    GifButton.frame = CGRectMake(screenCenterX, screenCenterY, 160.0, 40.0);
    [[self view] addSubview:GifButton ];
    
    //-- Button for sending RDL
    UIButton *RDLButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [RDLButton addTarget:self
               action:@selector(sendRDL)
     forControlEvents:UIControlEventTouchUpInside];
    [RDLButton setTitle:@"Send Example RDL!" forState:UIControlStateNormal];
    RDLButton.frame = CGRectMake(screenCenterX, screenCenterY + 40.0f, 160.0, 40.0);
    [[self view] addSubview:RDLButton ];
}

- (void) sendImage
{
    if( ![GlueStick isMessengerInstalled] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Omlet not Installed"
                                                        message:@"Please download Omlet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
    
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    UIImage* exampleImage = [UIImage imageNamed:@"exampleImage.png"];
    [pb setImage: exampleImage];

    if( returnURL )
    {
        [[UIApplication sharedApplication] openURL:returnURL];
    }
    else
    {
        NSURL* omletURL = [NSURL URLWithString:@"omlet://app/content"];
        [[UIApplication sharedApplication] openURL:omletURL];
    }
}

- (void) sendGif
{
    if( ![GlueStick isMessengerInstalled] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Omlet not Installed"
                                                        message:@"Please download Omlet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
    
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    NSError* error = nil;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"exampleGif" ofType:@"gif"];
    NSData* exampleGif = [NSData dataWithContentsOfFile:filePath options: 0 error: &error];
    [pb setData:exampleGif forPasteboardType:@"com.compuserve.gif"];
    
    if( returnURL )
    {
        [[UIApplication sharedApplication] openURL:returnURL];
    }
    else
    {
        NSURL* omletURL = [NSURL URLWithString:@"omlet://app/content"];
        [[UIApplication sharedApplication] openURL:omletURL];
    }
}

- (void) sendRDL
{
    if( ![GlueStick isMessengerInstalled] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Omlet not Installed"
                                                        message:@"Please download Omlet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
    
    UIImage* exampleImage = [UIImage imageNamed:@"exampleIcon.png"];
    
    RichDeepLink* rdl = [RichDeepLink new];
    
    rdl.noun = @"glue stick test";
    rdl.displayTitle = @"Glue Stick Test";
    rdl.displayText = @"Click here to run the Glue Stick tests.  Glue Stick is a tool for native iOS apps to integrate with Omlet Chat!";
    rdl.displayThumbnail = exampleImage;
    rdl.thumbnailData = UIImagePNGRepresentation(exampleImage);
    rdl.displayCaption = @"A native iOS app";
    rdl.appName = @"Glue Stick Test";
    rdl.callback = @"sfGlueStickTest://";
    rdl.webCallback = @"http://www.omlet.me/index.html";
    
    [GlueStick putPasteboardRDL: rdl];

    if( returnURL )
    {
        [[UIApplication sharedApplication] openURL:returnURL];
    }
    else
    {
        NSURL* omletURL = [NSURL URLWithString:@"omlet://app/content"];
        [[UIApplication sharedApplication] openURL:omletURL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
