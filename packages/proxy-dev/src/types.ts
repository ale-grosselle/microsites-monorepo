interface MicrositeConfig {
  port: number;
  assetPrefix: string;
}

export type Config = Record<
  string,
  {
    micrositeConfig: MicrositeConfig;
    webServerConfig: {
      path: string;
    };
  }
>;
