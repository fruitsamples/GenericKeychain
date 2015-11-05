### GenericKeychain ###

================================================================================
DESCRIPTION:

This sample provides an example of how to navigate through the new SecItem API
found on the iPhone OS 2.0 Platform. Its demonstration leverages the Generic
Keychain Item class and provides a template on how to successfully setup calls 
to: SecItemAdd, SecItemCopyMatching, SecItemDelete, and SecItemUpdate.

The user interface is a master-detail designed in Interface Builder, archived in the MainWindow nib. 

================================================================================
BUILD REQUIREMENTS:

Mac OS X 10.5.3, Xcode 3.1, iPhone OS 2.0

================================================================================
RUNTIME REQUIREMENTS:

Mac OS X 10.5.3, iPhone OS 2.0 (Device *Only*)

================================================================================
PACKAGING LIST:

AppDelegate
Adds the root navigation controller's view to the main window and displays the window when the 
application launches.

KeychainWrapper
Abstract interface to the Keychain API.

DetailViewController
Custom detail view controller.

PasswordCell
Custom cell for displaying secure text in a table view.

CommentsCell
Custom cell for displaying a UITextView in a table view.

EditorController
View controller subclass for abstracting an interface to either a text field or a text view.

MainWindow.xib
The nib file containing the main window and the view controllers used in the application.


================================================================================
CHANGES FROM PREVIOUS VERSIONS:

Version 1.0
    N/A

Copyright (c) 2008 Apple Inc. All rights reserved.