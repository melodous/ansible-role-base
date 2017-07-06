redis ansible role default variables
====================================

Sections
--------

-   Redis docker management
-   Redis monitoring management

### Redis docker management

`redis_docker_image`

Redis docker image

    redis_docker_image: redis

`redis_version`

Redis docker image version (TAG)

    redis_version: 3.2.9

`redis_docker_labels`

Yaml dictionary which maps Docker labels. os\_environment: Name of the environment, example: Production, by default “default”. os\_contianer\_type: Type of the container, by default redis.

    redis_docker_labels:
      os_environment: "{{ docker_os_environment | default('default') }}"
      os_contianer_type: redis

### Redis monitoring management

`redis_monitoring`

Enable or disable redis monitoring

    redis_monitoring: true

`redis_check_redisstatus`

Enable of disable redis status check, bu default True.

    redis_check_redisstatus: true
