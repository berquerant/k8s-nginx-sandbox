# nginx-sandbox

This chart adds a basic configuration of nginx to the cluster for functional verification.

## Install

``` shell
helm repo add nginx-sandbox https://berquerant.github.io/k8s-nginx-sandbox
helm repo update
helm install <RELEASE_NAME> nginx-sandbox/nginx-sandbox
```

or

``` shell
helm install <RELEASE_NAME> oci://ghcr.io/berquerant/k8s-nginx-sandbox/charts/nginx-sandbox
```

## Usage

Using the bastion pod allows you to easily test HTTP requests.

``` shell
❯ kubectl exec deploy/<RELEASE_NAME>-bastion -- http -h
/usr/local/bin/http -- do http request

/usr/local/bin/http (n|nginx) N ARG [CURL_OPTS]
  curl to N-th pod of StatefulSet of nginx like:
    curl NGINX_POD_URL/ARG CURL_OPTS

/usr/local/bin/http (b|bin|httpbin) ARG [CURL_OPTS]
  curl to httpbin Service like:
    curl HTTPBIN_SERVICE_URL/ARG CURL_OPTS

/usr/local/bin/http (a|app) ARG [CURL_OPTS]
  curl to app Service like:
    curl APP_SERVICE_URL/ARG CURL_OPTS

/usr/local/bin/http ARG [CURL_OPTS]
  curl to nginx Service like:
    curl NGINX_SERVICE/ARG CURL_OPTS

If DEBUG is set, enable debug output like:
  DEBUG=1 /usr/local/bin/http /a/health
```

## Nginx

StatefulSet of nginx.

### Replicas

To change replica count, edit `replicaCount`.

### `/etc/nginx/nginx.conf`

`nginc.nginxConf`.

### `/etc/nginx/conf.d/default.conf`

The default server which has `nginx.defaultServerName`.
To add configurations to the server context, edit `nginx.defaultServer`.

### `/etc/nginx/conf.d/other.conf`

`nginx.otherConf`.

## Bastion

Deployment for curl.

### Disable

To disable bastion, set `bastion.enabled` to `false`.

## App

Deployment of small python ([FastAPI](https://fastapi.tiangolo.com/)) application.

### Requirements

To change python requirements, edit `app.conf.requirements`.

### Main

To change `main.py`, edit `app.conf.main`.

## Httpbin

[HTTP Request & Response Service](https://github.com/postmanlabs/httpbin).
