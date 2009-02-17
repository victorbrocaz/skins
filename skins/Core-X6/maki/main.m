#include </lib/std.mi>
#include </lib/config.mi>

#define WINDOW_ITEMS "{6559CA61-7EB2-4415-A8A9-A2AEEF762B7F}"
#define OPTIONS_MENU "{1828D28F-78DD-4647-8532-EBA504B8FC04}"
#define MY_OPT_MENU "{3448EFC7-D134-4F2B-BFA6-B8FC5AB48089}"

// songticker config page
#define CUSTOM_PAGE_SONGTICKER "{7061FDE0-0E12-11D8-BB41-0050DA442EF3}"


// MyChange is used by several functions to indicate, the changes are by the script
Global int MyChange;

//Declare vis animated layers
Global AnimatedLayer lyrVis1;
Global AnimatedLayer lyrVis2;
Global AnimatedLayer lyrVis3;
Global AnimatedLayer lyrVis4;
Global AnimatedLayer lyrVis5;
Global AnimatedLayer lyrVis6;
Global AnimatedLayer lyrVis7;
Global AnimatedLayer lyrVis8;
Global AnimatedLayer lyrVis9;
Global AnimatedLayer lyrVis10;
Global AnimatedLayer lyrVis11;
Global AnimatedLayer lyrVis12;
Global AnimatedLayer lyrVis13;
Global AnimatedLayer lyrVis14;
Global AnimatedLayer lyrVis15;
Global AnimatedLayer lyrVis16;
Global AnimatedLayer lyrVis17;
Global AnimatedLayer lyrVis18;
Global AnimatedLayer lyrVis19;
Global AnimatedLayer lyrVis20;
Global AnimatedLayer lyrVis21;
Global GuiObject Ticker;

Global Group grpCover;
Global Group grpEq;
Global Layer btnCoverButton;
Global Button btnCoverStar1, btnCoverStar2, btnCoverStar3, btnCoverStar4, btnCoverStar5;

Global Layer lyrEQButton;

Global Button btnMNCrossfade, btnMNShuffle, btnMNRepeat;

Global Layer PNBackground;
Global Layer LCDCrossfade;
Global Layer LCDShuffle;
Global Layer LCDRepeat;
Global Layer LCDMute;
Global Layer CoverMap;

Global Button btnMNPlay;
Global Layer lyrMNPlayDown, lyrMNPlayLight;

Global Slider sldEqBass;
Global Slider sldEqMiddle;
Global Slider sldEqTremble;

Global Timer tmrVis;
Global Timer tmrPlay2Pause;

Global Int PrevValues1, PrevValues2, PrevValues3, PrevValues4, PrevValues5, PrevValues6, PrevValues7;
Global Int PrevValues8, PrevValues9, PrevValues10, PrevValues11, PrevValues12, PrevValues13, PrevValues14;
Global Int PrevValues15, PrevValues16, PrevValues17, PrevValues18, PrevValues19, PrevValues20, PrevValues21;

Global ConfigAttribute cattrDA;
Global ConfigAttribute cattrAlbumArt;
Global ConfigAttribute cattrEq;

#include "play2pause.m"
#include "songinfo.m"
#include "coverdrawer.m"
#include "keyboard.m"
#include "eqdrawer.m"

function SetVisFrame (animatedlayer vislayer, int Length, int BandStart, int BandStop, int PrevValue, int Offset);

