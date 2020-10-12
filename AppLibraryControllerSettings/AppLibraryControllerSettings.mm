#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#include <spawn.h>

NSString *domainString = @"com.tomaszpoliszuk.applibrarycontroller";

@interface PSListController (AppLibraryController)
@end

@interface AppLibraryControllerSettings : PSListController
@end

@implementation AppLibraryControllerSettings
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}
- (instancetype)init {
	self = [super init];
	if (self) {
		UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respringDevice)];
		self.navigationItem.rightBarButtonItem = applyButton;
	}
	return self;
}
-(void)respringDevice {
	UIAlertController *confirmRespringAlert = [UIAlertController alertControllerWithTitle:@"Respring Device" message:@"Do you want to respring device?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		pid_t pid;
		const char *argv[] = {"sbreload", NULL};
		posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[confirmRespringAlert addAction:cancel];
	[confirmRespringAlert addAction:confirm];
	[self presentViewController:confirmRespringAlert animated:YES completion:nil];
}
- (void)resetSettings {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];
	UIAlertController *resetSettingsAlert = [UIAlertController alertControllerWithTitle:@"Reset App Library Controller Settings" message:@"Do you want to reset settings?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		for(NSString* key in [[tweakSettings dictionaryRepresentation] allKeys]) {
			[tweakSettings removeObjectForKey:key];
		}
		[tweakSettings synchronize];
		[self reloadSpecifiers];
		[self respringDevice];
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[resetSettingsAlert addAction:cancel];
	[resetSettingsAlert addAction:confirm];
	[self presentViewController:resetSettingsAlert animated:YES completion:nil];
}
-(void)sourceCode {
	NSURL *sourceCode = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/AppLibraryController"];
	[[UIApplication sharedApplication] openURL:sourceCode options:@{} completionHandler:nil];
}
-(void)knownIssues {
	NSURL *knownIssues = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/AppLibraryController/issues"];
	[[UIApplication sharedApplication] openURL:knownIssues options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *githubWebsite = [NSURL URLWithString:[@"https://github.com/" stringByAppendingString:username]];
	[application openURL:githubWebsite options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtTwitter {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}
@end
