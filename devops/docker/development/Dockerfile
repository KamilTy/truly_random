FROM ruby:3.0.1-alpine AS base

LABEL maintainer="Kamil<kamil@enrouteit.com.br>"

RUN apk add --update \
	postgresql-dev \
	tzdata \
	bash \
	nodejs \
	yarn

# This stage will be responsible for installing gems
FROM base AS dependencies

# Install system dependencies required to build some Ruby gems (pg)
RUN apk add --update build-base && \
    rm -rf /var/cache/apk/*

# Application dependencies
COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.2.25 && bundle install --jobs $(nproc) --retry 5

COPY package.json yarn.lock ./

# Install npm packages
RUN yarn install --frozen-lockfile

# We're back at the base stage
FROM base

ARG USER_NAME=app-user
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a non-root user to run the app and own app-specific files
# RUN adduser --disabled-password --gecos '' $UNAME
RUN addgroup -g $GROUP_ID $USER_NAME
RUN adduser --disabled-password --gecos '' -u $USER_ID -G $USER_NAME $USER_NAME

# Switch to this user
USER $USER_NAME

# We'll install the app in this directory
WORKDIR /home/$USER_NAME/app

# Copy over gems from the dependencies stage
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

# Copy over npm packages from the dependencies stage
# Note that we have to use `--chown` here
COPY --chown=$USER_NAME --from=dependencies /node_modules/ node_modules/

# Finally, copy over the code
# This is where the .dockerignore file comes into play
# Note that we have to use `--chown` here
COPY --chown=$USER_NAME . ./

COPY --chown=$USER_NAME devops/docker/development/entry-point.sh /entry-point.sh

ENTRYPOINT ["sh", "/entry-point.sh"]

# Launch the server
CMD ["rails", "s", "-b",  "0.0.0.0"]
