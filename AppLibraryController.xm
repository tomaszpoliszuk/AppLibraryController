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


#import "headers.h"

NSMutableDictionary *tweakSettings;

static bool enableTweak;

static int uiStyle;

static int appLibrarytMode;

static bool appLibraryGesture;

static bool alphabeticListRoundedSearchField;
static int alphabeticListHeaders;

static bool categoriesLabels;
static bool categoriesBackground;

static bool foldersTitles;
static bool foldersLabels;

void TweakSettingsChanged() {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:kPackageIdentifier];

	enableTweak = [([tweakSettings objectForKey:@"enableTweak"] ?: @(YES)) boolValue];

	uiStyle = [([tweakSettings valueForKey:@"uiStyle"] ?: @(999)) integerValue];

	appLibrarytMode = [([tweakSettings valueForKey:@"appLibrarytMode"] ?: @(2)) integerValue];

	appLibraryGesture = [([tweakSettings objectForKey:@"appLibraryGesture"] ?: @(YES)) boolValue];

	alphabeticListRoundedSearchField = [( [tweakSettings objectForKey:@"alphabeticListRoundedSearchField"] ?: @(YES)) boolValue];
	alphabeticListHeaders = [([tweakSettings valueForKey:@"alphabeticListHeaders"] ?: @(0)) integerValue];

	categoriesLabels = [([tweakSettings objectForKey:@"categoriesLabels"] ?: @(YES)) boolValue];
	categoriesBackground = [([tweakSettings objectForKey:@"categoriesBackground"] ?: @(YES)) boolValue];

	foldersTitles = [([tweakSettings objectForKey:@"foldersTitles"] ?: @(YES)) boolValue];
	foldersLabels = [([tweakSettings objectForKey:@"foldersLabels"] ?: @(YES)) boolValue];
}

%hook SBHLibrarySearchController
%new
-(void)updateTraitOverride {
	if ( enableTweak && uiStyle != 999 ) {
		[self setOverrideUserInterfaceStyle:uiStyle];
	}
}
- (void)viewWillAppear:(bool)arg1 {
	if ( enableTweak ) {
		if ( uiStyle != 999 ) {
			[self setOverrideUserInterfaceStyle:uiStyle];
		}
		if ( appLibrarytMode == 2 ) {
			[self setActive:YES animated:YES];
		}
	}
	%orig;
}
- (void)searchBarTextDidEndEditing:(id)arg1 {
	if ( enableTweak && appLibrarytMode == 2 ) {
		[self setActive:YES animated:NO];
	}
	%orig;
}
- (void)_willDismissSearchAnimated:(bool)arg1 {
	if ( enableTweak && appLibrarytMode == 2 && !self.isSearchFieldEditing && !kIsiOS14_5AndUp ) {
		[[%c(SBIconController) sharedInstance] dismissLibraryOverlayAnimated:YES];
	}
	%orig;
}
%end

%hook SBHLibraryViewController
- (void)willDismissSearchController:(id)arg1 {
	%orig;
	if ( enableTweak && appLibrarytMode == 2 && kIsiOS14_5AndUp && ![[[%c(SBIconController) sharedInstance] _rootFolderController] isEditing] ) {
		[[self containerViewController] setActive:YES animated:NO];
	}
}
- (void)libraryTableViewControllerWillDisappear:(id)arg1 {
	if ( enableTweak && appLibrarytMode == 2 && ![self containerViewController].isActive && kIsiOS14_5AndUp ) {
		[[%c(SBIconController) sharedInstance] dismissLibraryOverlayAnimated:YES];
	}
	%orig;
}
%end

%hook _SBHLibraryPodIconListView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && appLibrarytMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook SBFTouchPassThroughView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 2 ) {
		if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBHLibraryPodFolderController)]) {
			return YES;
		}
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && appLibrarytMode == 2 ) {
		if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBHLibraryPodFolderController)]) {
			arg1 = YES;
		}
	}
	%orig;
}
%end

