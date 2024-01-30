//  map for keys
//  Created by alx on 1/29/24.

#import "objectivemap.h"

@implementation map
+ (NSDictionary<NSNumber *, NSString *> *)M_MAP {
    static NSDictionary<NSNumber *, NSString *> *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
            @(53): @"Escape", @(18): @"1", @(19): @"2", @(20): @"3", @(21): @"4", @(23): @"5", @(22): @"6", @(26): @"7", @(28): @"8", @(25): @"9",
            @(29): @"0", @(27): @"-", @(24): @"=", @(51): @"<Delete>", @(48): @"Tab", @(12): @"Q", @(13): @"W", @(14): @"E", @(15): @"R", @(17): @"T",
            @(16): @"Y", @(32): @"U", @(34): @"I", @(31): @"O", @(35): @"P", @(33): @"[", @(30): @"]", @(36): @"Return", @(59): @"Control",
            @(0): @"A", @(1): @"S", @(2): @"D", @(3): @"F", @(5): @"G", @(4): @"H", @(38): @"J", @(40): @"K", @(37): @"L", @(41): @";",
            @(39): @"'", @(42): @"\\", @(56): @"Shift", @(10): @"#", @(6): @"Z", @(7): @"X", @(8): @"C", @(9): @"V", @(11): @"B",
            @(45): @"N", @(46): @"M", @(43): @",", @(47): @".", @(44): @"/", @(49): @" "
        };
    });
    return map;
}

+ (NSString *)convert:(CGKeyCode)key {
    NSDictionary<NSNumber *, NSString *> *m = [self M_MAP];
    NSString *ret = m[@(key)];
    return ret ?: @"";
}

@end
