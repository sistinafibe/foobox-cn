/* 
* nsi by Nanlon 2020-01-20
* 建议编译环境 NSIS 3.05
* 所用NSIS插件为 Unicode 版
*/

/************************
* 引入nsh 脚本
************************/

# 头文件目录
!addincludedir ".\nsisfiles\include"

!include "MUI2.nsh"
!include "x64.nsh"
!include "WinVer.nsh"

/************************
* 安装程序初始定义常量 
************************/

!define FB2K     "Foobar2000"
!define FB2K_VER "1.5.3"
!define FBOX     "Foobox"
!define FBOX_VER "6.1.5.3"
!define FBOX_PUB "dreamawake"
!define FBOX_WEB "https://www.cnblogs.com/foobox/"

/************************
* MUI 预定义常量
************************/

# UI 文件目录
!define MUI_UI ".\nsisfiles\mui-ui\mui_sdesc.exe"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT

/*** 安装界面 ***/
!define MUI_ICON ".\resource\install.ico"

!define MUI_WELCOMEFINISHPAGE_BITMAP ".\resource\wizard-fb2k.bmp"
!define MUI_HEADERIMAGE_BITMAP ".\resource\header-fb2k-r.bmp"

!define MUI_WELCOMEPAGE_TEXT "\
${FB2K} 是一个Windows平台下的高级音频播放器，\
支持多种音频格式播放和转换及第三方组件扩展。$\n$\n\
${FBOX} 是基于${FB2K}汉化版(当前版本${FB2K_VER})的CUI界面配置。$\n$\n\
若选装Milkdrop2可视化插件，系统应不低于Windows Vista并安装DirectX 9.0。"

!define MUI_FINISHPAGE_RUN "$INSTDIR\${FB2K}.exe"
!define MUI_FINISHPAGE_RUN_TEXT "运行 ${FBOX}"

/*** 卸载界面 ***/
!define MUI_UNICON ".\resource\uninst.ico"

!define MUI_UNWELCOMEFINISHPAGE_BITMAP ".\resource\wizard-fb2k.bmp"
!define MUI_HEADERIMAGE_UNBITMAP ".\resource\header-fb2k-r.bmp"

/************************
* 初始化定义变量
************************/

# 标题
Caption "${FBOX} ${FBOX_VER}"
# 生成Unicode安装程序
Unicode true
# 设置文件覆盖标记
SetOverwrite try
# 设置压缩选项
SetCompress auto
# 选择压缩方式
SetCompressor /SOLID lzma
SetCompressorDictSize 32
# 设置数据块优化
SetDatablockOptimize on
# 设置在数据中写入文件时间
SetDateSave on
# 请求应用程序 管理员权限
RequestExecutionLevel admin
# 是否允许安装在根目录下
AllowRootDirInstall false
# 设置是否显示安装详细信息
ShowInstDetails hide 
# 设置是否显示卸载详细信息
ShowUnInstDetails hide 

# 设置安装类型
InstType "标准安装 (不含可视化插件Milkdrop2)"
InstType "增强安装"
InstType "完全安装"

/************************
* 界面设置
************************/

/*** 加快载入界面资源 ***/
ReserveFile ".\resource\install.ico"
ReserveFile ".\resource\licence.rtf"
ReserveFile ".\resource\wizard-fb2k.bmp"
ReserveFile ".\resource\header-fb2k-r.bmp"

# dll
# 插件目录
!addplugindir  ".\nsisfiles\plugin"

ReserveFile /plugin "System.dll"
ReserveFile /plugin "Process.dll"
ReserveFile /plugin "AccessControl.dll"

/*** 安装页面 ***/

# 欢迎页面
!insertmacro MUI_PAGE_WELCOME
# 许可协议页面
!insertmacro MUI_PAGE_LICENSE ".\resource\licence.rtf"
# 组件选择页面
!insertmacro MUI_PAGE_COMPONENTS
# 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
# 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
# 安装完成页面
!insertmacro MUI_PAGE_FINISH

/*** 卸载页面 ***/

# 卸载欢迎页面
!insertmacro MUI_UNPAGE_WELCOME
# 卸载目录选择页面
!insertmacro MUI_UNPAGE_DIRECTORY
# 卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES
# 卸载完成页面
!insertmacro MUI_UNPAGE_FINISH

