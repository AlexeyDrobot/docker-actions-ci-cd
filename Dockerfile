FROM node:18-alpine3.16 AS builder
# set the working directory to /app inside the container
WORKDIR /app
# copy all from current path to WORKDIR
COPY . .
# install dependencies (npm ci makes sure the exact versions in the lockfile gets installed)
RUN npm ci
# build the app
RUN npm run build

# bundle static assets with nginx
FROM nginx:1.23.3-alpine AS production
ENV NODE_ENV production
# copy built assets from `builder` image
COPY --from=builder /app/dist /usr/share/nginx/html
# add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
# expose port
EXPOSE 80
# start nginx
CMD ["nginx", "-g", "daemon off;"]