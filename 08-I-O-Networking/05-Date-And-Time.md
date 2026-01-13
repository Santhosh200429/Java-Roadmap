# Java Date and Time API (java.time)

## Why a New Date/Time API?

**Old approach** (java.util.Date, Calendar):
- Mutable and not thread-safe
- Confusing API (months 0-indexed, years since 1900)
- No timezone support

**New approach** (java.time package, Java 8+):
- Immutable and thread-safe
- Clear, intuitive API
- Full timezone support

## Core Classes

```
LocalDate       - Date only (2024-01-15)
LocalTime       - Time only (14:30:45)
LocalDateTime   - Date + Time (2024-01-15 14:30:45)
ZonedDateTime   - Date + Time + Timezone
Instant         - Moment in UTC time
Duration        - Amount of time between two points
Period          - Amount of time in days/months/years
```

## LocalDate

### Creating Dates

```java
import java.time.*;

public class DateExamples {
    
    public static void main(String[] args) {
        // Create from components
        LocalDate date1 = LocalDate.of(2024, 1, 15);
        LocalDate date2 = LocalDate.of(2024, Month.JANUARY, 15);
        
        // Today's date
        LocalDate today = LocalDate.now();
        System.out.println("Today: " + today);
        
        // Parse from string
        LocalDate parsed = LocalDate.parse("2024-01-15");
        System.out.println("Parsed: " + parsed);
        
        // First/last day of month
        LocalDate lastDay = today.withDayOfMonth(
            today.getMonth().length(today.isLeapYear())
        );
        System.out.println("Last day of month: " + lastDay);
    }
}

// Output:
// Today: 2024-01-15
// Parsed: 2024-01-15
// Last day of month: 2024-01-31
```

### Working with Dates

```java
LocalDate date = LocalDate.of(2024, 1, 15);

// Get components
System.out.println("Year: " + date.getYear());           // 2024
System.out.println("Month: " + date.getMonth());         // JANUARY
System.out.println("Day: " + date.getDayOfMonth());      // 15
System.out.println("Day of week: " + date.getDayOfWeek()); // MONDAY

// Arithmetic
LocalDate future = date.plusDays(10);
System.out.println("In 10 days: " + future);             // 2024-01-25

LocalDate past = date.minusMonths(1);
System.out.println("1 month ago: " + past);              // 2023-12-15

// Comparisons
if (date.isBefore(LocalDate.now())) {
    System.out.println("Date is in past");
}

if (date.isAfter(LocalDate.of(2024, 1, 1))) {
    System.out.println("Date is after Jan 1");
}
```

## LocalTime

### Creating Times

```java
import java.time.*;

public class TimeExamples {
    
    public static void main(String[] args) {
        // Create from components
        LocalTime time1 = LocalTime.of(14, 30, 45);
        LocalTime time2 = LocalTime.of(14, 30);
        
        // Current time
        LocalTime now = LocalTime.now();
        System.out.println("Now: " + now);
        
        // Parse from string
        LocalTime parsed = LocalTime.parse("14:30:45");
        System.out.println("Parsed: " + parsed);
        
        // Midnight/noon
        LocalTime midnight = LocalTime.MIDNIGHT;
        LocalTime noon = LocalTime.NOON;
        System.out.println("Midnight: " + midnight);
        System.out.println("Noon: " + noon);
    }
}

// Output:
// Now: 14:30:45.123456
// Parsed: 14:30:45
// Midnight: 00:00:00
// Noon: 12:00:00
```

### Working with Times

```java
LocalTime time = LocalTime.of(14, 30, 45);

// Get components
System.out.println("Hour: " + time.getHour());           // 14
System.out.println("Minute: " + time.getMinute());       // 30
System.out.println("Second: " + time.getSecond());       // 45

// Arithmetic
LocalTime later = time.plusHours(2);
System.out.println("2 hours later: " + later);           // 16:30:45

LocalTime earlier = time.minusMinutes(15);
System.out.println("15 minutes earlier: " + earlier);    // 14:15:45
```

## LocalDateTime

### Creating DateTimes

```java
import java.time.*;

public class DateTimeExamples {
    
    public static void main(String[] args) {
        // Combine date and time
        LocalDate date = LocalDate.of(2024, 1, 15);
        LocalTime time = LocalTime.of(14, 30);
        LocalDateTime dateTime = LocalDateTime.of(date, time);
        
        // Create directly
        LocalDateTime dt = LocalDateTime.of(2024, 1, 15, 14, 30, 45);
        
        // Current date and time
        LocalDateTime now = LocalDateTime.now();
        System.out.println("Now: " + now);
        
        // Parse from string
        LocalDateTime parsed = LocalDateTime.parse("2024-01-15T14:30:45");
        System.out.println("Parsed: " + parsed);
    }
}

// Output:
// Now: 2024-01-15T14:30:45.123456
// Parsed: 2024-01-15T14:30:45
```

### Working with DateTimes

