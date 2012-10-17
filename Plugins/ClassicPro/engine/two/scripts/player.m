#include <lib/std.mi>
#include "../../lib/ClassicProFile.mi"
#include <lib/application.mi>

Function String getMyFile();

Global Group g;
Global Button b_menu, b_menufake;

System.onScriptLoaded() {
	g = getScriptGroup();

	b_menu = g.findObject("two.sysmenu");
	b_menu.onSetVisible(false);
}

b_menu.onSetVisible(boolean onOff){
	if(!getPublicInt("cPro2.fs",false)){
		b_menu = g.findObject("two.sysmenu");
		b_menufake = g.findObject("two.sysmenu.fake");
	}
	else{
		b_menu = g.findObject("two.sysmenu.fs");
		b_menufake = g.findObject("two.sysmenu.fs.fake");
	}
}

b_menu.onLeftClick(){
	b_menufake.leftClick();
}
b_menu.onRightButtonUp(int x, int y){
	complete;
	ClassicProFile.exploreFile(getMyFile());
}
b_menu.onLeftButtonDblClk (int x, int y){
	Application.Shutdown();
}

String getMyFile() {
//debug(getPlayItemMetaDataString("filename"));
	String bs = strleft("\ ",1);
	String output = "";

	if(System.strleft(System.getPlayItemString(),6) == "cda://") output = System.strmid(System.getPlayItemString(), 6, 1)+":"+bs;
	else output= getPlayItemMetaDataString("filename");

//debug(output);

	return output;
}