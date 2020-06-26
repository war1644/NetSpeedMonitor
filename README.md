### NetSpeedMonitor

- INSTALL
	- 直接下载编译好的程序[see Release](https://github.com/longtails/NetSpeedMonitor/releases/tag/v1.3) 或用xcode重新编译源码

	- 设置开机启动

- GEN ICONS
	- ./genIcon.sh youricon.png youricon.icns
	- 将生成的图标文件拖到xcode NetSpeedMonitor 工程中
	- 编辑Info.plist的Icon file项
	- 清理build 目录
	- 重新构建

- 更新
	- v1.3
		- fix多屏切换时，副屏的显示异常
		- fix黑色/白色模式切换时，箭头图片不强制刷新的bug，现在改为arsc arrow
	- v1.2
		- 为mac10.14调整了状态栏显示:左1、2为NetSpeedMonitor,右1为腾讯安全管家
		- 更换更加明显的箭头，并使上下箭头始终对齐
		- 整体居中
		- 添加图标
		- 固定title长度，避免左右变动

	![status](status.png?raw=true)

	- v1.0
		- 放弃原来的富文本方法，更换为自定义view方法
		- 箭头不会再左右跳动，不会再影响其他应用的位置
		- 自适应黑色主题

	![v1.0](https://github.com/scylhy/NetSpeedMonitor/blob/master/v1.0.white.png)
	![v1.0](https://github.com/scylhy/NetSpeedMonitor/blob/master/v1.0.black.png)


