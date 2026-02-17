import logger from '../utils/logger.js';
import { getRateLimiter } from '../utils/rate-limiter.js';
import { getProviderPoolManager } from '../services/service-manager.js';

/**
 * Handle requests for risk statistics.
 * @param {http.IncomingMessage} req
 * @param {http.ServerResponse} res
 */
export async function handleRiskStatsRequest(req, res) {
    try {
        const rateLimiter = getRateLimiter();
        const poolManager = getProviderPoolManager();

        // 收集限流统计
        const rateLimitStats = {
            enabled: rateLimiter.enabled,
            global: {
                limit: rateLimiter.globalLimit,
                currentTokens: rateLimiter.globalBucket.tokens
            },
            ipBucketsCount: rateLimiter.ipBuckets.size
        };

        // 收集冷却中的提供商统计
        const coolingProviders = {};
        if (poolManager && poolManager.providerStatus) {
            const now = Date.now();
            for (const [type, providers] of Object.entries(poolManager.providerStatus)) {
                const cooling = providers.filter(p => {
                    return p.config.coolDownUntil && new Date(p.config.coolDownUntil).getTime() > now;
                }).map(p => ({
                    uuid: p.uuid,
                    name: p.config.customName || p.uuid,
                    until: p.config.coolDownUntil
                }));

                if (cooling.length > 0) {
                    coolingProviders[type] = cooling;
                }
            }
        }

        const stats = {
            timestamp: new Date().toISOString(),
            rateLimit: rateLimitStats,
            coolingProviders: coolingProviders
        };

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(stats));
    } catch (error) {
        logger.error(`[RiskStats] Failed to get stats: ${error.message}`);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: { message: 'Internal Server Error' } }));
    }
}
