/*
SC:NowPlaying XUI Object
also incorporates nested SC:FadeText

pjn123, Quadhelix, SLoB

2008
this is a wip, please do not rip it without giving proper credit
*/

#include <lib/std.mi>

Function setAllTags();
Function resizeToThis(int x, int y, int w, int h);
Function FadeGroup(Group FadeGrp, Int AlphaValue);

Global Group XUIGroup, cdbox, cdboxref, cdboxHolder, cdboxrefmask, ratings;
Global GuiObject line1, line2, line3, BGCol, CDBoxFade;
Global int xs, ys, ws, hs;
Global int xc, yc, wc, hc;
Global layer lyrFx, lyrFxFG;
global double dblSmidge;
Global int reflectionheight;


System.onScriptLoaded(){
	XUIGroup = getScriptGroup();
	ratings = XUIGroup.findObject("sc.nowplaying.ratings");
	cdbox = XUIGroup.findObject("sc.nowplaying.cdbox");
	cdboxref = XUIGroup.findObject("sc.nowplaying.cdbox.reflection"); 
	cdboxrefmask = XUIGroup.findObject("sc.nowplaying.cdbox.reflection.mask");
	
	cdboxHolder = XUIGroup.findObject("sc.nowplaying.cdbox.holder");
	lyrFx = XUIGroup.findObject("main.albumart.reflection");
	lyrFxFG = XUIGroup.findObject("cdbox.fg.reflection");
	line1 = XUIGroup.findObject("sc.nowplaying.line1");
	line2 = XUIGroup.findObject("sc.nowplaying.line2");
	line3 = XUIGroup.findObject("sc.nowplaying.line3");
	
	BGCol = XUIGroup.findObject("sc.nowplaying.bg");
	CDBoxFade = XUIGroup.findObject("cdbox.fg.fademask");
	

	lyrFx.fx_setBgFx(0);
  	lyrFx.fx_setWrap(0);
  	lyrFx.fx_setBilinear(1);
	lyrFx.fx_setAlphaMode(0);
  	lyrFx.fx_setGridSize(1,1);
  	lyrFx.fx_setRect(1);
	lyrFx.fx_setClear(0); //left as zero as cover is a static image and we dont need to redraw
  	lyrFx.fx_setLocalized(1);
  	lyrFx.fx_setRealtime(0);
	
	lyrFxFG.fx_setBgFx(0);
  	lyrFxFG.fx_setWrap(0);
  	lyrFxFG.fx_setBilinear(1);
	lyrFxFG.fx_setAlphaMode(0);
  	lyrFxFG.fx_setGridSize(1,1);
  	lyrFxFG.fx_setRect(1);
	lyrFxFG.fx_setClear(0); //left as zero as cover sheen is a static image and we dont need to redraw
  	lyrFxFG.fx_setLocalized(1);
  	lyrFxFG.fx_setRealtime(0);
	
  	dblSmidge = 0;
	//default half height - remove ability to resize for the now
	reflectionheight=50;
	//cdboxHolder.Resize(0, 0, 190, 190);
	
		
}

system.onScriptUnloading()
{
	XUIGroup = NULL;
}


System.onSetXuiParam(String param, String value)
{
	if(strlower(param) == "bgcolor")
	{
		string sbgcol = strlower(value);
		BGCol.setXMLParam("color", sbgcol);
		//CDBoxFade.setXMLParam("points", "0.0=" + sbgcol + ",0;1.0=" + sbgcol + ",255");
		//gradient fade to mask the reflection from image to background ie fade it to nothing
		
		//this looks good on both dark and light backgrounds
		CDBoxFade.setXMLParam("points", "0.0=" + sbgcol + ",0;1.0=" + sbgcol + ",255"); //slob org
		
		//hmm pieters extra points looks ok on light bgs but not dark ones
		//CDBoxFade.setXMLParam("points", "0.0=" + sbgcol + ",0;0.3=" + sbgcol + ",128;0.9=" + sbgcol + ",250;1.0=" + sbgcol + ",255"); //add pieters extra points
		
		
	}
	else if(strlower(param) == "reflectiontransparency")
	{
		string sreftrans = strlower(value);
		cdboxref.setXMLParam("alpha", sreftrans);		
	}
	//just default for the now is needed
	else if(strlower(param) == "reflectionheightpercentage")
	{
		//default to 50
		if(stringtointeger(value)>100 || stringtointeger(value)<0 || value=="")
		{
			reflectionheight = 50;
		}
		else
		{
			reflectionheight = stringtointeger(value);
		}
	}
	
}

FadeGroup(Group FadeGrp, Int AlphaValue)
{	
	FadeGrp.setTargetA(AlphaValue);
  	FadeGrp.setTargetSpeed(1.3);
  	FadeGrp.gotoTarget();
	complete;	
}

lyrFx.fx_onFrame()
{
	if(dblSmidge == 0.000001) 
	{
		dblSmidge = 0;
	}
	else
	{
		dblSmidge = 0.000001;
	}

}

