import { RateLimiter } from '../src/utils/rate-limiter.js';

describe('RateLimiter', () => {
    let rateLimiter;

    beforeEach(() => {
        rateLimiter = new RateLimiter({
            enabled: true,
            globalLimit: 10,
            ipLimit: 5
        });
    });

    test('should allow requests within global limit', () => {
        // Use different IPs to avoid hitting IP limit (5) while testing global limit (10)
        for (let i = 0; i < 5; i++) {
            expect(rateLimiter.check('1.2.3.4')).toBe(true);
        }
        for (let i = 0; i < 5; i++) {
            expect(rateLimiter.check('5.6.7.8')).toBe(true);
        }
    });

    test('should block requests exceeding global limit', () => {
        rateLimiter.globalLimit = 2;
        rateLimiter.tokens = 2;
        expect(rateLimiter.check('1.2.3.4')).toBe(true);
        expect(rateLimiter.check('1.2.3.4')).toBe(true);
        expect(rateLimiter.check('1.2.3.4')).toBe(false);
    });

    test('should allow requests within IP limit', () => {
        for (let i = 0; i < 5; i++) {
            expect(rateLimiter.check('1.2.3.4')).toBe(true);
        }
    });

    test('should block requests exceeding IP limit', () => {
        for (let i = 0; i < 5; i++) {
            rateLimiter.check('1.2.3.4');
        }
        expect(rateLimiter.check('1.2.3.4')).toBe(false);
    });

    test('should distinguish between different IPs', () => {
        for (let i = 0; i < 5; i++) {
            rateLimiter.check('1.2.3.4');
        }
        expect(rateLimiter.check('1.2.3.4')).toBe(false);
        expect(rateLimiter.check('5.6.7.8')).toBe(true);
    });

    test('should refill tokens over time', async () => {
        rateLimiter.globalLimit = 1;
        rateLimiter.tokens = 1;

        expect(rateLimiter.check('1.2.3.4')).toBe(true);
        expect(rateLimiter.check('1.2.3.4')).toBe(false);

        // Mock time passing
        const now = Date.now();
        jest.spyOn(Date, 'now').mockReturnValue(now + 1500);

        expect(rateLimiter.check('1.2.3.4')).toBe(true);

        jest.restoreAllMocks();
    });
});
