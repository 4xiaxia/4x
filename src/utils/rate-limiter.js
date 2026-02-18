import logger from './logger.js';

export class RateLimiter {
    constructor(config = {}) {
        this.enabled = config.enabled !== false;
        this.globalLimit = config.globalLimit || 100; // Total tokens per second
        this.ipLimit = config.ipLimit || 20;         // Tokens per second per IP
        this.refillRate = 1000; // Refill every 1000ms

        this.tokens = this.globalLimit;
        this.ipBuckets = new Map();

        this.lastRefill = Date.now();
    }

    _refill() {
        const now = Date.now();
        const elapsed = now - this.lastRefill;

        if (elapsed > this.refillRate) {
            // Reset global tokens
            this.tokens = this.globalLimit;

            // Reset/Cleanup IP buckets
            // For simplicity in this implementation, we just clear the map or refill
            // To be more robust, we could refill based on time, but resetting per second is easier for "Limit per second"
            this.ipBuckets.clear();

            this.lastRefill = now;
        }
    }

    check(ip) {
        if (!this.enabled) return true;

        this._refill();

        if (this.tokens <= 0) {
            logger.warn(`[RateLimit] Global limit exceeded. Current tokens: ${this.tokens}`);
            return false;
        }

        let ipTokens = this.ipBuckets.get(ip);
        if (ipTokens === undefined) {
            ipTokens = this.ipLimit;
        }

        if (ipTokens <= 0) {
            logger.warn(`[RateLimit] IP limit exceeded for ${ip}. Current tokens: ${ipTokens}`);
            return false;
        }

        this.tokens--;
        this.ipBuckets.set(ip, ipTokens - 1);
        return true;
    }
}

let instance = null;

export function getRateLimiter(config) {
    if (!instance) {
        instance = new RateLimiter(config);
    }
    return instance;
}
