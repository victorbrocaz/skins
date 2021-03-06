#include <lib/std.mi>

Function openDrawer(int drawerNo);
Function gotoPrevDrawer();
Function gotoNextDrawer();
Function setDrawerBG(int mode); //0=normal, 1=tagview, 2=neweq

/* CPro Widget */
Class Group CProWidget;
Member boolean CProWidget.scrollSkip;
Member boolean CProWidget.disabled;
Member int CProWidget.custombg;
Member boolean CProWidget.hideVis;
Member boolean CProWidget.hidePL;
Member boolean CProWidget.addSep;

#define userWidgetOffset 100
Global int numUserWidgets = 0;
Global int numInternalWidgets = 0;

Global Layout myLayout;
Global Group myGroup;
Global CProWidget drawer_equalizer, drawer_pl, drawer_vid, drawer_savedpl, drawer_tagviewer, drawer_avs, drawer_ct, drawer_skinchooser;
Global PopUpMenu popMenu, widgetmenu;
Global Button but_drawerGoto;
Global GuiObject cpro_sui, gad_Grid, gad_GridEQ;
Global Layer ct_fakeLayer, tempfix;
Global Boolean gotThemes, mouse_but_drawerGoto, cuseqbg;

Global ComponentBucket dummyBuck;
Global GuiObject customObj;
Global List internalWidgets;

System.onScriptLoaded() {
	internalWidgets = new List;

	myLayout = getContainer("main").getLayout("normal");

	myGroup = getScriptGroup();
	but_drawerGoto = myGroup.findObject("drawer.menulist");
	ct_fakeLayer = myGroup.findObject("drawer.ct.fakelayer"); //used to detect if skin have colorthemes
	tempfix = myGroup.findObject("tempfix");

	/*	ClassicPro Components */
	drawer_equalizer = myGroup.findObject("drawer.equalizer");
	drawer_equalizer.custombg = 2;
	drawer_tagviewer = myGroup.findObject("drawer.tagviewer");
	drawer_tagviewer.custombg = 1;
	drawer_savedpl = myGroup.findObject("drawer.savedpl");
	drawer_ct = myGroup.findObject("drawer.colortheme");
	drawer_ct.disabled = ct_fakeLayer.isInvalid();
	drawer_ct.addSep = true;
	internalWidgets.addItem(drawer_equalizer);
	internalWidgets.addItem(drawer_tagviewer);
	internalWidgets.addItem(drawer_savedpl);
	internalWidgets.addItem(drawer_ct);
	/*	end	*/
	
	
	
	/*	Winamp Components */
	drawer_pl = myGroup.findObject("drawer.playlist");
	drawer_pl.scrollSkip = true;
	drawer_vid = myGroup.findObject("drawer.video");
	drawer_vid.scrollSkip = true;
	drawer_avs = myGroup.findObject("drawer.avs");
	drawer_avs.scrollSkip = true;
	drawer_avs.hideVis = true;
	internalWidgets.addItem(drawer_pl);
	internalWidgets.addItem(drawer_vid);
	internalWidgets.addItem(drawer_avs);
	/*	end	*/




	/*drawer_skinchooser = myGroup.findObject("drawer.skinchooser");
	internalWidgets.addItem(drawer_skinchooser);*/

	numInternalWidgets = internalWidgets.getNumItems();

	gad_Grid = myGroup.findObject("centro.gadget.grid");
	gad_GridEQ = myGroup.findObject("centro.gadget.grid.eq");
	
	cpro_sui = getContainer("main").getLayout("normal").findObject("cpro.sui");

	dummyBuck = myGroup.findObject("widget.loader");
	customObj = myGroup.findObject("widget.holder");

	numUserWidgets = dummyBuck.getNumChildren();

	Map myMap = new Map;
	myMap.loadMap("read.suiframe.png");
	if(myMap.getWidth()>=272) cuseqbg=true;
	else  cuseqbg=false;
	delete myMap;

	//Saved Settings
	openDrawer(getPublicInt("cPro.lastDrawer", 0));
}


but_drawerGoto.onleftClick(){
	popMenu = new PopUpMenu;

	// Faster to load it once!
	int cur = getPublicInt("cPro.lastDrawer", 0);

	for ( int i = 0; i < numInternalWidgets; i++ )
	{
		CProWidget gr = internalWidgets.enumItem(i);
		popMenu.addCommand(gr.getXMLparam("name"), i, cur == i, gr.disabled);
		if(gr.addSep) popMenu.addSeparator();
	}
	popMenu.addSeparator();

	//widgetmenu = new PopUpMenu;

	int x;
	for (x = 0; x < numUserWidgets; x++) {
		GuiObject gr = dummyBuck.enumChildren(x);
		//widgetmenu.addCommand(gr.getXMLparam("name"), userWidgetOffset+x, cur == userWidgetOffset+x, 0);
		popMenu.addCommand(gr.getXMLparam("name"), userWidgetOffset+x, cur == userWidgetOffset+x, 0);
	}

	if (x == 0) widgetmenu.addCommand("No widgets found for this view!", -1, 0, 1);
	//popMenu.addSubMenu(widgetmenu, "Widgets");


	popMenu.addSeparator();
	popMenu.addCommand("Close drawer", -2, 0, 0);//** Item code changed to -2 to support widgets.

	//popMenu.checkCommand(getPublicInt("cPro.lastDrawer", 0), 1);

	int result = popMenu.popAtXY(clientToScreenX(but_drawerGoto.getLeft()), clientToScreenY(but_drawerGoto.getTop() + but_drawerGoto.getHeight()));

	if(result>=0) openDrawer(result);
	else if(result == -2){
		setPublicInt("cPro.draweropened", 0);
		myGroup.hide();
	}

	delete popMenu;
	delete widgetmenu;
	complete;
}

