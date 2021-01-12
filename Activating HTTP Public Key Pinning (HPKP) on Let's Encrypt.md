# Activating HTTP Public Key Pinning (HPKP) on Let's Encrypt
Source: https://lilleengen.io/blog/index.php/posts/activating-http-public-key-pinning-hpkp-on-lets-encrypt

* Disclaimer: This might break your website, don't preceded if you don't know what you're doing.

Since the letsencrypt seems to create a new private key every time the certificate is renewed and Let's Encrypt requires you to renew you certificate once every ~80 days pinning using your certificate's SPKI is probably not the way to go. So, what should we pin then? Let's Encrypt is currently issuing from Authority X3, and using Authority X4 as a backup, so these two is a great place to start. We should also include the ISRG Root so this might support new Authorities with other SPKIs as well. 

## Generate HASH of Private Keys

To generate the hash of the SPKI of these certificates run the following commands

```
cat /etc/letsencrypt/live/YourDomain/cert.pem | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
```

Again replace path with your domain.

Generate the ISRG Root X1, Let’s Encrypt Authority X3/R3 and Let’s Encrypt Authority X4/R4 SPKI-hash using the following command:

```
https://letsencrypt.org/certificates/

curl -s https://letsencrypt.org/certs/lets-encrypt-r3.pem | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
curl -s https://letsencrypt.org/certs/lets-encrypt-r4.pem | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
curl -s https://letsencrypt.org/certs/letsencryptauthorityx3.pem | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
curl -s https://letsencrypt.org/certs/letsencryptauthorityx4.pem | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
curl -s https://letsencrypt.org/certs/isrgrootx1.pem | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
```

## Config

Now take all the hashes you have generated and combine them into a config, replace Hash1 - Hash4 with the hashes. This will set max age to 1 minute, so you can verify that your config is working before going all in.

## Apache

```
Header always set Public-Key-Pins "pin-sha256=\"Hash1\"; pin-sha256=\"Hash2\"; pin-sha256=\"Hash3\"; pin-sha256=\"Hash4\"; max-age=60;"
```

## Test your config

To test your config head over to Report URIs HPKP Analyser

If your config works you can now increase max-age. I have chosen 5184000, which is roughly 2 months. You can also add includeSubDomains after max-age if you want the policy to apply to sub-domains as well.

Please note that this will **limit the certificates a browser will accept for your website to certificates issued by Let's Encrypt**, but will not have any effect against a breech of Let's Encrypt or you.

You probably would like to automate renewing of those hashes via cron job and this script https://github.com/GAS85/cubietruck/blob/master/publicKeyPinning.sh
