import micrositeConfig from '../../micro-config.json' with {type: "json"};

const BASE_PREFIX_FOR_APP = micrositeConfig.login.micrositeConfig.assetPrefix;

const nextConfig = {
    assetPrefix: BASE_PREFIX_FOR_APP,
    async rewrites() {
        return [
            {
                /** ASSET, IMAGE PREFIX */
                source: `${BASE_PREFIX_FOR_APP}/_next/:path*`,
                destination: '/_next/:path*',
            },
            /** API PREFIX */
            {
                source: `${BASE_PREFIX_FOR_APP}/api/:path*`,
                destination: '/api/:path*',
            }
        ];
    },
};

export default nextConfig;
