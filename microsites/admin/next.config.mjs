import micrositeConfig from '../../micro-config.json' with {type: "json"};

const BASE_PREFIX_FOR_APP = micrositeConfig.admin.micrositeConfig.assetPrefix;
const BASE_PATH_FOR_APP = micrositeConfig.admin.micrositeConfig.basePath

const nextConfig = {
    assetPrefix: BASE_PREFIX_FOR_APP,
    basePath: BASE_PATH_FOR_APP,
    output: "standalone",
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
