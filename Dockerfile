FROM ubuntu:latest

# Install virtualenv, nginx, supervisor
RUN apt-get update --fix-missing && apt-get install -y --allow-unauthenticated \
  build-essential \
  git \  
  python3 \
  python3-dev \
  python3-setuptools \
  python3-pip \
  nginx \
  supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/*

RUN pip3 install -U pip && pip install virtualenv && rm -rf /tmp/* /root/.cache/pip

RUN service supervisor stop

# create virtual env and install dependencies
# Due to a bug with h5 we install Cython first
RUN virtualenv /opt/venv
ADD ./requirements.txt /opt/venv/requirements.txt
RUN /opt/venv/bin/pip install Cython && /opt/venv/bin/pip install -r /opt/venv/requirements.txt && rm -rf /tmp/* /root/.cache/pip

# expose port
EXPOSE 80

# Add our config files
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./nginx.conf /etc/nginx/nginx.conf

# Copy our service code
ADD ./service /opt/app

# restart nginx to load the config
RUN service nginx stop

# start supervisor to run our wsgi server
CMD supervisord -c /etc/supervisord.conf -n