%hook SBHLibraryPodFolderView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && appLibrarytMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook _SBHLibraryPodIconView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && appLibrarytMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
- (bool)allIconElementsButLabelHidden {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setAllIconElementsButLabelHidden:(bool)arg1 {
	if ( enableTweak && appLibrarytMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook SBHLibraryCategoryPodBackgroundView
- (void)_updateVisualStyle {
	if ( enableTweak && !categoriesBackground ) {
		return;
	}
	%orig;
}
%end

%hook SBIconController
- (bool)isAppLibraryAllowed {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 404 ) {
		return NO;
	} else if ( enableTweak ) {
		return YES;
	}
	return origValue;
}
- (bool)isAppLibrarySupported {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode == 404 ) {
		return NO;
	} else if ( enableTweak ) {
		return YES;
	}
	return origValue;
}
%end

%hook SBHAppLibrarySettings
- (long long)minimumNumberOfIconsToShowSectionHeaderInDeweySearch {
	long long origValue = %orig;
	if ( enableTweak && alphabeticListHeaders == 404 ) {
		return 10000;
	} else if ( enableTweak && alphabeticListHeaders == 1 ) {
		return 1;
	}
	return origValue;
}
%end

%hook SBHAppLibraryVisualConfiguration
- (double)searchContinuousCornerRadius {
	double origValue = %orig;
	if ( enableTweak && !alphabeticListRoundedSearchField ) {
		return 0;
	}
	return origValue;
}
%end

%hook SBLeafIcon
- (id)displayNameForLocation:(id)arg1 {
	id origValue = %orig;
	if ( enableTweak ) {
		if ( ( appLibrarytMode == 2 && [arg1 hasPrefix:@"SBIconLocationAppLibrary"] && ![arg1 hasSuffix:@"Search"] ) || ( [arg1 isEqual:@"SBIconLocationAppLibrary"] && !categoriesLabels ) || ( [arg1 hasPrefix:@"SBIconLocationAppLibraryCategory"] && !foldersLabels ) ) {
			return nil;
		}
	}
	return origValue;
}
- (long long)accessoryTypeForLocation:(id)arg1 {
	long long origValue = %orig;
	if ( enableTweak ) {
		if ( ( appLibrarytMode == 2 && [arg1 hasPrefix:@"SBIconLocationAppLibrary"] && ![arg1 hasSuffix:@"Search"] ) || ( [arg1 isEqual:@"SBIconLocationAppLibrary"] && !categoriesLabels ) || ( [arg1 hasPrefix:@"SBIconLocationAppLibraryCategory"] && !foldersLabels ) ) {
			return nil;
		}
	}
	return origValue;
}
%end

%hook SBHFeatherBlurNavigationBar
- (void)layoutSubviews {
	if ( enableTweak && !foldersTitles ) {
		return;
	}
	%orig;
}
%end

%hook SBRootFolderView
- (bool)_shouldIgnoreOverscrollOnLastPageForCurrentOrientation {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		return appLibraryGesture;
	}
	return origValue;
}
- (bool)_shouldIgnoreOverscrollOnLastPageForOrientation:(long long)arg1 {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		return appLibraryGesture;
	}
	return origValue;
}
%end

%hook SBIconView
- (bool)allowsAccessoryView {
	bool origValue = %orig;
	if ( enableTweak && [[self _viewControllerForAncestor] isKindOfClass:%c(SBHIconLibraryTableViewController)] ) {
		NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/Preferences/com.apple.springboard.plist", NSHomeDirectory()]];
		bool sbHomeScreenShowsBadgesInAppLibrary = [[defaults objectForKey:@"SBHomeScreenShowsBadgesInAppLibrary"] boolValue];
		return sbHomeScreenShowsBadgesInAppLibrary;
	}
	return origValue;
}
%end


%hook SBHomeScreenOverlayViewController
-(double)presentationProgress {
	double origValue = %orig;
	if ( enableTweak && appLibrarytMode == 2 ) {
		[[self rightSidebarViewController].view setAlpha:origValue];
	}
	return origValue;
}
%end

%group iPadOS