//reflection, needs dblSmidge to activate, its on a slow timer without clear as its a static image and doesnt need to be cleared every frame
lyrFx.fx_onGetPixelY(double r, double d, double x, double y)
{
	return -y-dblSmidge;
}

lyrFxFG.fx_onGetPixelY(double r, double d, double x, double y)
{
	return -y-dblSmidge;
}

XUIGroup.onSetVisible(boolean onOff)
{
	if(onOff) 
	{
		lyrFx.fx_setEnabled(1);
		lyrFxFG.fx_setEnabled(1);
		
		setAllTags();	
	}
}

XUIGroup.onResize(int x, int y, int w, int h){
	ratings.setXmlParam("x", integerToString((w-ratings.getguiw())/2));
}

cdboxHolder.onResize(int x, int y, int w, int h)
{
	xs = x;
	ys = y;
	ws = w;
	hs = h*(200-reflectionheight)/200;
	
	resizeToThis(xs, ys, ws, hs);
}

resizeToThis(int x, int y, int w, int h)
{
	//this has to be here, if below this value then album art resizes itself stupid, do not alter this value - SLoB
	if(h<100) h=100;
	
	int x1, y1, w1, h1;
	
	xc = x; yc=y; wc= h; hc=h/2;

	if(w<h*529/488){
		w1 = w;
		h1 = w1*488/529;
		x1 = w/2 - w1/2;		
		y1 = h/2 - h1/2;
	}
	else{
		h1 = h;
		y1 = h/2 - h1/2;
		w1 = h1*529/488;
		x1 = w/2 - w1/2;
	}

	cdbox.setXmlParam("x", integerToString(x1));
	cdbox.setXmlParam("y", integerToString(y1));
	cdbox.setXmlParam("w", integerToString(w1));
	cdbox.setXmlParam("h", integerToString(h1));
	
	cdboxref.setXmlParam("x", integerToString(x1));
	cdboxref.setXmlParam("y", integerToString(y1+h1));
	cdboxref.setXmlParam("w", integerToString(w1));
	//dont want to resize the reflection, just the mask, otherwise album art resizes width due to no stretch param till 5.54
	cdboxref.setXmlParam("h", integerToString(h1*(reflectionheight/100)));

	cdboxrefmask.setXmlParam("x", integerToString(x1));
	cdboxrefmask.setXmlParam("y", integerToString(y1+h1));
	cdboxrefmask.setXmlParam("w", integerToString(w1));
	cdboxrefmask.setXmlParam("h", integerToString(h1*(reflectionheight/100)));
	
	//see if the album art reflection will play ball and resize properly even if no proper support till 5.54
			
	//lyrFx.setXmlParam("w", integerToString(w1)); //seems to screw it all up, do not set the width, album art completely borks all coords
	/*lyrFx.setXmlParam("h", integerToString(h1)); //can only set the height - we need it to still be full height so the reflection looks correct
	lyrFx.setXmlParam("x", "12"); //seems static as per org setting
	
	//replace y coord, this is pretty much there, some album art covers are few pixels different, this seems to be pretty much there with most
	lyrFx.setXmlParam("y", integertostring(((290-h1)/2)-49)); //290 is the offset for cd to reflection
	//we can add back in custom reflection height at some point, just wanted to get this working really
	*/
				
	lyrFx.fx_update();
	lyrFxFG.fx_update();
	//debug
	//line2.setXmlParam("text", "  cdrefy=" + integertostring(cdrefy) + "newy=" + integertostring(((290-cdrefy)/2)-49) );
	
}

System.onTitleChange(String newTitle)
{
	lyrFx.fx_setEnabled(0);
	lyrFxFG.fx_setEnabled(0);
	
	//could fade the album art in?
	//cdboxHolder.setAlpha(0);
	
	setAllTags();
}

setAllTags(){
	if(XUIGroup.isVisible()==false) return;
	
	String year = System.getPlayItemMetaDataString("YEAR");
	String album = System.getPlayItemMetaDataString("ALBUM");
	if (strLen(year)<4) year="";
	else year="("+year+")";
	if(album=="") album="Unknown Album";
	line1.setXmlParam("text", album +" "+year);

	String myartist = System.getPlayItemMetaDataString("ARTIST");
	if(myartist==""){
		if(strsearch(getPlayItemDisplayTitle(), "-")== -1){
			myartist = "Unknown Artist";
		}
		else{
			myartist = getToken(getPlayItemDisplayTitle(), "- ",  0);
		}
	}
	line2.setXmlParam("text", "by " + myartist);
	
	String mytitle = System.getPlayItemMetaDataString("TITLE");
	if(mytitle==""){
		if(strsearch(getPlayItemDisplayTitle(), "-")== -1){
			mytitle = getPlayItemDisplayTitle();
		}
		else{
			mytitle = getToken(getPlayItemDisplayTitle(), "- ",  1);
		}
	}
	line3.setXmlParam("text", mytitle);
	
	lyrFx.fx_setEnabled(1);
	lyrFxFG.fx_setEnabled(1);
	lyrFx.fx_restart();
	lyrFxFG.fx_restart();
	
	//for fading the album in
	//FadeGroup(cdboxHolder, 255);
	
	
}