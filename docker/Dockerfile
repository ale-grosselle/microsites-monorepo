FROM node:18-alpine

RUN apk add --no-cache bash

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Run microsites
RUN echo '#!/bin/bash\n\
node /app/proxy/index.js &\n\
for app in $(jq -r ".apps | keys[]" /app/paths.json); do\n\
  cd /app/apps/$app && npm install && npm run build && npm start &\n\
done\n\
wait' > /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 4000

CMD ["/app/start.sh"]
