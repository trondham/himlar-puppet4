#/bin/bash

# Example run ./patch.sh compute

if [ ! $(which patch) ];then
        yum install -y -q patch
fi

component=$1

patches=$(find ${component}/ -type f)

for p in $patches; do
  (cd / && patch -p1) < $p
done

# Run bash.sh
if [ -f script/${component}.sh ]; then
  script/${component}.sh
fi