/*** 语言文件(建议使用 ".\nsisfiles\language" 下的语言文件“替换”NSIS官方简体中文语言包) ***/

!insertmacro MUI_LANGUAGE "SimpChinese"

/************************
* 版本声明
************************/

VIProductVersion "${FBOX_VER}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductName"     "${FBOX}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "Comments"        "CUI for ${FB2K}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "CompanyName"     "${FBOX_WEB}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalTrademarks" "${FB2K}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalCopyright"  "${FB2K}.org"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileDescription" "${FBOX} CUI skin for ${FB2K}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileVersion"     "${FBOX_VER}"

/************************
* 安装文件定义
************************/

Name "${FBOX} ${FBOX_VER}"
OutFile "${FBOX}-${FBOX_VER}.exe"
InstallDir "$PROGRAMFILES\${FB2K}"

BrandingText "${FBOX_PUB} ${__DATE__}"

/************************
* 安装 Section 段
************************/

!macro ProcessCleanup  # 进程清理
ProcessFindNext:
  Process::Find "${FB2K}.exe"
	Pop $R0
	IntCmp $R0 0 ProcessFindDone
	MessageBox MB_ABORTRETRYIGNORE|MB_ICONQUESTION|MB_DEFBUTTON2 \
	"程序检测到${FB2K}正在运行，若不退出${FB2K}强行安装，\
  $\n可能会因无法覆盖文件而导致安装失败！$\n \
  $\n1. 选择〖重试(R)〗将尝试关闭${FB2K}后继续安装（推荐）；\
  $\n2. 选择〖忽略(I)〗不关闭${FB2K}并继续安装（可能出错）；\
  $\n3. 选择〖中止(A)〗退出安装程序。" \
  /SD IDRETRY IDABORT ExitSetup IDIGNORE ProcessFindDone
	Process::Kill $R0
	Pop $R1
	IntCmp $R1 0 ProcessFindDone
	Goto ProcessFindNext
	
	ExitSetup:
	Quit
ProcessFindDone:
!macroend

Section "核心程序组件" CoreFiles
  SectionIn 1 2 3 RO
  
  # 进程清理
  !insertmacro ProcessCleanup
  
  SetOutPath "$INSTDIR"
  File /r "${FB2K}-core\*.*"
  
  WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd

SectionGroup "可选配置文件(升级需保留原配置时勿选)" OptionalProfile

  Section "${FB2K}核心配置文件" CoreProfile
    SectionIn 1 2 3
    
    SetOverwrite off
    SetOutPath "$INSTDIR\configuration"
    File "${FB2K}-extra\configuration\Core.cfg"
    SetOverwrite try
  SectionEnd

  Section "ESLyric歌词配置文件" LyricsCfg
    SectionIn 1 2 3
    
    SetOverwrite off
    SetOutPath "$INSTDIR\configuration"
    File "${FB2K}-extra\configuration\foo_uie_eslyric.dll.cfg"
    SetOverwrite try
  SectionEnd

  Section "转换器配置文件" ConverterCfg
    SectionIn 1 2 3
    
    SetOverwrite off
    SetOutPath "$INSTDIR\configuration"
    File "${FB2K}-extra\configuration\foo_converter.dll.cfg"
    SetOverwrite try
  SectionEnd
  
SectionGroupEnd

