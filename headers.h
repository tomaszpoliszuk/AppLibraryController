/* App Library Controller - Control App Library on iOS/iPadOS
 * (c) Copyright 2020-2022 Tomasz Poliszuk
 *
 * App Library Controller is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * App Library Controller is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with App Library Controller. If not, see <https://www.gnu.org/licenses/>.
 */


#define kPackageIdentifier @"com.tomaszpoliszuk.applibrarycontroller"

#define kIsiOS14_5AndUp [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){14, 5, 0}]

#define kIsiPadOS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface UIView (AppLibraryController)
-(id)_viewControllerForAncestor;
@end

@interface SBHSearchBar : UIView
@property (assign,nonatomic) UIEdgeInsets searchTextFieldHorizontalEdgeInsets;
@end

@interface SBIconView : UIView
@end

@interface MTMaterialView : UIView
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBHLibrarySearchController : UIViewController
- (bool)isActive;
- (bool)isSearchFieldEditing;
- (void)setActive:(bool)arg1 animated:(bool)arg2;
@end

@interface SBNestingViewController : UIViewController
@end
@interface SBHLibraryViewController : SBNestingViewController
@property (nonatomic, readonly) SBHLibrarySearchController *containerViewController;
@end

@interface SBFolderController : SBNestingViewController
@end

@interface SBHLibraryPodFolderController : SBFolderController
@property (nonatomic,readonly) UIView * containerView;
@end

@interface SBRootFolderController : SBFolderController
@property (getter=isEditing, nonatomic) bool editing;
@end

@interface SBIconController : UIViewController
@property (getter=_rootFolderController, nonatomic, readonly) SBRootFolderController *rootFolderController;
+ (id)sharedInstance;
- (void)dismissLibraryOverlayAnimated:(bool)arg1;
@end

@protocol SBHOccludable
@end

@interface SBHomeScreenOverlayViewController : UIViewController
@property (nonatomic,retain) NSLayoutConstraint * contentWidthConstraint;
@property (nonatomic, retain) UIViewController<SBHOccludable> *rightSidebarViewController;
@end

@interface SBIconListView : UIView
- (NSString *)iconLocation;
@end
@interface _SBHLibraryPodIconListView : SBIconListView
@end

@interface SBFolderContainerView : SBFTouchPassThroughView
@end

@interface SBFolderView : UIView
@end
@interface SBHLibraryPodFolderView : SBFolderView
@end
