;###########################################################################################

; Lang:			Dutch
; LangID			1043
; Last udpdated:		24.02.2009
; Author:			x
; Email:			x@x

; Notes:
; Use ';' or '#' for comments
; Strings must be in double quotes.
; Only edit the strings in quotes:
; Make sure there's no trailing spaces at ends of lines
; To use double quote inside string - '$\'
; To force new line  - '$\r$\n'
; To insert tabulation  - '$\t'

;###########################################################################################

; Language selection
	LangString Language_Title ${LANG_DUTCH} "Installer language"
	LangString Language_Text ${LANG_DUTCH} "Please select a language:"

; First Page of Installer
	LangString Welcome_Title ${LANG_DUTCH} "Welcome to the $(^NameDA) Setup Wizard"
	LangString Welcome_Text ${LANG_DUTCH} "This wizard will guide you through the installation of $(^NameDA).$\r$\n$\r$\nIt is recommended that you close Winamp before starting Setup. This will make it possible to update all relevant Winamp files.$\n$\nYou'll at least need Winamp ${CPRO_WINAMP_VERSION} for this version of ${CPRO_NAME} to work!$\r$\n$\r$\n$_CLICK"

; Installer Header
	!ifdef CPRO_BETA
; Beta stage	
		LangString CPro_Caption ${LANG_DUTCH} "${CPRO_NAME}${CPRO_CRS} v${CPRO_VERSION} ${CPRO_BETA} Setup"
	!else
; Release
		LangString CPro_Caption ${LANG_DUTCH} "${CPRO_NAME}${CPRO_CRS} v${CPRO_VERSION} Setup"
	!endif
	
; Installer sections
	LangString CProFiles ${LANG_DUTCH} "ClassicPro Engine"
	LangString wBrowserPro ${LANG_DUTCH} "BrowserPro v2.0"
	LangString wAlbumArt ${LANG_DUTCH} "AlbumArt v1.1"
	LangString WidgetsSection ${LANG_DUTCH} "Widgets"
	LangString CProCustom ${LANG_DUTCH} "Components"
	LangString cPlaylistPro ${LANG_DUTCH} "Playlist Search"
		
; Installer sections descriptions	
	LangString Desc_CProFiles ${LANG_DUTCH} "This will install all the files that ClassicPro needs to work."
	LangString Desc_wBrowserPro ${LANG_DUTCH} "BrowserPro is a widget that will enable your browser to auto navigate to popular websites and explore the playing directory."
	LangString Desc_wAlbumArt ${LANG_DUTCH} "AlbumArt is a widget that shows a big cd cover and information about the playing file."
	LangString Desc_WidgetsSection ${LANG_DUTCH} "ClassicPro skins support widgets and here you'll find some of them that we decided to bundle with this installer."
	LangString Desc_CProCustom ${LANG_DUTCH} "Optional components for ClassicPro."
	LangString Desc_cPlaylistPro ${LANG_DUTCH} "Add a search box above your playlist for easy searches in your playlist."

; Direcory Text	
	LangString CPro_DirText ${LANG_DUTCH} "Please select your Winamp path below (you will be able to proceed when Winamp is detected):"

; Finish Page	
	LangString FinishPage_1 ${LANG_DUTCH} "${CPRO_NAME}${CPRO_CRS} v${CPRO_VERSION} installation finished"
	LangString FinishPage_2 ${LANG_DUTCH} "The setup wizard have finished installing ${CPRO_NAME} v${CPRO_VERSION}. You can now start using ${CPRO_NAME} skins and widgets in Winamp."
	LangString FinishPage_3 ${LANG_DUTCH} "If you like ${CPRO_NAME} and would like to help future development of the product please donate to the project."
	LangString FinishPage_4 ${LANG_DUTCH} "What do you want to do now?"
	LangString FinishPage_5 ${LANG_DUTCH} "Go to our homepage to get more ${CPRO_NAME} skins and widgets"
	LangString FinishPage_6 ${LANG_DUTCH} "Open the default ${CPRO_NAME} skin now"
	LangString FinishPage_7 ${LANG_DUTCH} "Finish"	
	LangString FinishPage_8 ${LANG_DUTCH} "https://www.paypal.com/uk/cgi-bin/webscr?cmd=_flow&SESSION=8h5vlcm9CV3GH2N6PEu7syhffIV0c0JgJ4QZ2FUWaJRiYKCliUrjeMQMtZS&dispatch=5885d80a13c0db1fa798f5a5f5ae42e71cf8ee1e360382336fe24cc0d575d12c"		
	
; First Page of Uninstaller
	LangString Un_Welcome_Title ${LANG_DUTCH} "Welcome to the $(^NameDA) Uninstall Wizard"
	LangString Un_Welcome_Text ${LANG_DUTCH} "This wizard will guide you through the uninstallation of $(^NameDA).$\r$\n$\r$\nBefore starting the uninstallation, make sure ${CPRO_NAME}${CPRO_CRS} v${CPRO_VERSION} is not running.$\r$\n$\r$\n$_CLICK"