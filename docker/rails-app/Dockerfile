# docker run --expose 3000 -it rails-app /bin/bash

FROM rails

WORKDIR /rails-app

COPY . .

EXPOSE 3000

CMD rails s -b 0.0.0.0