SectionGroup "额外解码器" ExtraDecoder

  Section "APE 解码器" DecAPE
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\user-components\foo_input_monkey"
    File "${FB2K}-extra\components\foo_input_monkey.dll"
  SectionEnd

  Section "DTS 解码器" DecDTS
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\user-components\foo_input_dts"
    File "${FB2K}-extra\components\dts\*.*"
  SectionEnd

  Section "SACD 解码器" DecSACD
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\user-components\foo_input_sacd"
    File /r "${FB2K}-extra\components\sacd\*.*"
    
    # 注册 dsd_transcoder.dll
    ${If} ${RunningX64}
	RegDLL "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"
    ExecWait '"$SYSDIR\regsvr32.exe" /s "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder_x64.dll"'
    ${else}
	RegDLL "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"
    ;ExecWait `regsvr32 /s "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"`
    ${EndIf}
    
    SetOutPath "$INSTDIR\user-components\foo_dsd_processor"
    File "${FB2K}-extra\components\foo_dsd_processor.dll"
    
    SetOutPath "$INSTDIR\user-components\foo_dsd_converter"
    File "${FB2K}-extra\components\foo_dsd_converter.dll"
  SectionEnd

  Section "TTA 解码器" DecTTA
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\user-components\foo_input_tta"
    File "${FB2K}-extra\components\foo_input_tta.dll"
  SectionEnd

  Section "TAK 解码器" DecTAK
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\user-components\foo_input_tak"
    File "${FB2K}-extra\components\tak_deco_lib.dll"
    File "${FB2K}-extra\components\foo_input_tak.dll"
  SectionEnd

  Section "DVD-Audio 解码器" DecDVDA
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\user-components\foo_input_dvda"
    File "${FB2K}-extra\components\foo_input_dvda.dll"
  SectionEnd

SectionGroupEnd

SectionGroup "可选组件" OptionalComponents

  Section "转换器" Converter
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\components\foo_converter.dll"
  SectionEnd

  Section "文件操作" FileOps
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\components\foo_fileops.dll"
  SectionEnd

  Section "压缩包读取器" UnPack
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\components\foo_unpack.dll"
  SectionEnd

  Section "播放增益扫描器" Rgscan
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\components\foo_rgscan.dll"
  SectionEnd

  Section /o "Freedb 标签获取器" Freedb
    SectionIn 2 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\components\foo_freedb2.dll"
  SectionEnd

  Section /o "UPnP\DLNA 支持插件" UPnP
    SectionIn 3
    
    SetOutPath "$INSTDIR\user-components\foo_upnp"
    File "${FB2K}-extra\components\foo_upnp.dll"
  SectionEnd
  
SectionGroupEnd

SectionGroup "格式转换编码器" Encoders

  Section "MP3编码器(lame)" EncMP3
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\lame.exe"
  SectionEnd

  Section "FLAC编码器(无损)" EncFLAC
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\flac.exe"
    File "${FB2K}-extra\encoders\metaflac.exe"
  SectionEnd

  Section "WMA编码器" EncWMA
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\WMAEncode.exe"
  SectionEnd

  Section "APE编码器(无损)" EncAPE
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\mac.exe"
  SectionEnd

  Section "Opus编码器" EncOPUS
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\opusenc.exe"
  SectionEnd

  Section "AAC编码器(Nero)" EncAAC
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\neroAacEnc.exe"
  SectionEnd

  Section "OGG编码器" EncOGG
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\oggenc2.exe"
  SectionEnd

  Section "WavePack编码器(无损)" EncWAV
    SectionIn 1 2 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\wavpack.exe"
  SectionEnd

  Section /o "MPC编码器" EncMPC
    SectionIn 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\mpcenc.exe"
  SectionEnd

  Section /o "TAK编码器" EncTAK
    SectionIn 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\Takc.exe"
  SectionEnd

  Section /o "TTA编码器" EncTTA
    SectionIn 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\tta.exe"
  SectionEnd

  Section /o "AAC(fhgaacenc, 需要Winamp5.62+)" EncFHGAAC
    SectionIn 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\fhgaacenc.exe"
    File "${FB2K}-extra\encoders\nsutil.dll"
  SectionEnd

  Section /o "AAC编码器(faac)" EncFAAC
    SectionIn 3
    
    SetOutPath "$INSTDIR\encoders"
    File "${FB2K}-extra\encoders\faac.exe"
  SectionEnd

SectionGroupEnd

SectionGroup "高级输出组件" AdvancedOutputComponents

  Section "WASAPI输出组件(Windows版本不低于Vista)" WASAPI
    SectionIn 1 2 3
    
    ${If} ${AtLeastWinVista}
    SetOutPath "$INSTDIR\user-components\foo_out_wasapi"
    File "${FB2K}-extra\components\wasapi\*.*"
    ${EndIf}
  SectionEnd

  Section /o "ASIO输出组件" ASIO
    SectionIn 3
    
    SetOutPath "$INSTDIR\user-components\foo_out_asio"
    File "${FB2K}-extra\components\asio\*.*"
  SectionEnd
  
