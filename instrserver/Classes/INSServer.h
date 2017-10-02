#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface INSServer : NSObject

@property (nonatomic, readonly, assign) BOOL isReady;
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic, assign) NSUInteger timeout;

+ (instancetype)sharedServer;
- (void)start;

@end

NS_ASSUME_NONNULL_END
