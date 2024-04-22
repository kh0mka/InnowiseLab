# I think that this image to build for yarn/npm ?
FROM node:16 as build_frontend
# Default workdir in image/container
WORKDIR /app
# In this directory we are copy all files from 
# root directory (host) to WORKDIR root directory (container/image)
COPY . .
# Installing all the dependencies which described in package*.json
# and after that build and in the end - remove source code for optimize
RUN yarn install && yarn build \
    && rm -rf public src package.json package-lock.json

# Super easy
FROM nginx:alpine

WORKDIR /app

COPY --from=build_frontend /app/build /usr/share/nginx/java_app/

EXPOSE 80

COPY nginx_javaapp.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]