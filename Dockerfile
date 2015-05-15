FROM phusion/passenger-ruby22:latest

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Install nginx config files
RUN rm /etc/nginx/sites-enabled/default
ADD docker/nginx_server.conf /etc/nginx/sites-enabled/garagehelper.conf
ADD docker/nginx_env.conf /etc/nginx/main.d/env.conf

# Set Default RAILS_ENV
ENV PASSENGER_APP_ENV docker

# Setup directory and install gems
RUN mkdir -p /home/app/garagehelper/
COPY Gemfile /home/app/garagehelper/
COPY Gemfile.lock /home/app/garagehelper/
RUN cd /home/app/garagehelper/ && bundle install

# Copy the app into the image
COPY . /home/app/garagehelper/
WORKDIR /home/app/garagehelper/

# Set log permissions
RUN mkdir -p /home/app/garagehelper/log
RUN chmod 0777 /home/app/garagehelper/log

# Compile assets
RUN env RAILS_ENV=production bundle exec rake assets:clobber assets:precompile

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*