#import "MWZUIOpeningHoursUtils.h"
#import "MWZUIOpeningInterval.h"

@implementation MWZUIOpeningHoursUtils

+ (NSArray<MWZUIOpeningInterval*>*) getSortedIntervals:(NSArray<NSDictionary*>*) input {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate now]];
    NSInteger weekday = [components weekday];
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    NSInteger currentMin = hour * 60 + min;
    
    return [MWZUIOpeningHoursUtils sortIntervals:[MWZUIOpeningHoursUtils buildIntervals:input] day:weekday minuts:currentMin];
}

+ (NSArray<NSDictionary*>*) getOpeningStrings:(NSArray<NSDictionary*>*) input {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate now]];
    NSInteger weekday = [components weekday];
    
    NSArray<MWZUIOpeningInterval*>* intervals = [MWZUIOpeningHoursUtils buildIntervals:input];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for (MWZUIOpeningInterval* interval in intervals) {
        if (!dic[[NSNumber numberWithLong:interval.day]]) {
            dic[[NSNumber numberWithLong:interval.day]] = [[NSMutableArray alloc] init];
        }
        [dic[[NSNumber numberWithLong:interval.day]] addObject:interval];
    }
    
    NSMutableArray* output = [[NSMutableArray alloc] init];
    for (int i=0; i<7; i++) {
        NSArray* arr = dic[[NSNumber numberWithInt:(i + weekday) % 7]];
        if (!arr) {
            [output addObject:@{@"value":NSLocalizedString(@"Close", @""), @"day":[MWZUIOpeningHoursUtils getDayName:(i + weekday) % 7]}];
        }
        else {
            NSString* s = @"";
            for (MWZUIOpeningInterval* inter in arr) {
                if (s.length == 0) {
                    s = [s stringByAppendingFormat:@"%@ - %@", [MWZUIOpeningHoursUtils getFormattedHours:inter.open], [MWZUIOpeningHoursUtils getFormattedHours:inter.close]];
                }
                else {
                    s = [s stringByAppendingFormat:@"\n%@ - %@", [MWZUIOpeningHoursUtils getFormattedHours:inter.open], [MWZUIOpeningHoursUtils getFormattedHours:inter.close]];
                }
            }
            [output addObject:@{@"value":s, @"day":[MWZUIOpeningHoursUtils getDayName:(i + weekday) % 7]}];
        }
    }
    
    return output;
}

+ (NSString*) getCurrentOpeningStateString:(NSArray<NSDictionary*>*) input {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate now]];
    NSInteger weekday = [components weekday];
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    NSInteger currentMin = hour * 60 + min;
    
    NSArray<MWZUIOpeningInterval*>* intervals = [MWZUIOpeningHoursUtils sortIntervals:[MWZUIOpeningHoursUtils buildIntervals:input] day:weekday minuts:currentMin];
    // Check if open 24/7
    
    MWZUIOpeningInterval* currentInterval = [MWZUIOpeningHoursUtils getIntervalIfOpenFromIntervals:intervals day:weekday minuts:currentMin];
    if (currentInterval) {
        MWZUIOpeningInterval* closingInterval = [MWZUIOpeningHoursUtils getNextCloseIntervalFromIntervals:intervals currentInterval:currentInterval];
        if (closingInterval) {
            if (closingInterval == currentInterval) {
                return [NSString stringWithFormat:NSLocalizedString(@"Open - close at %@", @""), [MWZUIOpeningHoursUtils getFormattedHours:closingInterval.close]];
            }
            else {
                if (closingInterval.day - currentInterval.day == 1 || closingInterval.day - currentInterval.day == 6) {
                    return [NSString stringWithFormat:NSLocalizedString(@"Open - close tomorrow at %@", @""), [MWZUIOpeningHoursUtils getFormattedHours:closingInterval.close]];
                }
                else {
                    return [NSString stringWithFormat:NSLocalizedString(@"Open - close %@ at %@", @""), [MWZUIOpeningHoursUtils getDayName:closingInterval.day], [MWZUIOpeningHoursUtils getFormattedHours:closingInterval.close]];
                }
                
            }
        }
        else {
            return NSLocalizedString(@"Opened 24/7", @"");
        }
    }
    else {
        MWZUIOpeningInterval* openingInterval = [MWZUIOpeningHoursUtils getNextOpeningIntervalFromIntervals:intervals day:weekday minuts:currentMin];
        if (openingInterval) {
            if (openingInterval == currentInterval) {
                return [NSString stringWithFormat:NSLocalizedString(@"Close - open at %@", @""), [MWZUIOpeningHoursUtils getFormattedHours:openingInterval.open]];
            }
            else {
                if (openingInterval.day - currentInterval.day == 1 || openingInterval.day - currentInterval.day == 6) {
                    return [NSString stringWithFormat:NSLocalizedString(@"Close - open tomorrow at %@", @""), [MWZUIOpeningHoursUtils getFormattedHours:openingInterval.open]];
                }
                else {
                    return [NSString stringWithFormat:NSLocalizedString(@"Close - open %@ at %@", @""), [MWZUIOpeningHoursUtils getDayName:openingInterval.day], [MWZUIOpeningHoursUtils getFormattedHours:openingInterval.open]];
                }
                
            }
        }
        else {
            return NSLocalizedString(@"Closed 24/7", @"");
        }
    }
    
    return @"";
}

