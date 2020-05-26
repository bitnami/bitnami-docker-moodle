#!/bin/bash

update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

if [[ $WITH_ALL_LOCALES == 1 ]]; then
  echo 'Adding all locales...'
  # see: https://stackoverflow.com/questions/38188762/generate-all-locales-in-a-docker-image#answer-38189109
  cp /usr/share/i18n/SUPPORTED /etc/locale.gen
  locale-gen
else
  echo 'en_AU.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
fi