SectionGroupEnd

SectionGroup "增强版附加组件和程序" EnhancedAddOnsAndPrograms

  Section /o "Milkdrop2 可视化插件（要求DirectX 9.0）" Milkdrop2
    SectionIn 2 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\visualization\foo_vis_shpeck.dll"
    
    SetOutPath "$INSTDIR\configuration"
    File "${FB2K}-extra\visualization\foo_vis_shpeck.dll.cfg"
    
    SetOutPath "$INSTDIR\plugins"
    File /r "${FB2K}-extra\visualization\plugins\*.*"
  SectionEnd

  Section /o "MusicTag" MusicTag
    SectionIn 2 3
    
    SetOutPath "$INSTDIR\assemblies\MusicTag"
    File /r "${FB2K}-extra\assemblies\MusicTag\*.*"
  SectionEnd
  
SectionGroupEnd

SectionGroup "默认界面DUI相关" DefaultInterfaceDuiRelated

  Section /o "专辑列表组件" AlbumList
    SectionIn 3
    
    SetOutPath "$INSTDIR\components"
    File "${FB2K}-extra\components\foo_albumlist.dll"
  SectionEnd

  Section /o "预置主题集" DuiThemes
    SectionIn 3
    
    SetOutPath "$INSTDIR\themes"
    File "${FB2K}-extra\themes\*.*"
  SectionEnd
  
SectionGroupEnd

Section "均衡器预置文件" EqualizerPresets
  SectionIn 1 2 3
  
  SetOutPath "$INSTDIR\Equalizer Presets"
  File "${FB2K}-extra\Equalizer Presets\*.*"
SectionEnd


Section "创建桌面快捷方式" ShortcutsDesktop
  SectionIn 1 2 3
	
	SetShellVarContext current
	CreateShortCut "$DESKTOP\${FB2K}.lnk" "$INSTDIR\${FB2K}.exe"
SectionEnd

Section -Access
	
  # 获取安装目录读写权限
  AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"
  
SectionEnd

/************************
* 安装回调函数
************************/

Function .onInit
  # 初始化插件目录
  InitPluginsDir
  File "/oname=$PLUGINSDIR\install.ico"       ".\resource\install.ico"
  File "/oname=$PLUGINSDIR\licence.rtf"       ".\resource\licence.rtf"
	File "/oname=$PLUGINSDIR\wizard-fb2k.bmp"   ".\resource\wizard-fb2k.bmp"
	File "/oname=$PLUGINSDIR\header-fb2k-r.bmp" ".\resource\header-fb2k-r.bmp"

  # 创建互斥防止重复运行
  System::Call `kernel32::CreateMutex(i0,i0,t"${FBOX}_installer")i.r1?e`
  Pop $R0
  StrCmp $R0 0 +3
  MessageBox MB_OK|MB_ICONEXCLAMATION "安装程序已经运行！"
  Abort
  
FunctionEnd

Function .onSelChange
  SectionGetFlags ${EncMP3}    $0
  SectionGetFlags ${EncFLAC}   $1
  SectionGetFlags ${EncWMA}    $2
  SectionGetFlags ${EncAPE}    $3
  SectionGetFlags ${EncOPUS}   $4
  SectionGetFlags ${EncAAC}    $5
  SectionGetFlags ${EncOGG}    $6
  SectionGetFlags ${EncWAV}    $7
  SectionGetFlags ${EncMPC}    $8
  SectionGetFlags ${EncTAK}    $9
  SectionGetFlags ${EncTTA}    $R1
  SectionGetFlags ${EncFHGAAC} $R2
  SectionGetFlags ${EncFAAC}   $R3
  SectionGetFlags ${Converter} $R0
  SectionGetFlags ${DuiThemes} $R9

  StrCmp $0 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $1 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $2 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $3 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $4 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $5 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $6 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $7 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $8 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $9 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $R1 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $R2 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $R3 1 0 +2
  SectionSetFlags ${Converter} 1
  StrCmp $R0 0 0 +2
  SectionSetFlags ${ConverterCfg} 0
  StrCmp $R9 1 0 +2
  SectionSetFlags ${AlbumList} 1
