/**
 * Rate Limiter Implementation
 * Uses a Token Bucket algorithm to limit request rates.
 * 支持全局限流和基于 IP 的限流。
 */

import logger from './logger.js';

class TokenBucket {
    constructor(capacity, refillRate) {
        this.capacity = capacity;
        this.tokens = capacity;
        this.refillRate = refillRate; // tokens per second
        this.lastRefill = Date.now();
    }

    refill() {
        const now = Date.now();
        const elapsed = (now - this.lastRefill) / 1000;
        if (elapsed > 0) {
            const newTokens = elapsed * this.refillRate;
            this.tokens = Math.min(this.capacity, this.tokens + newTokens);
            this.lastRefill = now;
        }
    }

    tryConsume(amount = 1) {
        this.refill();
        if (this.tokens >= amount) {
            this.tokens -= amount;
            return true;
        }
        return false;
    }
}

class RateLimiter {
    constructor(options = {}) {
        this.enabled = options.enabled !== false;

        // 全局限流配置
        this.globalLimit = options.globalLimit || 100; // 默认每秒 100 个请求
        this.globalBucket = new TokenBucket(this.globalLimit, this.globalLimit);

        // IP 限流配置
        this.ipLimit = options.ipLimit || 20; // 默认每 IP 每秒 20 个请求
        this.ipBuckets = new Map();

        // 清理间隔 (每 5 分钟清理一次不活跃的 IP)
        this.cleanupInterval = setInterval(() => this.cleanup(), 5 * 60 * 1000);
    }

    /**
     * 检查请求是否被允许
     * @param {string} ip - 客户端 IP
     * @returns {boolean} - true 表示通过，false 表示被限流
     */
    check(ip) {
        if (!this.enabled) return true;

        // 1. 检查全局限流
        if (!this.globalBucket.tryConsume()) {
            logger.warn(`[RateLimit] Global limit exceeded. Current tokens: ${this.globalBucket.tokens.toFixed(2)}`);
            return false;
        }

        // 2. 检查 IP 限流
        if (ip) {
            let bucket = this.ipBuckets.get(ip);
            if (!bucket) {
                bucket = new TokenBucket(this.ipLimit, this.ipLimit);
                this.ipBuckets.set(ip, bucket);
            }

            if (!bucket.tryConsume()) {
                logger.warn(`[RateLimit] IP limit exceeded for ${ip}. Current tokens: ${bucket.tokens.toFixed(2)}`);
                return false;
            }
        }

        return true;
    }

    /**
     * 清理长期未使用的 IP 桶以释放内存
     */
    cleanup() {
        const now = Date.now();
        for (const [ip, bucket] of this.ipBuckets.entries()) {
            // 如果超过 1 分钟没有 refill (说明没有请求)，则移除
            if (now - bucket.lastRefill > 60 * 1000) {
                this.ipBuckets.delete(ip);
            }
        }
    }

    /**
     * 销毁实例，清除定时器
     */
    destroy() {
        clearInterval(this.cleanupInterval);
    }

    /**
     * 更新配置
     */
    updateConfig(config) {
        if (config.enabled !== undefined) this.enabled = config.enabled;
        if (config.globalLimit) {
            this.globalLimit = config.globalLimit;
            this.globalBucket = new TokenBucket(this.globalLimit, this.globalLimit);
        }
        if (config.ipLimit) {
            this.ipLimit = config.ipLimit;
            // 清空旧的 IP 桶，使用新限制重建
            this.ipBuckets.clear();
        }
    }
}

// 单例实例
let rateLimiterInstance = null;

export function getRateLimiter(config = {}) {
    if (!rateLimiterInstance) {
        rateLimiterInstance = new RateLimiter(config);
    }
    return rateLimiterInstance;
}

export default RateLimiter;
