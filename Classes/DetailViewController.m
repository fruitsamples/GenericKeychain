/*

===== IMPORTANT =====

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not
final. Apple is supplying this information to help you plan for the adoption of
the technologies and programming interfaces described herein. This information
is subject to change, and software implemented based on this sample code should
be tested with final operating system software and final documentation. Newer
versions of this sample code may be provided with future seeds of the API or
technology. For information about updates to this and other developer
documentation, view the New & Updated sidebars in subsequent documentation
seeds.

=====================

File: DetailViewController.m
Abstract: Controller for editing text view data.

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import <Security/Security.h>

#import "DetailViewController.h"
#import "CommentsCell.h"
#import "PasswordCell.h"
#import "KeychainWrapper.h"
#import "EditorController.h"

#define kNameSectionIndex            0
#define kPasswordSectionIndex        1
#define kKindSectionIndex            2
#define kAccountSectionIndex        3
#define kWhereSectionIndex            4
#define kCommentsSectionIndex        5

// Defined UI constants.
#define kTableRowHeight             40.0
#define kCommentRowHeight           100.0

@implementation DetailViewController

@synthesize tableView, textFieldController, textViewController, keychainWrapper;

+ (NSString *)titleForSectionWithIndex:(NSInteger)sectionIndex
{
    switch (sectionIndex)
    {
        case kNameSectionIndex: return @"Name";
        case kPasswordSectionIndex: return @"Password";
        case kKindSectionIndex: return @"Kind";
        case kAccountSectionIndex: return @"Account";
        case kWhereSectionIndex: return @"Where";
        case kCommentsSectionIndex: return @"Comments";
    }
    return nil;
}

+ (id)secKeyForSectionWithIndex:(NSInteger)sectionIndex
{
    switch (sectionIndex)
    {
#if TARGET_IPHONE_SIMULATOR
#error This sample is designed to run on a device, not in the simulator. To run this sample, \
    choose Project > Set Active SDK > Device and connect a device. Then click Build and Go. 
#else
        case kNameSectionIndex: return (id)kSecAttrLabel;
        case kPasswordSectionIndex: return (id)kSecValueData;
        case kKindSectionIndex: return (id)kSecAttrDescription;
        case kAccountSectionIndex: return (id)kSecAttrAccount;
        case kWhereSectionIndex: return (id)kSecAttrService;
        case kCommentsSectionIndex: return (id)kSecAttrComment;
#endif
    }
    return nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // Title displayed by the navigation controller.
        self.title = @"Keychain";
    }
    return self;
}

- (void)dealloc
{
    // Release allocated resources.
    [tableView release];
    [textFieldController release];
    [textViewController release];
    [keychainWrapper release];
    [super dealloc];
}

- (void)awakeFromNib {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

// Action sheet delegate method.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [keychainWrapper resetKeychainItem];
        [self.tableView reloadData];
    }
}

- (IBAction)resetKeychain:(id)sender
{
    // open a dialog with an OK and cancel button
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Reset Generic Keychain Item?"
            delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [tableView reloadData];
}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    // 6 sections, one for each property
    return 6;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    // Only one row for each section
    return 1;
}

// Heigh required for each row - only the comments row differs from the others.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == kCommentsSectionIndex) ? kCommentRowHeight : kTableRowHeight;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (self.editing) ? indexPath : nil;
//}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [DetailViewController titleForSectionWithIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    Class cellClass = [UITableViewCell class];
    NSString *reuseIdentifier = @"RegularCell";
    if (indexPath.section == kCommentsSectionIndex)
    {
        cellClass = [CommentsCell class];
        reuseIdentifier = @"CommentsCell";
    }
    else if (indexPath.section == kPasswordSectionIndex)
    {
        cellClass = [PasswordCell class];
        reuseIdentifier = @"PasswordCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        // Create a new cell. CGRectZero allows the cell to determine the appropriate size.
        cell = [[[cellClass alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    cell.text = [keychainWrapper objectForKey:[DetailViewController secKeyForSectionWithIndex:indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id secKey = [DetailViewController secKeyForSectionWithIndex:indexPath.section];
    EditorController *editorController = nil;
    if (indexPath.section == kCommentsSectionIndex)
    {
        editorController = textViewController;
    }
    else
    {
        editorController = textFieldController;
        [editorController.textControl setPlaceholder:[DetailViewController titleForSectionWithIndex:indexPath.section]];
        [editorController.textControl setSecureTextEntry:(indexPath.section == kPasswordSectionIndex)];
    }
    editorController.keychainWrapper = keychainWrapper;    
    editorController.textValue = [keychainWrapper objectForKey:secKey];
    editorController.editedFieldKey = secKey;
    editorController.title = [DetailViewController titleForSectionWithIndex:indexPath.section];
    
    [self.navigationController pushViewController:editorController animated:YES];
}

@end