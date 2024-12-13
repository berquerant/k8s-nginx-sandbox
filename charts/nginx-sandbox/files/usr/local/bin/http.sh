{{- $nginxName := (include "nginx-sandbox.nginxStatefulSetName" .) -}}
{{- $nginxServiceName := (include "nginx-sandbox.nginxServiceName" .) -}}
{{- $nginxPort := (.Values.nginx.portNumber | int) -}}
{{- $httpbinServiceName := (include "nginx-sandbox.httpbinServiceName" .) -}}
{{- $httpbinPort := (.Values.httpbin.portNumber | int) -}}
{{- $appServiceName := (include "nginx-sandbox.appServiceName" .) -}}
{{- $appPort := (.Values.app.portNumber | int) -}}
{{- $serviceSuffix := (include "nginx-sandbox.serviceSuffix" .) -}}
{{- $namespace := .Release.Namespace -}}
#!/bin/sh

nginx_service='{{ printf "%s.%s.%s:%d" $nginxServiceName $namespace $serviceSuffix $nginxPort }}'
httpbin_service='{{ printf "%s.%s.%s:%d" $httpbinServiceName $namespace $serviceSuffix $httpbinPort }}'
app_service='{{ printf "%s.%s.%s:%d" $appServiceName $namespace $serviceSuffix $appPort }}'

usage() {
    cat <<EOS
$0 -- do http request

$0 (n|nginx) N ARG [CURL_OPTS]
  curl to N-th pod of StatefulSet of nginx like:
    curl NGINX_POD_URL/ARG CURL_OPTS

$0 (b|bin|httpbin) ARG [CURL_OPTS]
  curl to httpbin Service like:
    curl HTTPBIN_SERVICE_URL/ARG CURL_OPTS

$0 (a|app) ARG [CURL_OPTS]
  curl to app Service like:
    curl APP_SERVICE_URL/ARG CURL_OPTS

$0 ARG [CURL_OPTS]
  curl to nginx Service like:
    curl NGINX_SERVICE/ARG CURL_OPTS

If DEBUG is set, enable debug output like:
  DEBUG=1 $0 /a/health
EOS
}

nginx_pod() {
    echo "{{ $nginxName }}-${1}.${nginx_service}"
}

__log() {
    echo "$*" > /dev/stderr
}

__err() {
    __log "$@"
    return 1
}

__curl() {
    case "$1" in
        n | nginx)
            n="$2"
            arg="$3"
            if [ -z "$n" ] ; then
                __err "N is required"
            fi
            if [ -z "$arg" ] ; then
                __err "ARG is required"
            fi
            shift 3
            curl "http://$(nginx_pod ${n})${arg}" "$@"
            ;;
        b | bin | httpbin)
            arg="$2"
            if [ -z "$arg" ] ; then
                __err "ARG is required"
            fi
            shift 2
            curl "http://${httpbin_service}${arg}" "$@"
            ;;
        a | app)
            arg="$2"
            if [ -z "$arg" ] ; then
                __err "ARG is required"
            fi
            shift 2
            curl "http://${app_service}${arg}" "$@"
            ;;
        -h | --help)
            usage
            ;;
        *)
            arg="$1"
            if [ -z "$arg" ] ; then
                __err "ARG is required"
            fi
            shift
            curl "http://${nginx_service}${arg}" "$@"
            ;;
    esac
}

set -e
if [ -n "$DEBUG" ] ; then
    set -x
fi
__curl "$@"