FunctionEnd

/************************
* 卸载 Section 段
************************/

Section Uninstall
	# 进程清理
  !insertmacro ProcessCleanup
	
	# 反注册dll
	${If} ${RunningX64}
	UnRegDLL "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"
	ExecWait '"$SYSDIR\regsvr32.exe" /u /s "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder_x64.dll"'
  ${else}
  UnRegDLL "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"
  ;ExecWait `regsvr32 /s /u "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"`
	${EndIf}
	
	# 获取安装目录读写权限
	AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"
	
  # 删除安装文件
  RMDir /r "$INSTDIR\assemblies"
  RMDir /r "$INSTDIR\cache"
  RMDir /r "$INSTDIR\components"
  RMDir /r "$INSTDIR\configuration"
  RMDir /r "$INSTDIR\crash reports"
  RMDir /r "$INSTDIR\doc"
  RMDir /r "$INSTDIR\encoders"
  RMDir /r "$INSTDIR\Equalizer Presets"
  RMDir /r "$INSTDIR\icons"
  RMDir /r "$INSTDIR\playlists-v1.4"
  RMDir /r "$INSTDIR\plugins"
  RMDir /r "$INSTDIR\runtime"
  RMDir /r "$INSTDIR\themes"
  RMDir /r "$INSTDIR\user-components"

  Delete "$INSTDIR\avcodec-fb2k-57.dll"
  Delete "$INSTDIR\avutil-fb2k-55.dll"
  Delete "$INSTDIR\concrt140.dll"
  Delete "$INSTDIR\dsound.dll"
  Delete "$INSTDIR\msvcp140.dll"
  Delete "$INSTDIR\msvcp140_1.dll"
  Delete "$INSTDIR\PP-UWP-Interop.dll"
  Delete "$INSTDIR\shared.dll"
  Delete "$INSTDIR\ShellExt32.dll"
  Delete "$INSTDIR\ShellExt64.dll"
  Delete "$INSTDIR\vccorlib140.dll"
  Delete "$INSTDIR\vcruntime140.dll"
  Delete "$INSTDIR\zlib1.dll"
  Delete "$INSTDIR\${FB2K}.exe"
  Delete "$INSTDIR\${FBOX}帮助.CHM"
  Delete "$INSTDIR\${FB2K} Shell Associations Updater.exe"
  
  Delete "$INSTDIR\uninst.exe"

  # 删除桌面快捷方式
  SetShellVarContext current
  Delete "$DESKTOP\${FB2K}.lnk"
	
	# 是否保留用户文件
	MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 \
	"是否保留媒体库数据、封面、歌词及下载等内容？$\n(若您要保留这些文件，请点击下面的〖是(Y)〗按钮)" \
	IDNO DeleteAll
	
	RMDir "$INSTDIR"
	
	DeleteAll: 	
	# 删除媒体库数据、封面、歌词及下载等全部文件
	RMDir /r "$INSTDIR\Download"
	RMDir /r "$INSTDIR\index-data"
	RMDir /r "$INSTDIR\library"
	RMDir /r "$INSTDIR\Lyrics"
	RMDir /r "$INSTDIR\MusicArt"
	
	Delete "$INSTDIR\*.*"
	
	RMDir "$INSTDIR"
  
  SetAutoClose true
SectionEnd

/************************
* 卸载回调函数
************************/

Function un.onInit
  # 初始化插件目录
  InitPluginsDir
  File "/oname=$PLUGINSDIR\uninst.ico"        ".\resource\uninst.ico"
  File "/oname=$PLUGINSDIR\wizard-fb2k.bmp"   ".\resource\wizard-fb2k.bmp"
	File "/oname=$PLUGINSDIR\header-fb2k-r.bmp" ".\resource\header-fb2k-r.bmp"
  
  # 创建互斥防止重复运行
  System::Call `kernel32::CreateMutex(i 0, i 0, t "${FBOX}_uninstaller") i .r1 ?e`
  Pop $R0
  StrCmp $R0 0 +3
  MessageBox MB_OK|MB_ICONEXCLAMATION "卸载程序已经运行！"
  Abort
FunctionEnd