openDrawer(int drawerNo){
	//Safety check to see if the widgets is still there ;)
	if(drawerNo>=userWidgetOffset){
		if (drawerNo - userWidgetOffset > dummyBuck.getNumChildren()-1)
		{
			drawerNo=0;
		}
		
	}
	
	for ( int i = 0; i < numInternalWidgets; i++ )
	{
		CProWidget gr = internalWidgets.enumItem(i);
		gr.hide();
	}
	customObj.hide();

	// We have to show an Internal Widget
	if (drawerNo < userWidgetOffset)
	{
		CProWidget gr = internalWidgets.enumItem(drawerNo);

		if (gr.disabled == true)
		{
		drawerNo = 0;
			gr = internalWidgets.enumItem(drawerNo); // Load Default Widget
		}

		setDrawerBG(gr.custombg);

		if(gr.getXMLparam("name")=="Visualization"){
			cpro_sui.sendAction ("release", "VIS", 0, 0, 0, 0);
		}
		else if (gr.getXMLparam("name")=="Playlist"){
			cpro_sui.sendAction ("release", "PL", 0, 0, 0, 0);
		}
		else if (gr.getXMLparam("name")=="Video"){
			cpro_sui.sendAction ("release", "VID", 0, 0, 0, 0);
		}
		else if (gr.getXMLparam("name")=="Tag Viewer"){
			cpro_sui.sendAction ("release", "TAG", 0, 0, 0, 0);
		}

		gr.show();
	}
	else
	{
		GuiObject gr = dummyBuck.enumChildren(drawerNo-userWidgetOffset);
		String id = getToken(gr.getXMLparam("userdata"), ";", 0);
		customObj.setXmlParam("groupid", id);
		setDrawerBG(stringToInteger(getToken(gr.getXMLparam("userdata"), ";", 1)));
		customObj.show();
	}

	setPublicInt("cPro.lastDrawer", drawerNo);
}

myGroup.onAction (String action, String param, int x, int y, int p1, int p2, GuiObject source){
	if (strlower(action) == "switch_to_drawer") openDrawer(x);
	if (strlower(action) == "release"){
		if(param=="TAG") if(getPublicInt("cPro.lastDrawer", 0)==1) openDrawer(0);
	}
}

but_drawerGoto.onEnterArea(){
	mouse_but_drawerGoto=true;
}
but_drawerGoto.onLeaveArea(){
	mouse_but_drawerGoto=false;
}

myLayout.onMouseWheelUp(int clicked , int lines){
	if(mouse_but_drawerGoto){
		gotoPrevDrawer();
		return 1;
	}
}
myLayout.onMouseWheelDown(int clicked , int lines){
	if(mouse_but_drawerGoto){
		gotoNextDrawer();
		return 1;
	}
}

System.onKeyDown(String key){
	if(key=="f7") gotoPrevDrawer();
	else if(key=="f8") gotoNextDrawer();
}

gotoPrevDrawer(){ //wheelup
	int pos = getPublicInt("cPro.lastDrawer", 0);

	if (pos == userWidgetOffset)
	{
		pos = numInternalWidgets;
	}
	if (pos == 0)
	{
		pos = userWidgetOffset + numUserWidgets;
	}
	pos--;
	if (pos < userWidgetOffset)
	{
		CProWidget gr = internalWidgets.enumItem(pos);
		if (gr.scrollSkip || gr.disabled)
		{
			setPublicInt("cPro.lastDrawer", pos);
			gotoPrevDrawer();
			return;
		}
	}

	openDrawer(pos);
}
gotoNextDrawer(){ //wheelDown
	int pos = getPublicInt("cPro.lastDrawer", 0);

	pos++;
	if (pos == userWidgetOffset + numUserWidgets)
	{
		pos = 0;
	}
	if (pos == numInternalWidgets)
	{
		pos = userWidgetOffset;
	}

	if (pos < userWidgetOffset)
	{
		CProWidget gr = internalWidgets.enumItem(pos);
		if (gr.scrollSkip || gr.disabled)
		{
			setPublicInt("cPro.lastDrawer", pos);
			gotoNextDrawer();
			return;
		}
	}
	openDrawer(pos);
}

setDrawerBG(int mode){
	if(mode==0){
		gad_GridEQ.hide();
		//gad_Grid.setXmlParam("bottomleft", "player.gframe.7");
		tempfix.hide();
		gad_Grid.show();
	}
	else if(mode==1){
		gad_GridEQ.hide();
		//gad_Grid.setXmlParam("bottomleft", "player.gframe.7.alt");
		tempfix.show();
		gad_Grid.show();
	}
	else if(mode==2){
		if(!cuseqbg){
			setDrawerBG(0);
			return;
		}
		tempfix.hide();
		gad_Grid.hide();
		gad_GridEQ.show();
	}
	else{
		debug("Error: Drawer background not found!");
	}
}