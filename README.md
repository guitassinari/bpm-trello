# BPM-Trello

BPM-Trello is Guilherme's undergratuate thesis as a Computer Engineer student.

It's goal is to serve as a proof-of-concept project for extracting business process information from Trello Boards.

BPM stands for Business Process Information, a discipline in operations management focused in discovering, analying, measuring, improving, optimizing and automating business processes.


## Dependencies

1. [Java Runtime Environment](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)

Download and install the Java JDK and set `JAVA_HOME` and `PATH`. We suggest putting them
in your profile file (ex. `.bash_profile`).

2. Stanford CoreNLP

Download and install the Stanford CoreNLP according to [Louis Mullie's instructions](https://github.com/louismullie/stanford-core-nlp#installation). To use Stanford Core NLP 3.5.0, which we're using to develop this tool, you must also follow [these instructions](https://github.com/louismullie/stanford-core-nlp#using-the-latest-version-of-the-stanford-corenlp)

3. Ruby

## Running this project

### With Docker

1. Download Stanford CoreNLP and other JARS

run the following command on the project directory 

```
wget http://nlp.stanford.edu/software/stanford-corenlp-full-2014-10-31.zip &
wget http://nlp.stanford.edu/software/stanford-postagger-full-2014-10-26.zip 
```

The `joda-time.jar`, `xom.jar` and `bridge.jar` are already in the `jars` folders, so there's no need to download them. Even so, here are the commands to download them:

```
wget wget https://github.com/JodaOrg/joda-time/releases/download/v2.10.9/joda-time-2.10.9.jar &
wget http://www.java2s.com/Code/JarDownload/xom/xom-1.2.5.jar.zipw &
wget https://github.com/louismullie/stanford-core-nlp/blob/master/bin/bridge.jar
```

2. Build docker image using a tag
```
$ docker build -t bpmtrello:<tag> .
```

This should output a message like this:

```
Successfully built <docker_image_id>
Successfully tagged bpmtrello:<tag>
```

2. Run container

User the created tag to run the container

```
docker run -p 3000:3000 bpmtrello:<tag>
```

Your application should be running on `localhost:3000`

### Run with Ruby / Rails

1. Install all dependencies

2. Clone this respository

```bash
$ git clone git@github.com:guitassinari/bpm-trello.git
```

3. Install Gemfile dependencies with bundler

```
$ bundle install
```

4. Run tests to make sure everything is working

```
$ bundle exec rspec
```

5. Finally, run Rails server

```
$ bundle exec rails s
```

Now your application is running and available at `localhost:3000`

## Documentation

You can generate docs for this project using [YARD](https://yardoc.org/).
Follow YARD's installations steps and run this command inside the project's directory.

```
$ yard
```

This will generate the projects docs inside the project's directory.