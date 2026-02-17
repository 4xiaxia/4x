
import RateLimiter from '../src/utils/rate-limiter.js';

describe('RateLimiter', () => {
    let rateLimiter;

    beforeEach(() => {
        // Mock Date.now
        jest.useFakeTimers();
        rateLimiter = new RateLimiter({
            enabled: true,
            globalLimit: 5, // 5 requests per second
            ipLimit: 2      // 2 requests per second per IP
        });
    });

    afterEach(() => {
        rateLimiter.destroy();
        jest.useRealTimers();
    });

    test('should allow requests within global limit', () => {
        for (let i = 0; i < 5; i++) {
            expect(rateLimiter.check()).toBe(true);
        }
    });

    test('should block requests exceeding global limit', () => {
        for (let i = 0; i < 5; i++) {
            rateLimiter.check();
        }
        expect(rateLimiter.check()).toBe(false);
    });

    test('should allow requests within IP limit', () => {
        expect(rateLimiter.check('1.2.3.4')).toBe(true);
        expect(rateLimiter.check('1.2.3.4')).toBe(true);
    });

    test('should block requests exceeding IP limit', () => {
        rateLimiter.check('1.2.3.4');
        rateLimiter.check('1.2.3.4');
        expect(rateLimiter.check('1.2.3.4')).toBe(false);
    });

    test('should distinguish between different IPs', () => {
        rateLimiter.check('1.2.3.4');
        rateLimiter.check('1.2.3.4');
        expect(rateLimiter.check('1.2.3.4')).toBe(false);

        expect(rateLimiter.check('5.6.7.8')).toBe(true);
    });

    test('should refill tokens over time', () => {
        rateLimiter.check('1.2.3.4');
        rateLimiter.check('1.2.3.4');
        expect(rateLimiter.check('1.2.3.4')).toBe(false);

        // Advance time by 1 second
        jest.advanceTimersByTime(1000);

        expect(rateLimiter.check('1.2.3.4')).toBe(true);
    });
});
