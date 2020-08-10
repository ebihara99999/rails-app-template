FROM ruby:2.6.6 AS nodejs

WORKDIR /tmp

RUN curl -LO https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-x64.tar.xz
RUN tar xvf node-v12.14.1-linux-x64.tar.xz
RUN mv node-v12.14.1-linux-x64 node

FROM ruby:2.6.6

COPY --from=nodejs /tmp/node /opt/node
ENV PATH /opt/node/bin:$PATH

# TODO
# Install a browser to support system spec
# ref: https://github.com/CircleCI-Public/circleci-dockerfiles/blob/master/ruby/images/2.6.6-stretch/node-browsers/Dockerfile#L46

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH /root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:$PATH

RUN gem install bundler

WORKDIR /app

RUN bundle config set path vendor/bundle

COPY Gemfile Gemfile.lock package.json yarn.lock /app/
RUN bundle install
RUN yarn install
