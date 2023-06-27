#!/bin/bash

# Clone a sub-directory of a git repository. Probably replaces "svn co" which is being deprecated by GitHub.
# Usage: git_sparse_clone $repo_url $repo_branch $local_temp_url $sub_directory $target_location

function git_sparse_clone() {
    git clone --filter=blob:none --no-checkout --depth=1 -b $2 $1 $3 && cd $3
    git sparse-checkout init --cone
    git sparse-checkout set $4
    git checkout
    mv $4 ../$5
    cd ../ && rm -rf $3
}

# Modify Default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# Modify default hostname
sed -i 's/HandsomeMod/Railgun/g' package/base-files/files/bin/config_generate

# Clean up dependencies
find . -name Makefile -exec dirname {} \; | grep -wE 'brook|gn|chinadns-ng|dns2socks|dns2tcp|hysteria|ipt2socks|microsocks|naiveproxy|pdnsd-alt|redsocks2|sagernet-core|shadowsocks-rust|shadowsocksr-libev|simple-obfs|sing-box|ssocks|tcping|trojan|trojan-go|trojan-plus|v2ray-core|v2ray-geodata|v2ray-plugin|v2raya|xray-core|xray-plugin' | xargs rm -rf

# Add helloworld and passwall
git clone --depth=1 https://github.com/fw876/helloworld package/helloworld
git clone --depth=1 -b packages https://github.com/xiaorouji/openwrt-passwall package/passwall
git_sparse_clone https://github.com/xiaorouji/openwrt-passwall luci passwall luci-app-passwall package/luci-app-passwall

# Update Go to 1.20 for Xray-core build
rm -rf feeds/packages/lang/golang
git_sparse_clone https://github.com/openwrt/packages openwrt-22.03 packages-upstream lang/golang feeds/packages/lang/golang