<img align="left" src="https://user-images.githubusercontent.com/75836834/117618081-4b951d00-b122-11eb-809e-5561b875b37e.png">

# light-proxy:
&emsp;&emsp;&emsp;&emsp;Installs & configures an Apache2 for use as a load-balancer & reverse-proxy.

&emsp;&emsp;&emsp;&emsp;Creates `edit-proxy`, a userspace command for quickly changing your proxy as your working.


## Installation
You should install at-most one reverse proxy per userspace
```
$(cd && git clone git@github.com:light-river/light-proxy.git && cd light-proxy && ./full-install.sh)
```

## Making changes to your proxy
The `edit-proxy` command is now available throuhgout your users namespace.
Changes made this way will automatically restart your Apache2 daemon
```
edit-proxy
```

- - -

## Host Requirements

- Debian/Ubuntu host with a public `ipv4` address.
- Domain name with an `A record` pointing at your public `ipv4` address. 
- Application that you want to proxy requests to. (This could a docker container, fileserver, or entierly other host.)

