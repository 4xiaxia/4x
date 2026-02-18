import { getRateLimiter } from '../utils/rate-limiter.js';
import { getProviderPoolManager } from '../services/service-manager.js';

export async function handleRiskStatsRequest(req, res) {
    const rateLimiter = getRateLimiter();
    const poolManager = getProviderPoolManager();

    const coolingProviders = [];
    if (poolManager && poolManager.providerStatus) {
        for (const type in poolManager.providerStatus) {
            const providers = poolManager.providerStatus[type];
            providers.forEach(p => {
                if (p.config.coolDownUntil) {
                    coolingProviders.push({
                        uuid: p.uuid,
                        type,
                        coolDownUntil: p.config.coolDownUntil
                    });
                }
            });
        }
    }

    const stats = {
        rateLimiter: {
            enabled: rateLimiter.enabled,
            globalLimit: rateLimiter.globalLimit,
            currentGlobalTokens: rateLimiter.tokens,
            activeIps: rateLimiter.ipBuckets.size
        },
        coolingProviders: coolingProviders
    };

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(stats, null, 2));
}
