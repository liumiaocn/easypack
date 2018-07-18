FROM node:9.11-alpine

ENV     ENV_NG_PROJECT_NAME ${ENV_NG_PROJECT_NAME:-hello}
WORKDIR /workspace

RUN npm install -g @angular/cli \
    npm install -g typescript   \
    npm install -g typings      \
    ng  config --global packageManager=yarn \
    ng  new ${ENV_NG_PROJECT_NAME}

CMD ng serve -H 0.0.0.0 --port=4200
