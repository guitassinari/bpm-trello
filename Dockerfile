FROM rubylang/ruby:2.6.2-bionic

RUN apt-get update -y && \
	  apt-get install -y apt-utils \
		openjdk-8-jre \
		openjdk-8-jdk \
		ant \
		unzip \
		wget \
		git \
    gcc \
    mono-mcs \
		nodejs

RUN rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# https://github.com/arton/rjb/issues/70
# RUN ln -s /usr/lib/jvm/java-10-openjdk-amd64/lib/server /usr/lib/jvm/java-11-openjdk-amd64/jre/lib/amd64/server

ENV RUBY_PATHS /box

ENV BUNDLE_PATH ${RUBY_PATHS}
ENV GEM_PATH ${RUBY_PATHS}
ENV GEM_HOME ${RUBY_PATHS}

RUN mkdir RUBY_PATHS

USER root

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

ENV $GEM_PATH bundle show stanford-core-nlp

RUN unzip stanford-postagger-full-2014-10-26.zip; \
	mv stanford-postagger-full-2014-10-26/* ${GEM_PATH}/gems/stanford-core-nlp-0.5.3/bin/;

EXPOSE 3000

ENTRYPOINT ["bundle", "exec", "rails", "server"]
CMD ["-p", "3000", "-b", "0.0.0.0"]