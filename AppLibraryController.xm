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

static int appLibrarySelectView;

static bool appLibraryCategories;
static bool appLibraryCategoriesLabels;
static bool appLibraryCategoriesBackground;

void TweakSettingsChanged() {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];

	enableTweak = [( [tweakSettings objectForKey:@"enableTweak"] ?: @(YES) ) boolValue];

	appLibrarySelectView = [([tweakSettings valueForKey:@"appLibrarySelectView"] ?: @(1)) integerValue];

	appLibraryCategories = [( [tweakSettings objectForKey:@"appLibraryCategories"] ?: @(YES) ) boolValue];
	appLibraryCategoriesLabels = [( [tweakSettings objectForKey:@"appLibraryCategoriesLabels"] ?: @(YES) ) boolValue];
	appLibraryCategoriesBackground = [( [tweakSettings objectForKey:@"appLibraryCategoriesBackground"] ?: @(YES) ) boolValue];
}

%hook SBHLibrarySearchController
- (void)viewWillAppear:(bool)arg1 {
	if ( enableTweak && appLibrarySelectView == 1 ) {
		[self setActive:YES];
	}
	%orig;
}
- (void)searchBarTextDidEndEditing:(id)arg1 {
	if ( enableTweak && appLibrarySelectView == 1 && !appLibraryCategories ) {
		[self setActive:YES animated:NO];
	}
	%orig;
}
%end

%hook _SBHLibraryPodIconListView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && !appLibraryCategories ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !appLibraryCategories ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook SBFTouchPassThroughView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && !appLibraryCategories ) {
		if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBHLibraryPodFolderController)]) {
			return YES;
		}
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !appLibraryCategories ) {
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
	if ( enableTweak && !appLibraryCategories ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !appLibraryCategories ) {
		arg1 = YES;
	}
	%orig;
}
%end

%hook _SBHLibraryPodIconView
- (bool)isHidden {
	bool origValue = %orig;
	if ( enableTweak && !appLibraryCategories ) {
		return YES;
	}
	return origValue;
}
- (void)setHidden:(bool)arg1 {
	if ( enableTweak && !appLibraryCategories ) {
		arg1 = YES;
	}
	%orig;
}
- (bool)allIconElementsButLabelHidden {
	bool origValue = %orig;
	if ( enableTweak && !appLibraryCategories ) {
		return YES;
	}
	return origValue;
}
- (void)setAllIconElementsButLabelHidden:(bool)arg1 {
	if ( enableTweak && !appLibraryCategories ) {
		arg1 = YES;
	}
	%orig;
}
- (bool)allowsLabelArea {
	bool origValue = %orig;
	if ( enableTweak && ( !appLibraryCategoriesLabels || !appLibraryCategories ) ) {
		return NO;
	}
	return origValue;
}
- (void)configureForLabelAllowed:(bool)arg1 {
	if ( enableTweak && ( !appLibraryCategoriesLabels || !appLibraryCategories ) ) {
		arg1 = NO;
	}
	%orig;
}
%end

%hook SBHLibraryCategoryPodBackgroundView
- (void)_updateVisualStyle {
	if ( enableTweak && !appLibraryCategoriesBackground ) {
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
