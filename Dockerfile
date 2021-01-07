FROM rubylang/ruby:2.6.2-bionic

RUN apt-get update -y && \
	  apt-get install -y apt-utils \
		openjdk-8-jre \
		openjdk-8-jdk \
		nano \ 
		ant \
		unzip \
		wget \
		git \
    gcc \
    mono-mcs \
		nodejs

RUN rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ENV RUBY_PATHS /gem_path

ENV BUNDLE_PATH ${RUBY_PATHS}
ENV GEM_PATH ${RUBY_PATHS}
ENV GEM_HOME ${RUBY_PATHS}

RUN mkdir $RUBY_PATHS

USER root

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
ENV $GEM_PATH bundle show stanford-core-nlp
ENV CORE_NLP_JAVA_PATH ${GEM_PATH}/gems/stanford-core-nlp-0.5.3/bin

ADD stanford-corenlp-full-2014-10-31.zip $APP_HOME
RUN unzip stanford-corenlp-full-2014-10-31.zip; \
	mv stanford-corenlp-full-2014-10-31/* $CORE_NLP_JAVA_PATH;

ADD stanford-postagger-full-2014-10-26.zip $APP_HOME
RUN unzip stanford-postagger-full-2014-10-26.zip; \
	mv stanford-postagger-full-2014-10-26/* ${CORE_NLP_JAVA_PATH}/taggers/;

ADD jars/* $CORE_NLP_JAVA_PATH/

ADD . $APP_HOME

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]