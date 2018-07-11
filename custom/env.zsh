# Custom environment variables
# These are additional environent variables that are set by the end-user.
export VULKAN_SDK=/home/yliangsiew/vulkan/VulkanSDK/1.1.70.1/x86_64
export PATH=/home/yliangsiew/prioritybin:$PATH:/home/yliangsiew/.local/bin:/home/yliangsiew/bin/node-v5.9.1-linux-x64/bin:$VULKAN_SDK/bin:/corp.blizzard.net/BFD/Deploy/bl/current/bin/linux

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$VULKAN_SDK/lib
export VK_LAYER_PATH=$VULKAN_SDK/etc/explicit_layer.d
export PYTHONSTARTUP=~/.pythonrc
export VISUAL=vim
export EDITOR="$VISUAL"
export BFD_BLISTER=0
export GPGKEY=yliangsiew@blizzard.com

# BFD Aurora configuration
export BFD_AURORA_PIPELINE=/corp.blizzard.net/BFD/Farm/Public/$USER/caches/aurora.pipeline
export BFD_CACHE_DIR=/corp.blizzard.net/BFD/Farm/Public/$USER/caches

# Enable core dumps
ulimit -c unlimited
