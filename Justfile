
container_name:="zmk-build-w-miryoku"

_default:
    just --choose

create-volume:
    podman volume create --driver local -o o=bind -o type=none \
        -o device="$(realpath ../miryoku_zmk/config)" zmk-config

clean-volume:
    podman volume rm zmk-config

build-container:
     podman build -t {{container_name}} -f Dockerfile ./.devcontainer

run-container:
    #!/usr/bin/env bash
    podman run -it --rm \
        --security-opt label=disable \
        --workdir /workspaces/zmk \
        -v $(realpath .):/workspaces/zmk \
        -v $(realpath ../miryoku_zmk):/workspaces/zmk-config \
        -p 3000:3000 \
        {{container_name}} /bin/bash

# Run withi
# west build -p -d build/left -b adv360pro_left -- -DZMK_CONFIG=/workspaces/zmk-config/config
# west build -p -d build/right -b adv360pro_right -- -DZMK_CONFIG=/workspaces/zmk-config/config


run-build target="left":
    #!/usr/bin/env bash
    podman run -it --rm \
        --security-opt label=disable \
        --workdir /workspaces/zmk/app \
        -v $(realpath .):/workspaces/zmk \
        -v $(realpath ../miryoku_zmk):/workspaces/zmk-config \
        -p 3001:3001 \
        {{container_name}} west build -p -d build/{{target}} -b adv360pro_{{target}} -- -DZMK_CONFIG=/workspaces/zmk-config/config

build-left:
    just run-build "left"

build-right:
    just run-build "right"

copy-to target:
    cp build/{{target}}/zephyr/zmk.uf2 /run/media/mputz/ADV360PRO

copy-left:
    just copy-to left

copy-right:
    just copy-to right