+ (NSString*) getDayName:(NSInteger)day {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *daySymbols = dateFormatter.standaloneWeekdaySymbols;
    return daySymbols[(day + 6) % 7];
}

+ (NSString*) getFormattedHours:(NSInteger)minuts {
    NSDateComponents *c = [[NSDateComponents alloc] init];
    [c setHour: minuts / 60];
    [c setMinute: minuts % 60];
    [[NSCalendar currentCalendar] setTimeZone: [NSTimeZone defaultTimeZone]];

    NSDate *yourFullNSDateObject = [[NSCalendar currentCalendar] dateFromComponents:c];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    return [dateFormatter stringFromDate:yourFullNSDateObject];
}

+ (MWZUIOpeningInterval*) getNextOpeningIntervalFromIntervals:(NSArray<MWZUIOpeningInterval*>*)intervals
                                                          day:(NSInteger)day
                                                          minuts:(NSInteger)minuts {
    for (MWZUIOpeningInterval* interval in intervals) {
        if (interval.day == day && interval.open < minuts && interval.close < minuts) {
            return interval;
        }
        else if (interval.day != day) {
            return interval;
        }
    }
    return nil;
}

+ (MWZUIOpeningInterval*) getNextCloseIntervalFromIntervals:(NSArray<MWZUIOpeningInterval*>*)intervals
                                            currentInterval:(MWZUIOpeningInterval*)currentInterval {
    if (currentInterval.close != 23 * 60 + 59) {
        return currentInterval;
    }
    NSUInteger index = [intervals indexOfObject:currentInterval];
    for (int i=0; i<intervals.count; i++) {
        MWZUIOpeningInterval* nextInterval = intervals[(i + index) % intervals.count];
        if (nextInterval.close != 23 * 60 + 59) {
            return nextInterval;
        }
    }
    return nil;
}

+ (MWZUIOpeningInterval*) getIntervalIfOpenFromIntervals:(NSArray<MWZUIOpeningInterval*>*)intervals day:(NSInteger)day minuts:(NSInteger)minuts {
    for (MWZUIOpeningInterval* interval in intervals) {
        if (day == interval.day && minuts > interval.open && minuts < interval.close) {
            return interval;
        }
    }
    return nil;
}

+ (NSArray<MWZUIOpeningInterval*>*) sortIntervals:(NSArray<MWZUIOpeningInterval*>*)input day:(NSInteger)day minuts:(NSInteger)minuts {
    NSArray<MWZUIOpeningInterval*>* sortedIntervals = [input sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MWZUIOpeningInterval* int1 = obj1;
        MWZUIOpeningInterval* int2 = obj2;
        if (int1.day == int2.day) {
            return int1.open < int2.open;
        }
        return int1.day < int2.day;
    }];
    
    int index = -1;
    for (int i=0; i<sortedIntervals.count; i++) {
        if (sortedIntervals[i].day > day) {
            index = i-1;
            break;
        }
    }
    
    if (index == -1) {
        return sortedIntervals;
    }
    
    NSMutableArray<MWZUIOpeningInterval*>* result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:[sortedIntervals subarrayWithRange:NSMakeRange(0, index)]];
    [result addObjectsFromArray:[sortedIntervals subarrayWithRange:NSMakeRange(index, sortedIntervals.count - index)]];
    
    return result;
}

