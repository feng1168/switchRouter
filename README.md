# switchRouter

旁路由上线时自动切换至旁路由，离线后自动切回主路由（上传switchRouter.sh的路由），支持ipv4、ipv6自动切换

适用于OpenWrt固件，兼容多拨，支持跟随OpenWrt配置文件的备份与恢复，其他固件请自测

本软件可自由分享，分享时请注明转自 https://github.com/feng1168/switchRouter

-------------------------

更新日志：

1.7：自动检测主路由的ipv4、dns，更智能，减少设置步骤

1.6：sec_ipv6= 时，切换旁路由时禁用ipv6，切换主路由时启用ipv6

1.5：运行时增加清屏操作，屏蔽错误提示，突出运行结果显示

1.4：增加稳定性

1.3：改变切换方式，拥有更高效率和网速

1.2：通用性更好，切换速度更快

1.1：添加ipv6支持

1.0：初始版本

-------------------------

一、旁路由：

如不需要ipv6，请将switchRouter.sh中sec_ipv6=

ssh中查看ip地址：

路由ipv4：uci show network.lan.ipaddr | cut -d "'" -f 2

路由ipv6：echo $(uci show network.globals.ula_prefix | cut -c29-44)"1"

-------------------------

二、主路由：

修改switchRouter.sh中的旁路由的ipv4、ipv6

系统》文件传输，将switchRouter.sh上传，ssh中运行以下命令

mv /tmp/upload/switchRouter.sh /etc/config/

chmod 0755 /etc/config/switchRouter.sh

/etc/init.d/cron enable

/etc/init.d/cron start

/etc/config/switchRouter.sh

有回显即为成功，重连wifi即可生效

如需自动切换，网页登录，在路由的任务计划中加入

*/2 * * * * /etc/config/switchRouter.sh

-------------------------

三、检查运行状态：系统》TTYD终端，执行以下命令

logread | grep "switchRouter is running"
