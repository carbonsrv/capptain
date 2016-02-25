#######################
# CApptain Dockerfile #
#######################

FROM carbonsrv/carbon

MAINTAINER Adrian "vifino" Pistol

# Make /pwd a volume, so you can bind it
VOLUME ["/apps"]
WORKDIR /apps

# Put the source in that directory.
COPY . /capptain

# Run cobalt
ENTRYPOINT ["/usr/bin/carbon", "-root=/capptain", "-config=/capptain/capptain.conf", "/capptain/capptain.lua"]
CMD ["/apps"]