%hook SBHLibrarySearchController
- (void)viewDidAppear:(bool)arg1 {
	%orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		SBHSearchBar *searchBar = [self valueForKey:@"_searchBar"];
		UIView *containerView = [self valueForKey:@"_containerView"];
		UIView *contentContainerView = [self valueForKey:@"_contentContainerView"];
		UIView *searchResultsContainerView = [self valueForKey:@"_searchResultsContainerView"];

		CGRect selfFrame = self.view.frame;
		[containerView setFrame:selfFrame];
		[contentContainerView setFrame:selfFrame];
		[searchResultsContainerView setFrame:selfFrame];

		UIEdgeInsets searchTextFieldHorizontalEdgeInsets = [searchBar searchTextFieldHorizontalEdgeInsets];

		searchTextFieldHorizontalEdgeInsets.left = 23;
		searchTextFieldHorizontalEdgeInsets.right = 23;

		[searchBar setSearchTextFieldHorizontalEdgeInsets:searchTextFieldHorizontalEdgeInsets];
	}
}
- (void)_layoutSearchViews {
	%orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		MTMaterialView *searchBackdropView = [self valueForKey:@"_searchBackdropView"];

		CGFloat width = [[UIScreen mainScreen] bounds].size.width;
		CGFloat height = [[UIScreen mainScreen] bounds].size.height;

		CGRect fullScreenFrame = CGRectMake(
			-100,
			-100,
			width + 200,
			height + 200
		);
		[searchBackdropView setBounds:fullScreenFrame];
		[searchBackdropView setFrame:fullScreenFrame];
	}
}
%end

%hook SBHLibraryPodFolderController
- (void)viewDidAppear:(bool)arg1 {
	%orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		UIView *containerView = [self containerView];
		CGRect containerFrame = containerView.frame;
		[self.view setFrame:containerFrame];
	}
}
%end

%hook _SBHLibraryPodIconListView
- (CGRect)frame {
	CGRect origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		CGRect newContainerFrame = origValue;
		newContainerFrame.size.width = 393;
		return newContainerFrame;
	}
	return origValue;
}
- (CGRect)iconLayoutRect {
	CGRect origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		CGRect newFrame = origValue;
		newFrame.size.width = 393;
		return newFrame;
	}
	return origValue;
}

- (CGSize)iconSpacing {
	CGSize origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		CGSize newSize = origValue;
		newSize.width = 33;
		newSize.height = 37;
		return newSize;
	}
	return origValue;
}
- (CGSize)effectiveIconSpacing {
	CGSize origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 ) {
		CGSize newSize = origValue;
		newSize.width = 33;
		newSize.height = 37;
		return newSize;
	}
	return origValue;
}
%end

%hook SBHIconManager
- (bool)rootFolder:(id)arg1 canAddIcon:(id)arg2 toIconList:(id)arg3 inFolder:(id)arg4 {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 && [arg4 isKindOfClass:%c( SBHLibraryCategoriesRootFolder )] ) {
		return YES;
	}
	return origValue;
}
%end

%hook SBIconView
- (bool)allowsAccessoryView {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 && ( [[self _viewControllerForAncestor] isKindOfClass:%c( SBHIconLibraryTableViewController )] || [[self _viewControllerForAncestor] isKindOfClass:%c( SBHLibraryCategoryIconViewController )] || [[self _viewControllerForAncestor] isKindOfClass:%c( SBHLibraryPodCategoryFolderController )] ) ) {
		NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/Preferences/com.apple.springboard.plist", NSHomeDirectory()]];
		bool sbHomeScreenShowsBadgesInAppLibrary = [[defaults objectForKey:@"SBHomeScreenShowsBadgesInAppLibrary"] boolValue];
		return sbHomeScreenShowsBadgesInAppLibrary;
	}
	return origValue;
}
%end

%hook SBHIconManager
- (bool)iconLocationAllowsBadging:(id)arg1 {
	bool origValue = %orig;
	if ( enableTweak && appLibrarytMode != 404 && ( [arg1 isKindOfClass:%c( SBHIconLibraryTableViewController )] || [arg1 isKindOfClass:%c( SBIconLocationAppLibraryCategoryPod )] || [arg1 isKindOfClass:%c( SBIconLocationAppLibraryCategoryPodRecents )] || [arg1 isKindOfClass:%c( SBIconLocationAppLibraryCategoryPodSuggestions )] ) ) {
		NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/Preferences/com.apple.springboard.plist", NSHomeDirectory()]];
		bool sbHomeScreenShowsBadgesInAppLibrary = [[defaults objectForKey:@"SBHomeScreenShowsBadgesInAppLibrary"] boolValue];
		return sbHomeScreenShowsBadgesInAppLibrary;
	}
	return origValue;
}
%end

%end

%ctor {
	TweakSettingsChanged();
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		(CFNotificationCallback)TweakSettingsChanged,
		CFSTR("com.tomaszpoliszuk.applibrarycontroller.settingschanged"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
	);
	%init;
	if ( kIsiPadOS ) {
		%init(iPadOS);
	}
}
