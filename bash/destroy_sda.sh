#This will erase everything on your disk, overwriting it with random data
head -c 32 /dev/urandom | openssl enc -rc4 -nosalt -in /dev/zero -pass stdin | dd of=/dev/sda bs=1M
