FROM fedora-minimal:latest

WORKDIR /work

RUN microdnf install --assumeyes findutils git-core make pandoc python3-pip ruby

RUN gem install bundler

RUN bundle install

RUN pip install -r requirements.txt
