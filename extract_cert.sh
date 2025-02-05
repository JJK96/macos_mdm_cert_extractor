#!/usr/bin/env bash
# Some settings
pass="$1"
export_pass=
output_dir=$(mktemp -d)
echo "$output_dir"

function cleanup() {
    rm -rf "$output_dir"
}

trap cleanup EXIT 

python3 -m chainbreaker -o "$output_dir" --password "$pass" ~/Library/Keychains/login.keychain-db --export-private-keys --export-x509-certificates
for cert in $output_dir/certificates/*.crt; do
    cert_output=$(openssl x509 -noout -text -in "$cert" )
    if echo "$cert_output" | grep -q MS-Organization-Access; then
        found_cert="$cert"
        break
    fi
done
if [ -z "$found_cert" ]; then
    >&2 echo "Error: Did not find MDM certificate"
    exit 1
fi
echo "Found MDM cert: $found_cert"
cert_modulus=$(openssl x509 -modulus -noout -in $found_cert)
for k in $output_dir/keys/private/*; do
    key_modulus=$(openssl rsa -modulus -noout -in $k)
    if [ "$cert_modulus" = "$key_modulus" ]; then
        found_key="$k"
        break
    fi
done
if [ -z "$found_key" ]; then
    >&2 echo "Error: Did not find corresponding key"
    exit 1
fi
echo "Found corresponding key: $found_key"
openssl rsa -inform DER -outform PEM -in "$found_key" -out "$found_key.pem"
openssl pkcs12 -in "$found_cert" -inkey "$found_key.pem" -export -out mdm.p12 -passout "pass:$export_pass"
