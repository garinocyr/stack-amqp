#
# From https://stackoverflow.com/questions/41306350/how-to-generate-password-hash-for-rabbitmq-management-http-api
#      https://www.rabbitmq.com/passwords.html#computing-password-hash
#
#!/usr/bin/env sh

function compute_password_hash() {
  # 1) Generate a random 32 bit salt
  salt=$(od -A n -t x -N 4 /dev/urandom)
  # 2) Concatenate the generated salt with the UTF-8 representation of the desired password
  password_hash=${salt}$(echo -n $1 | xxd -ps | tr -d '\n' | tr -d ' ')
  # 3) Take the hash
  password_hash=$(echo -n ${password_hash} | xxd -r -p | sha256sum | head -c 128)
  # 4) Concatenate the salt again and convert the value to base64 encoding
  password_hash=$(echo -n ${salt}${password_hash} | xxd -r -p | base64 | tr -d '\n')
  echo ${password_hash}
}

compute_password_hash $@
