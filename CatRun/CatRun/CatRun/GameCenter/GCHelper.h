
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface GCHelper : NSObject <NSCoding> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    NSMutableArray *scoresToReport;
    NSMutableArray *achievementsToReport;
}

@property (retain) NSMutableArray *scoresToReport;
@property (retain) NSMutableArray *achievementsToReport;

+ (GCHelper *) sharedInstance;
- (void)authenticationChanged;
- (void)authenticateLocalUser;
- (void)save;
- (id)initWithScoresToReport:(NSMutableArray *)scoresToReport 
        achievementsToReport:(NSMutableArray *)achievementsToReport;
- (void)reportAchievement:(NSString *)identifier 
          percentComplete:(double)percentComplete;
- (void)reportScore:(NSString *)identifier score:(double)score;

@end