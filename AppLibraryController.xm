@interface UIView (AppLibraryController)
-(id)_viewControllerForAncestor;
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBHLibrarySearchController : UIViewController
- (void)setActive:(bool)arg1;
- (void)setActive:(bool)arg1 animated:(bool)arg2;
@end

NSString *domainString = @"com.tomaszpoliszuk.applibrarycontroller";

NSMutableDictionary *tweakSettings;

static bool enableTweak;

static int selectMode;

static bool alphabeticListRoundedSearchField;
static int alphabeticListHeaders;

static bool categoriesLabels;
static bool categoriesBackground;

static bool foldersTitles;
static bool foldersLabels;

void TweakSettingsChanged() {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];

	enableTweak = [( [tweakSettings objectForKey:@"enableTweak"] ?: @(YES) ) boolValue];

	selectMode = [([tweakSettings valueForKey:@"selectMode"] ?: @(1)) integerValue];

	alphabeticListRoundedSearchField = [( [tweakSettings objectForKey:@"alphabeticListRoundedSearchField"] ?: @(YES) ) boolValue];
	alphabeticListHeaders = [([tweakSettings valueForKey:@"alphabeticListHeaders"] ?: @(0)) integerValue];

	categoriesLabels = [( [tweakSettings objectForKey:@"categoriesLabels"] ?: @(YES) ) boolValue];
	categoriesBackground = [( [tweakSettings objectForKey:@"categoriesBackground"] ?: @(YES) ) boolValue];

	foldersTitles = [( [tweakSettings objectForKey:@"foldersTitles"] ?: @(YES) ) boolValue];
	foldersLabels = [( [tweakSettings objectForKey:@"foldersLabels"] ?: @(YES) ) boolValue];
}

%hook SBHLibrarySearchController
- (void)viewWillAppear:(bool)arg1 {
	if ( enableTweak && selectMode == 2 ) {
		[self setActive:YES];
	}
	%orig;
}
- (void)searchBarTextDidEndEditing:(id)arg1 {
	if ( enableTweak && selectMode == 1 && selectMode == 2 ) {
		[self setActive:YES animated:NO];
	}
	%orig;
}
%end

%hook _SBHLibraryPodIconListView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && selectMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && selectMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook SBFTouchPassThroughView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && selectMode == 2 ) {
		if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBHLibraryPodFolderController)]) {
			return YES;
		}
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && selectMode == 2 ) {
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
	if ( enableTweak && selectMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && selectMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook _SBHLibraryPodIconView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && selectMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && selectMode == 2 ) {
		arg1 = YES;
	}
	%orig;
}
- (bool)allIconElementsButLabelHidden {
	bool origValue = %orig;
	if ( enableTweak && selectMode == 2 ) {
		return YES;
	}
	return origValue;
}
- (void)setAllIconElementsButLabelHidden:(bool)arg1 {
	if ( enableTweak && selectMode == 2 ) {
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
	if ( enableTweak && selectMode == 404 ) {
		return NO;
	} else if ( enableTweak && selectMode == ( 1 | 2 ) ) {
		return YES;
	}
	return origValue;
}
- (bool)isAppLibrarySupported {
	bool origValue = %orig;
	if ( enableTweak && selectMode == 404 ) {
		return NO;
	} else if ( enableTweak && selectMode == ( 1 | 2 ) ) {
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

		if ( ( selectMode == 2 && [arg1 hasPrefix:@"SBIconLocationAppLibrary"] && ![arg1 hasSuffix:@"Search"] ) || ( [arg1 isEqual:@"SBIconLocationAppLibrary"] && !categoriesLabels ) || ( [arg1 hasPrefix:@"SBIconLocationAppLibraryCategory"] && !foldersLabels ) ) {
			return nil;
		}
	}
	return origValue;
}
- (long long)accessoryTypeForLocation:(id)arg1 {
	long long origValue = %orig;
	if ( enableTweak ) {
		if ( ( selectMode == 2 && [arg1 hasPrefix:@"SBIconLocationAppLibrary"] && ![arg1 hasSuffix:@"Search"] ) || ( [arg1 isEqual:@"SBIconLocationAppLibrary"] && !categoriesLabels ) || ( [arg1 hasPrefix:@"SBIconLocationAppLibraryCategory"] && !foldersLabels ) ) {
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
}