System.onScriptLoaded() {

	Container cntMain = System.getContainer("main");
	Layout lytMainNormal = cntMain.GetLayout("normal");
	Group grpPlayerNormal = lytMainNormal.GetObject("player.normal.group");
	Group grpLCD = grpPlayerNormal.GetObject("player.normal.LCD");

	grpCover = lytMainNormal.GetObject("player.normal.drawer.cover"); // Cover art drawer
	grpEq = lytMainNormal.GetObject("player.normal.drawer.eq"); // Equalizer drawer
	PNBackground = lytMainNormal.getObject("background");
	
	// Getting vis layers
	lyrVis1 = grpLCD.getObject("vis1");
	lyrVis2 = grpLCD.getObject("vis2");
	lyrVis3 = grpLCD.getObject("vis3");
	lyrVis4 = grpLCD.getObject("vis4");
	lyrVis5 = grpLCD.getObject("vis5");
	lyrVis6 = grpLCD.getObject("vis6");
	lyrVis7 = grpLCD.getObject("vis7");
	lyrVis8 = grpLCD.getObject("vis8");
	lyrVis9 = grpLCD.getObject("vis9");
	lyrVis10 = grpLCD.getObject("vis10");
	lyrVis11 = grpLCD.getObject("vis11");
	lyrVis12 = grpLCD.getObject("vis12");
	lyrVis13 = grpLCD.getObject("vis13");
	lyrVis14 = grpLCD.getObject("vis14");
	lyrVis15 = grpLCD.getObject("vis15");
	lyrVis16 = grpLCD.getObject("vis16");
	lyrVis17 = grpLCD.getObject("vis17");
	lyrVis18 = grpLCD.getObject("vis18");
	lyrVis19 = grpLCD.getObject("vis19");
	lyrVis20 = grpLCD.getObject("vis20");
	lyrVis21 = grpLCD.getObject("vis21");

	ConfigItem cfgDA = Config.getItemByGuid("{9149C445-3C30-4E04-8433-5A518ED0FDDE}");
	cattrDA = cfgDA.getAttribute("Enable desktop alpha");

	ConfigItem cfgWindows = Config.GetItemByGuid(WINDOW_ITEMS); // Toggle Windows menu
	cattrAlbumArt = cfgWindows.getAttribute("Album Art\tAlt+A");
	cattrEq = cfgWindows.getAttribute("Equalizer\tAlt+G");

	Ticker = grpLCD.getObject("ticker");

	btnMNPlay = grpPlayerNormal.getObject("play2pause");
	lyrMNPlayDown = grpPlayerNormal.getObject("play2pause.pressed");
	lyrMNPlayLight = grpPlayerNormal.getObject("play2pause.light");
	tmrPlay2Pause = new Timer;
	
	btnMNCrossfade = grpPlayerNormal.getObject("crossfade");
	btnMNShuffle = grpPlayerNormal.getObject("shuffle");
	btnMNRepeat = grpPlayerNormal.getObject("repeat");

	LCDCrossfade = grpLCD.getObject("status.crossfade");
	LCDShuffle = grpLCD.getObject("status.shuffle");
	LCDRepeat = grpLCD.getObject("status.repeat");

	CoverMap = grpCover.getObject("noalpha.map");
	btnCoverButton = grpCover.getObject("button");

	//rating stars
	btnCoverStar1 = grpCover.getObject("star.1");
	btnCoverStar2 = grpCover.getObject("star.2");
	btnCoverStar3 = grpCover.getObject("star.3");
	btnCoverStar4 = grpCover.getObject("star.4");
	btnCoverStar5 = grpCover.getObject("star.5");

	// Eq declarations
	lyrEQButton = grpEq.getObject("button"); // Open/Close Button (It is really a layer)

	sldEqBass = grpEq.getObject("bit.bass");
	sldEqMiddle = grpEq.getObject("bit.mids");
	sldEqTremble =grpEq.getObject("bit.high");


	tmrVis = new Timer;
	tmrVis.SetDelay(30);
	tmrVis.Start();
	tmrVis.OnTimer();

	if (cattrDA.getData() == "1")
	{
		PNBackground.setXMLparam("image","player.normal.background.bitmap");
		CoverMap.Hide();
		btnCoverButton.setXMLparam("image","player.normal.cover.button");
		lyrEQButton.setXMLparam("image","player.normal.eq.button");
	}
	
// All included scripts have something to load when skin is loading, so included scripts have @Name@OnLoaded() functions, called below
	play2pauseOnLoaded();
	songinfoOnLoaded();
	coverdrawerOnLoaded();
	eqdrawerOnLoaded();
	keyboardOnLoaded();

}

