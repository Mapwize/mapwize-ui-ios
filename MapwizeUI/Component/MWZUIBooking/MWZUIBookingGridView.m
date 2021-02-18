#import "MWZUIBookingGridView.h"

@interface MWZUIBookingGridView ()

@property (nonatomic, assign) double gridWidth;
@property (nonatomic, assign) double hours;
@property (nonatomic) NSArray<MWZPlaceDetailsEvent*>* events;

@end

@implementation MWZUIBookingGridView

- (instancetype)initWithFrame:(CGRect)frame gridWidth:(double)gridWidth color:(nonnull UIColor *)color
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, gridWidth*24, 130)];
    if (self) {
        _color = color;
        self.gridWidth = gridWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setCurrentTime:(double)hours events:(NSArray<MWZPlaceDetailsEvent*>*)events {
    _hours = hours;
    _events = events;
    [self drawRect:self.frame];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);

    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0f);

    CGContextMoveToPoint(context, 0.0f, rect.size.height - 20); //start at this point
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 20); //draw to this point
    
    CGContextStrokePath(context);
    
    //context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);
    for (int i=0; i<24; i++) {
        if (i != 0) {
            CGContextMoveToPoint(context, i*_gridWidth, rect.size.height - 20); //start at this point
            CGContextAddLineToPoint(context, i*_gridWidth, rect.size.height - 15); //draw to this point
        }
        //UIFont* font = [UIFont fontWithName:@"Arial" size:72];
        UIColor* textColor = [UIColor lightGrayColor];
        NSDictionary* stringAttrs = @{ /*NSFontAttributeName : font, */NSForegroundColorAttributeName : textColor };

        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dh", i] attributes:stringAttrs];

        [attrStr drawAtPoint:CGPointMake(i*_gridWidth+2, rect.size.height - 20)];
        CGContextStrokePath(context);
    }

    
    for (MWZPlaceDetailsEvent* event in _events) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *startDate = [dateFormatter dateFromString: event.start];
        NSDate *endDate = [dateFormatter dateFromString: event.end];

        
        NSDate* startOfDay = [self getStartOfDay];
        NSDate* endOfDay = [self getEndOfDay];
        if ([startDate timeIntervalSinceDate:endOfDay] > 0 || [endDate timeIntervalSinceDate:startOfDay] < 0) {
            continue;
        }
        
        NSDateComponents *startCoponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
        NSDateComponents *endCoponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate];
        
        double startTime = [startCoponents hour] + [startCoponents minute] / 60.0;
        double endTime = [endCoponents hour] + [endCoponents minute] / 60.0;
        if (![[NSCalendar currentCalendar] isDateInToday:startDate]) {
            startTime = 0;
        }
        if (![[NSCalendar currentCalendar] isDateInToday:endDate]) {
            endTime = 23.99;
        }
        CGContextSetFillColorWithColor(context, _color.CGColor);
        
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(startTime*_gridWidth, 10, (endTime-startTime)*_gridWidth, 100 - 1) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)] fill];
        
    }
    
    // and now draw the Path!
    context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.3 alpha:1].CGColor);

    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0f);

    if (_hours != -1) {
        double time = _hours * _gridWidth;
        CGContextMoveToPoint(context, time, rect.size.height - 5); //start at this point
        CGContextAddLineToPoint(context, time, 0); //draw to this point
    }
    CGContextStrokePath(context);
    
}

- (NSDate*) getStartOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay
                                               fromDate:[NSDate date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

- (NSDate*) getEndOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay
                                               fromDate:[NSDate date]];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:0];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

@end