+ (NSArray<MWZUIOpeningInterval*>*) buildIntervals:(NSArray<NSDictionary*>*)input {
    NSMutableArray<MWZUIOpeningInterval*>* output = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in [MWZUIOpeningHoursUtils convertStringOpeningHoursToMinuts:input]) {
        [output addObject:[[MWZUIOpeningInterval alloc] initWithDay:[dic[@"day"] longValue] open:[dic[@"open"] longValue] close:[dic[@"close"] longValue]]];
    }
    return output;
}

+ (NSDictionary*) getNextCloseTime:(NSDictionary<NSNumber*, NSArray*>*)input day:(NSInteger)day minuts:(NSInteger)minuts {
    NSMutableArray<NSNumber*>* dayIndex = [[NSMutableArray alloc] init];
    for (int i=0; i<7; i++) {
        [dayIndex addObject:[NSNumber numberWithLong:(i + day) % 7]];
    }
    NSDictionary* currentInterval;
    for (NSDictionary* dic in input) {
        if ([dic[@"open"] intValue] <= minuts && [dic[@"close"] intValue] > minuts) {
            currentInterval = dic;
        }
    }
    if ([currentInterval[@"close"] intValue] != 2359) {
        return currentInterval;
    }
    for (NSNumber* index in dayIndex) {
        NSArray<NSDictionary*>* openingHours = input[index];
        for (NSDictionary* nextInterval in openingHours) {
            if ([nextInterval[@"close"] intValue] != 2359 && currentInterval != nextInterval) {
                return nextInterval;
            }
        }
    }
    
    return @{};
}

+ (BOOL) isOpenToday:(NSArray<NSDictionary*>*) input minuts:(NSInteger)minuts {
    for (NSDictionary* dic in input) {
        if ([dic[@"open"] intValue] <= minuts && [dic[@"close"] intValue] > minuts) {
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary<NSNumber*, NSArray*>*) convertToOpeningByDay:(NSArray<NSDictionary*>*) input {
    NSMutableDictionary<NSNumber*, NSMutableArray*>* output = [[NSMutableDictionary alloc] init];
    for (NSDictionary* dic in [MWZUIOpeningHoursUtils convertStringOpeningHoursToMinuts:input]) {
        if (!output[dic[@"day"]]) {
            output[dic[@"day"]] = [[NSMutableArray alloc] init];
        }
        [output[dic[@"day"]] addObject:@{@"open":dic[@"open"], @"close":dic[@"close"]}];
    }
    return output;
}

+ (NSArray<NSDictionary*>*) convertStringOpeningHoursToMinuts:(NSArray<NSDictionary*>*) input {
    NSMutableArray<NSDictionary*>* output = [[NSMutableArray alloc] initWithCapacity:input.count];
    for (NSDictionary* dic in input) {
        [output addObject:[MWZUIOpeningHoursUtils convertStringOpeningHourToMinuts:dic]];
    }
    return output;
}

+ (NSDictionary*) convertStringOpeningHourToMinuts:(NSDictionary*) input {
    return @{
        @"day":input[@"day"],
        @"open":[NSNumber numberWithLong:[MWZUIOpeningHoursUtils convertStringToMinuts:input[@"open"]]],
        @"close":[NSNumber numberWithLong:[MWZUIOpeningHoursUtils convertStringToMinuts:input[@"close"]]]
    };
}

+ (NSInteger) convertStringToMinuts:(NSString*) input {
    NSInteger hours = [[input substringWithRange:NSMakeRange(0, 2)] intValue];
    NSInteger minutes = [[input substringWithRange:NSMakeRange(3, 2)] intValue];
    return hours * 60 + minutes;
}

@end
