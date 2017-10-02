#import "INSServer.h"
@import GCDWebServer;
@import ObjectiveC.message;

@interface INSServer ()

@property (nonatomic) GCDWebServer *webServer;
@property (nonatomic, assign) BOOL isReady;

@end

@implementation INSServer

+ (instancetype)sharedServer {
    static INSServer *server;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[self alloc] init];
    });
    return server;
}

#pragma mark - Public

- (void)start {
    NSLog(@"[instr] Starting server at port %lu", self.port);
    [self.webServer startWithPort:self.port
                      bonjourName:nil];
    [self lock];
}

- (NSUInteger)port {
    if (!_port) {
        _port = 8080;
    }
    return _port;
}

- (NSUInteger)timeout {
    if (!_timeout) {
        _timeout = 60;
    }
    return _timeout;
}

#pragma mark - Private

- (GCDWebServer *)webServer {
    if (!_webServer) {
        _webServer = [[GCDWebServer alloc] init];
        __weak typeof(self) weakSelf = self;
        [_webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
                                      NSLog(@"[instr] Request received");
                                      weakSelf.isReady = true;
                                      return [GCDWebServerResponse responseWithStatusCode:200];
                                  }];
    }
    return _webServer;
}

- (void)lock {
    NSArray *allFrameworks = [NSBundle allFrameworks];
    __block BOOL found = NO;
    [allFrameworks enumerateObjectsUsingBlock:^(NSBundle * _Nonnull framework, NSUInteger index, BOOL * _Nonnull stop) {
        if ([framework.bundleIdentifier containsString:@"EarlGrey"]) {
            found = YES;
            *stop = YES;
        }
    }];
    if (!found) {
        NSLog(@"[instr] Couldn't find EarlGrey. Please use -[INSServer isReady] instead.");
        return;
    }

    BOOL (^conditionBlock)(void) = ^(void) {
        return self.isReady;
    };

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    id (*f)(id, SEL, NSString *, BOOL (^)(void)) = (id (*)(id, SEL, NSString *, BOOL (^)(void)))objc_msgSend;
    id condition = f(NSClassFromString(@"GREYCondition"), @selector(conditionWithName:block:), @"Waiting for instr", conditionBlock);
    id (*g)(id, SEL, CFTimeInterval) = (id (*)(id, SEL, CFTimeInterval))objc_msgSend;
    g(condition, @selector(waitWithTimeout:), self.timeout);

#pragma clang diagnostic pop

}

@end
