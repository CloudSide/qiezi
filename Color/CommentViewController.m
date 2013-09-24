//
//  CommentViewController.m
//  Color
//
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommentViewController

@synthesize mTextView = _mTextView , delegate = _delegate;
@synthesize feedId = _feedId , feedUsername = _feedUsername;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendComment:(id)sender{
    [self.delegate sendComment:[self.mTextView.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                        feedId:self.feedId];
    [self.navigationController popViewControllerAnimated:YES];
}

-(id)initWithFeedId:(NSString *)feedId andFeedUserName:(NSString *)feedUsername{
    self = [super init];
    if (self) {
        self.feedUsername = feedUsername;
        self.feedId = feedId;
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        [navigationBar setBarStyle:UIBarStyleBlack];
        [navigationBar setTranslucent:YES];
        
        UINavigationItem *aNavigationItem = [[UINavigationItem alloc] init];
        [aNavigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease]];
        [aNavigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sendComment:)] autorelease]];
        
        [navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
        
        [aNavigationItem release];
        
        [[self view] addSubview:navigationBar];
        [navigationBar release];
        
        self.mTextView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.bounds.size.height-44)] autorelease];
        self.mTextView.font = [UIFont fontWithName:@"Helvetica" size:18];
        
        if (self.feedUsername && self.feedId > 0) {
            self.mTextView.delegate = self;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 80, 22)];
            label.tag = 999;
            label.textColor = [UIColor blackColor];
            label.text = [NSString stringWithFormat:@"@%@:",self.feedUsername];
            //计算评论内容的size
            CGSize labelFontSize = [label.text sizeWithFont:label.font 
                                               constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, 22) 
                                                   lineBreakMode:label.lineBreakMode];
            CGRect frame = label.frame;
            frame.size.width = labelFontSize.width + 5;
            label.frame = frame;
            
            label.backgroundColor = [UIColor grayColor];
            label.layer.cornerRadius = 8.0f;
            
            NSMutableString *strHolder = [NSMutableString stringWithString:@""];
            //计算空格的size
            CGSize charFontSize = [@" " sizeWithFont:label.font 
                                          constrainedToSize:CGSizeMake(self.view.frame.size.width, 22) 
                                              lineBreakMode:label.lineBreakMode];

            for (int i = 0; i < (int)(label.frame.size.width / charFontSize.width);  ++i) {
                [strHolder appendString:@" "];
                ++spaceAmount;
            }
            self.mTextView.text = strHolder;
            
            [self.mTextView addSubview:label];
            [self.mTextView sendSubviewToBack:label];
            [label release];
        }
        

        [self.view addSubview:self.mTextView];
        
        [self.mTextView becomeFirstResponder];//显示键盘
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        
        
#ifdef __IPHONE_7_0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            
            navigationBar.frame = CGRectMake(0, 10, 320, 44.0);
            
            self.mTextView.frame = CGRectMake(0, 54, self.view.frame.size.width, self.view.bounds.size.height-54);
        }
#endif
        
    }
    
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
//    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
//    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
    //自适应代码
    
    CGRect frame = self.mTextView.frame;
    frame.size.height = self.view.bounds.size.height - 44 - 10 - kbSize.height;
    self.mTextView.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mTextView = nil;
    self.delegate = nil;
    self.feedId = nil;
    self.feedUsername = nil;
    
    [super dealloc];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView viewWithTag:999] != nil && textView.selectedRange.location < spaceAmount) {
        textView.selectedRange = NSMakeRange(spaceAmount, 0);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{   
    if ([textView viewWithTag:999] != nil && range.location < spaceAmount) {
        [[textView viewWithTag:999] removeFromSuperview];
        textView.text = @"";
    }
    
    return YES;
}

@end