```java
LocalDateTime dt = LocalDateTime.of(2024, 1, 15, 14, 30);

// Get date/time parts
LocalDate date = dt.toLocalDate();
LocalTime time = dt.toLocalTime();

// Get specific fields
System.out.println("Year: " + dt.getYear());
System.out.println("Month: " + dt.getMonth());
System.out.println("Hour: " + dt.getHour());

// Arithmetic
LocalDateTime future = dt.plusDays(5).plusHours(2);
System.out.println("5 days, 2 hours later: " + future);

// Comparisons
LocalDateTime deadline = LocalDateTime.of(2024, 2, 1, 17, 0);
if (dt.isBefore(deadline)) {
    System.out.println("Before deadline");
}
```

## ZonedDateTime (Timezones)

### Working with Timezones

```java
import java.time.*;

public class TimezoneExamples {
    
    public static void main(String[] args) {
        // Get available zones
        ZoneId.getAvailableZoneIds().stream()
            .filter(z -> z.contains("America"))
            .forEach(System.out::println);
        
        // Create zoned datetime
        LocalDateTime dt = LocalDateTime.of(2024, 1, 15, 14, 30);
        
        // Add timezone
        ZoneId ny = ZoneId.of("America/New_York");
        ZonedDateTime nyTime = dt.atZone(ny);
        System.out.println("NY time: " + nyTime);
        
        // Current time in specific zone
        ZoneId tokyo = ZoneId.of("Asia/Tokyo");
        ZonedDateTime tokyoTime = ZonedDateTime.now(tokyo);
        System.out.println("Tokyo time: " + tokyoTime);
        
        // Convert between timezones
        ZonedDateTime londonTime = nyTime.withZoneSameInstant(
            ZoneId.of("Europe/London")
        );
        System.out.println("London time: " + londonTime);
    }
}

// Output:
// America/Adak
// America/Anchorage
// America/Chicago
// ...
// NY time: 2024-01-15T14:30:00-05:00[America/New_York]
// Tokyo time: 2024-01-16T03:45:30.123456+09:00[Asia/Tokyo]
// London time: 2024-01-15T19:30:00+00:00[Europe/London]
```

## Duration and Period

### Duration (Time Difference)

```java
import java.time.*;

public class DurationExample {
    
    public static void main(String[] args) {
        LocalTime start = LocalTime.of(10, 30);
        LocalTime end = LocalTime.of(14, 45);
        
        Duration duration = Duration.between(start, end);
        System.out.println("Duration: " + duration);      // PT4H15M
        System.out.println("Hours: " + duration.toHours());
        System.out.println("Minutes: " + duration.toMinutes());
        System.out.println("Seconds: " + duration.getSeconds());
        
        // Create duration
        Duration d1 = Duration.ofHours(2);
        Duration d2 = Duration.ofMinutes(30);
        Duration d3 = Duration.ofSeconds(3600);
        
        // Arithmetic
        Duration total = d1.plus(d2);
        System.out.println("Total: " + total);
        
        // Check if positive
        if (duration.isPositive()) {
            System.out.println("Positive duration");
        }
    }
}

// Output:
// Duration: PT4H15M
// Hours: 4
// Minutes: 255
// Seconds: 15300
// Total: PT2H30M
// Positive duration
```

### Period (Date Difference)

```java
import java.time.*;

public class PeriodExample {
    
    public static void main(String[] args) {
        LocalDate start = LocalDate.of(2020, 1, 15);
        LocalDate end = LocalDate.of(2024, 1, 15);
        
        Period period = Period.between(start, end);
        System.out.println("Period: " + period);          // P4Y
        System.out.println("Years: " + period.getYears());
        System.out.println("Months: " + period.getMonths());
        System.out.println("Days: " + period.getDays());
        
        // Create period
        Period p1 = Period.ofYears(2);
        Period p2 = Period.ofMonths(3);
        Period p3 = Period.ofDays(10);
        
        // Add to date
        LocalDate futureDate = LocalDate.now().plus(p1).plus(p2);
        System.out.println("Future date: " + futureDate);
    }
}

// Output:
// Period: P4Y
// Years: 4
// Months: 0
// Days: 0
// Future date: 2026-04-15
```

## Formatting Dates

### Predefined Formatters

```java
import java.time.*;
import java.time.format.*;

public class FormattingExample {
    
    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2024, 1, 15);
        LocalDateTime dateTime = LocalDateTime.of(2024, 1, 15, 14, 30, 45);
        
        // Predefined formatters
        System.out.println(date.format(DateTimeFormatter.ISO_DATE));
        // Output: 2024-01-15
        
        System.out.println(date.format(DateTimeFormatter.ISO_LOCAL_DATE));
        // Output: 2024-01-15
        
        System.out.println(dateTime.format(
            DateTimeFormatter.ISO_LOCAL_DATE_TIME
        ));
        // Output: 2024-01-15T14:30:45
    }
}
```

### Custom Formatters

