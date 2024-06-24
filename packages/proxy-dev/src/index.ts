//import * as https from "https";
import * as http from "http";
//import * as fs from "fs";
import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";
//import path from "path";
import type { Config } from "./types";

// SSL certificate
/*const key = fs.readFileSync(
  path.join(__dirname, "../certs/ale-poc.example-key.pem"),
);
const cert = fs.readFileSync(
  path.join(__dirname, "../certs/ale-poc.example.pem"),
);
const credentials: { key: Buffer; cert: Buffer } = { key, cert };
*/

// Config microsite proxy
import config from "../../../micro-config.json"; // Adjust type if possible
const app = express();

const typedConfig = config as Config;
const customRouter = function (req: { path: string; host: string }) {
  const microsite = Object.keys(typedConfig).find((key) => {
    if (typedConfig[key]) {
      const devServerPath = typedConfig[key].webServerConfig.path;
      const isValid = req.path.includes(devServerPath);
      if (isValid) {
        console.log(
          `Found this microsite: ${key} for path: ${req.path} and devServerPath: ${devServerPath})`,
        );
      }
      return isValid;
    }
  });
  if (microsite) {
    const port = typedConfig[microsite].micrositeConfig.port;
    const url = `http://localhost:${port}`;
    console.log(`Found this microsite: ${microsite}. Redirecting to ${url}`);
    return url;
  }
};

const options = {
  router: customRouter,
};

const myProxy = createProxyMiddleware(options);
app.use(myProxy);

// Create HTTPS server
const httpsServer = http.createServer(/*credentials,*/ app);
const HTTPS_PORT = 8443;

httpsServer.listen(HTTPS_PORT, () => {
  console.log(`HTTP proxy server running at http://localhost:${HTTPS_PORT}`);
});
