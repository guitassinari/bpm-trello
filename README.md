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