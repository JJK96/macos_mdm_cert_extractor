A small wrapper around [chainbreaker](https://github.com/n0fate/chainbreaker) and openssl to extract an MDM (Intune) certificate that can later be imported in other browsers, for example on other devices to gain access from there.

Please be aware that using this in the wrong locations might compromise the security of company resources. An example of a valid usecase for this is to access company resources from within a VM that is running on a managed device.

## Dependencies

* [chainbreaker](https://github.com/n0fate/chainbreaker)
* openssl

## How to use the certificate in Firefox

In this section I will describe how to use this certificate in Firefox. The process for other browsers is probably similar.

1. Import the p12 certificate as a client certificate in Firefox.
2. Copy the user agent of the device for which the certificate was generated.
3. Configure Firefox to use this user agent. (i.e. set general.useragent.override in about:config)
4. Log in to Microsoft with your account
