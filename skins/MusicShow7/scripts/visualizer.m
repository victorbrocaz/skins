/*---------------------------------------------------
-----------------------------------------------------
Filename:	visualizer.m
Version:	1.0

Type:		maki
Date:		23. Nov. 2006 - 21:37 
Author:		Martin Poehlmann aka Deimos
E-Mail:		martin@skinconsortium.com
Internet:	www.skinconsortium.com
		www.martin.deimos.de.vu
-----------------------------------------------------
---------------------------------------------------*/

#include <lib/std.mi>

Function setVis (int mode);
Function ProcessMenuResult (int a);
Function colorVis (boolean full);

Global Group scriptGroup;
Global Vis visualizer;
Global Layer trigger;
Global PopUpMenu visMenu;
Global PopUpMenu specmenu;
Global PopUpMenu oscmenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu stylemenu;

Global string colorbandfull = "255,0,255", colorbandtop = "255,0,255", colorbandbottom = "255,0,255";
Global Int currentMode, a_falloffspeed, p_falloffspeed, a_coloring;
Global Boolean show_peaks;

System.onScriptLoaded()
{ 
	scriptGroup = getScriptGroup();

	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 2);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer peaks falloff", 1);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring", 1);

	visualizer = scriptGroup.findObject("main.vis");
	trigger = scriptGroup.findObject("main.vis.over");

	string p = System.getParam();
	colorbandfull = getToken(p, ";", 2);
	colorbandbottom = getToken(p, ";", 0);
	colorbandtop = getToken(p, ";", 1);

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));

	if (a_coloring == 0)
	{
		colorVis(1);
		visualizer.setXmlParam("coloring", "normal");
	}
	else if (a_coloring == 1)
	{
		colorVis(0);
		visualizer.setXmlParam("coloring", "normal");
	}
	else if (a_coloring == 2)
	{
		colorVis(0);
		visualizer.setXmlParam("coloring", "Fire");
	}
	else if (a_coloring == 3)
	{
		colorVis(0);
		visualizer.setXmlParam("coloring", "Fine");
	}

	setVis (currentMode);

	visualizer.show();
	trigger.show();
}

trigger.onLeftButtonUp (int x, int y)
{
	currentMode++;

	if (currentMode == 6)
	{
		currentMode = 0;
	}

	setVis	(currentMode);
}

trigger.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;
	specmenu = new PopUpMenu;
	oscmenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;

	visMenu.addCommand("Presets:", 999, 0, 1);
	visMenu.addCommand("No Visualization", 100, currentMode == 0, 0);
	specmenu.addCommand("Thick Bands", 1, currentMode == 1, 0);
	specmenu.addCommand("Thin Bands", 2, currentMode == 2, 0);
	visMenu.addSubMenu(specmenu, "Spectrum Analyzer");

	oscmenu.addCommand("Solid", 3, currentMode == 3, 0);
	oscmenu.addCommand("Dots", 4, currentMode == 4, 0);
	oscmenu.addCommand("Lines", 5, currentMode == 5, 0);
	visMenu.addSubMenu(oscmenu, "Oscilloscope");

	visMenu.addSeparator();
	visMenu.addCommand("Options:", 102, 0, 1);
	visMenu.addCommand("Show Peaks", 101, show_peaks == 1, 0);
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);
	visMenu.addSubMenu(pksmenu, "Peak Falloff Speed");
	anamenu.addCommand("Slower ", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow ", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate ", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast ", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster ", 304, a_falloffspeed == 4, 0);
	visMenu.addSubMenu(anamenu, "Analyzer Falloff Speed");
	stylemenu.addCommand("Full", 400, a_coloring == 0, 0);
	stylemenu.addCommand("Gradient", 401, a_coloring == 1, 0);
	stylemenu.addCommand("Fire", 402, a_coloring == 2, 0);
	stylemenu.addCommand("Line", 403, a_coloring == 3, 0);
	visMenu.addSubMenu(stylemenu, "Analyzer Coloring");


	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;
	delete specmenu;
	delete oscmenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;

	complete;	
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		visualizer.setXmlParam("peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

	else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			colorVis(1);
			visualizer.setXmlParam("coloring", "normal");
		}
		else if (a_coloring == 1)
		{
			colorVis(0);
			visualizer.setXmlParam("coloring", "normal");
		}
		else if (a_coloring == 2)
		{
			colorVis(0);
			visualizer.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			colorVis(0);
			visualizer.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring", a_coloring);
	}

}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		visualizer.setMode(0);
	}
	else if (mode == 1)
	{
		visualizer.setXmlParam("bandwidth", "wide");
		visualizer.setMode(0);
		visualizer.setMode(1);
	}
	else if (mode == 2)
	{
		visualizer.setXmlParam("bandwidth", "thin");
		visualizer.setMode(0);
		visualizer.setMode(1);
	}
	else if (mode == 3)
	{
		visualizer.setXmlParam("oscstyle", "solid");
		visualizer.setMode(2);
	}
	else if (mode == 4)
	{
		visualizer.setXmlParam("oscstyle", "dots");
		visualizer.setMode(2);
	}
	else if (mode == 5)
	{
		visualizer.setXmlParam("oscstyle", "lines");
		visualizer.setMode(2);
	}
	currentMode = mode;
}

colorVis(boolean full)
{
	if (full)
	{
		for ( int i = 1; i <= 16; i++ )
		{
			visualizer.setXmlParam("colorband" + integerToString(i), colorbandfull);
		}
	} 
	else
	{
		int Rtop = getToken(colorbandtop, ",", 0);
		int Gtop = getToken(colorbandtop, ",", 1);
		int Btop = getToken(colorbandtop, ",", 2);

		int Rbottom = getToken(colorbandbottom, ",", 0);
		int Gbottom = getToken(colorbandbottom, ",", 1);
		int Bbottom = getToken(colorbandbottom, ",", 2);
		
		for ( int i = 1; i <= 16; i++ )
		{
			visualizer.setXmlParam("colorband" + integerToString(i), integerToString(Rbottom + (Rtop-Rbottom)/15 * (i-1)) + "," + integerToString(Gbottom + (Gtop-Gbottom)/15 * (i-1)) + "," + integerToString(Bbottom + (Btop-Bbottom)/15 * (i-1)));
		}
	}
}