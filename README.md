# Unofficial Telegram MTProxy based on Alpine for ARMv7 architecture

MTProxy ARMv7 is an easy configurable container based on Alpine image with official [telegram proxy](https://github.com/TelegramMessenger/MTProxy) and few experimental pathes which allows it's work on ARM platform:
    * [MTProxyARMPatch](https://github.com/ICQFan4ever/MTProxyARMPatch)
    * [Telegram MTProto Proxy (Alpine)](https://github.com/alexdoesh/mtproxy/)

# Preparation
Run `generate-config.sh` srcipt to create basic configuration

> Note! By the default configuration enables [TLS-transport](https://github.com/TelegramMessenger/MTProxy/pull/335/files)
> This means that clients must use secret in format: `ee` + `<secret>` + `<domain> (in hex format)`

> Note! If container runs behind NAT `NAT_INFO` parameter in `conf.env` file should be set to public IP.
> To find out your public IP visit https://www.myip.com/ for example.