cattrDA.OnDataChanged()
{
	if (cattrDA.getData() == "0")
	{
		PNBackground.setXMLparam("image","player.normal.background.noalpha.bitmap");
		CoverMap.Show();
		btnCoverButton.setXMLparam("image","player.normal.cover.button.noalpha");
		lyrEQButton.setXMLparam("image","player.normal.eq.button.noalpha");
	}
	if (cattrDA.getData() == "1")
	{
		PNBackground.setXMLparam("image","player.normal.background.bitmap");
		CoverMap.Hide();
		btnCoverButton.setXMLparam("image","player.normal.cover.button");
		lyrEQButton.setXMLparam("image","player.normal.eq.button");
	}
}

tmrVis.OnTimer(){
	PrevValues1 = SetVisFrame(lyrVis1, 3, 0, 2, PrevValues1, 0);
	PrevValues2 = SetVisFrame(lyrVis2, 6, 3, 6, PrevValues2, 0);
	PrevValues3 = SetVisFrame(lyrVis3, 8, 7, 9, PrevValues3, 0);
	PrevValues4 = SetVisFrame(lyrVis4, 10, 10, 13, PrevValues4, 0);
	PrevValues5 = SetVisFrame(lyrVis5, 11, 14, 16, PrevValues5, 0);
	PrevValues6 = SetVisFrame(lyrVis6, 12, 17, 20, PrevValues6, 0);
	PrevValues7 = SetVisFrame(lyrVis7, 13, 21, 24, PrevValues7, 0);
	PrevValues8 = SetVisFrame(lyrVis8, 14, 25, 27, PrevValues8, 0);
	PrevValues9 = SetVisFrame(lyrVis9, 14, 28, 31, PrevValues9, 0);
	PrevValues10 = SetVisFrame(lyrVis10, 14, 32, 34, PrevValues10, 0);
	PrevValues11 = SetVisFrame(lyrVis11, 15, 35, 38, PrevValues11, 0);
	PrevValues12 = SetVisFrame(lyrVis12, 15, 39, 41, PrevValues12, 0);
	PrevValues13 = SetVisFrame(lyrVis13, 15, 42, 45, PrevValues13, 0);
	PrevValues14 = SetVisFrame(lyrVis14, 15, 46, 48, PrevValues14, 0);
	PrevValues15 = SetVisFrame(lyrVis15, 15, 49, 51, PrevValues15, 0);
	PrevValues16 = SetVisFrame(lyrVis16, 15, 52, 54, PrevValues16, 0);
	PrevValues17 = SetVisFrame(lyrVis17, 15, 55, 57, PrevValues17, 0);
	PrevValues18 = SetVisFrame(lyrVis18, 15, 58, 60, PrevValues18, 0);
	PrevValues19 = SetVisFrame(lyrVis19, 14, 61, 64, PrevValues19, 0);
	PrevValues20 = SetVisFrame(lyrVis20, 13, 65, 67, PrevValues20, 0);
	PrevValues21 = SetVisFrame(lyrVis21, 11, 68, 70, PrevValues21, 0);
}

SetVisFrame(animatedlayer vislayer, int Length, int BandStart, int BandStop, int PrevValue, int Offset) {

	boolean playing = 0;
	If (System. getStatus()!= 0) playing = 1;
	double BandValue;
	int i;
	For (i=BandStart;i<=BandStop;i++) {BandValue = BandValue + System.getVisBand(0, i);}
	BandValue = playing*BandValue;
	If (PrevValue > BandValue) BandValue = (PrevValue * 4/5) + (BandValue / 5); // Using the old values too
	PrevValue = BandValue;
	BandValue = BandValue / 255 / (BandStop - BandStart);
	int newFrame = Integer(BandValue * Length) + Offset;
	If (newFrame >= Length) newFrame = Length - 1;
	If (newFrame < 0) newFrame = 0;
	vislayer.gotoFrame(newFrame);	
	return PrevValue;
}

System.onTitleChange(String newtitle)
{
	coverDrawerOnTitleChange(newtitle);
}

System.onScriptUnLoading() {
	Delete tmrVis;
	Delete tmrPlay2Pause;
}