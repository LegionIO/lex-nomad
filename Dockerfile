FROM legionio/legion

COPY . /usr/src/app/lex-nomad

WORKDIR /usr/src/app/lex-nomad
RUN bundle install