```java
import java.time.*;
import java.time.format.*;

public class CustomFormatterExample {
    
    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2024, 1, 15);
        LocalDateTime dateTime = LocalDateTime.of(2024, 1, 15, 14, 30);
        
        // Custom date format
        DateTimeFormatter dateFormatter = DateTimeFormatter
            .ofPattern("dd/MM/yyyy");
        System.out.println(date.format(dateFormatter));
        // Output: 15/01/2024
        
        // Custom datetime format
        DateTimeFormatter dtFormatter = DateTimeFormatter
            .ofPattern("yyyy-MM-dd HH:mm:ss");
        System.out.println(dateTime.format(dtFormatter));
        // Output: 2024-01-15 14:30:00
        
        // With custom locale
        DateTimeFormatter frFormatter = DateTimeFormatter
            .ofPattern("d MMMM yyyy", Locale.FRENCH);
        System.out.println(date.format(frFormatter));
        // Output: 15 janvier 2024
        
        // Parse custom format
        DateTimeFormatter parser = DateTimeFormatter
            .ofPattern("dd/MM/yyyy");
        LocalDate parsed = LocalDate.parse("25/12/2024", parser);
        System.out.println("Parsed: " + parsed);
    }
}

// Common patterns:
// yyyy = year (2024)
// MM = month (01-12)
// dd = day (01-31)
// HH = hour (00-23)
// mm = minute (00-59)
// ss = second (00-59)
// E = day name (Mon, Tue)
// MMMM = full month name (January)
```

## Complete Examples

### 1. Age Calculator

```java
import java.time.*;
import java.time.temporal.*;

public class AgeCalculator {
    
    public static int calculateAge(LocalDate birthDate) {
        return (int) ChronoUnit.YEARS.between(
            birthDate, 
            LocalDate.now()
        );
    }
    
    public static void main(String[] args) {
        LocalDate birthDate = LocalDate.of(1990, 5, 15);
        
        int age = calculateAge(birthDate);
        System.out.println("Age: " + age);
        
        // Days until next birthday
        LocalDate nextBirthday = birthDate.withYear(
            LocalDate.now().getYear()
        );
        
        if (nextBirthday.isBefore(LocalDate.now())) {
            nextBirthday = nextBirthday.plusYears(1);
        }
        
        long daysUntilBirthday = ChronoUnit.DAYS.between(
            LocalDate.now(),
            nextBirthday
        );
        
        System.out.println("Days until birthday: " + daysUntilBirthday);
    }
}

// Output:
// Age: 33
// Days until birthday: 122
```

### 2. Business Hours Calculator

```java
import java.time.*;

public class BusinessHoursCalculator {
    
    public static long getBusinessMinutes(
            LocalDateTime start, 
            LocalDateTime end) {
        
        long businessMinutes = 0;
        LocalDateTime current = start;
        
        while (current.isBefore(end)) {
            // Skip weekends
            if (current.getDayOfWeek().getValue() < 6) {
                int hour = current.getHour();
                
                // Count hours between 9 AM and 5 PM
                if (hour >= 9 && hour < 17) {
                    businessMinutes++;
                }
            }
            
            current = current.plusMinutes(1);
        }
        
        return businessMinutes;
    }
    
    public static void main(String[] args) {
        LocalDateTime start = LocalDateTime.of(2024, 1, 15, 8, 0);
        LocalDateTime end = LocalDateTime.of(2024, 1, 19, 18, 0);
        
        long minutes = getBusinessMinutes(start, end);
        System.out.println("Business minutes: " + minutes);
        System.out.println("Business hours: " + (minutes / 60));
    }
}
```

### 3. Event Scheduler

```java
import java.time.*;
import java.time.format.*;

public class EventScheduler {
    
    static class Event {
        String name;
        ZonedDateTime time;
        
        Event(String name, ZonedDateTime time) {
            this.name = name;
            this.time = time;
        }
        
        boolean isUpcoming() {
            return time.isAfter(ZonedDateTime.now());
        }
        
        String getCountdown() {
            Duration until = Duration.between(
                ZonedDateTime.now(),
                time
            );
            long hours = until.toHours();
            long minutes = until.toMinutes() % 60;
            
            return String.format("%d hours, %d minutes", 
                hours, minutes);
        }
    }
    
    public static void main(String[] args) {
        ZoneId ny = ZoneId.of("America/New_York");
        
        Event event = new Event(
            "Conference",
            ZonedDateTime.of(
                LocalDateTime.of(2024, 2, 1, 14, 0),
                ny
            )
        );
        
        if (event.isUpcoming()) {
            System.out.println("Event: " + event.name);
            System.out.println("Time: " + event.time);
            System.out.println("Countdown: " + event.getCountdown());
        }
    }
}
```

## Key Takeaways

- Use java.time, not java.util.Date
- LocalDate for dates only
- LocalTime for times only
- LocalDateTime for both
- ZonedDateTime for timezone support
- Duration for time differences
- Period for date differences
- DateTimeFormatter for custom formatting
- All are immutable and thread-safe
- Use ChronoUnit for calculating time gaps

---


