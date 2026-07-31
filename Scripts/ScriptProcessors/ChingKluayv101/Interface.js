//TODO
//ADD VOLUYME KNOB


Content.makeFrontInterface(800, 400);

// References
const var Sampler0 = Synth.getSampler("sampler0");
const var sampleMaps = Sampler0.getSampleMapList();
const var cmbSampleMap = Content.getComponent("cmbSampleMap");

// Create a hidden panel strictly to listen for sample loading
const var pnlLoader = Content.addPanel("pnlLoader", 0, 0);
pnlLoader.set("visible", false); 

// Populate combo box with sample maps
cmbSampleMap.set("items", sampleMaps.join("\n"));

// Function to update virtual keyboard key colors
inline function updateKeyColors()
{
    for (i = 0; i < 128; i++)
    {
        if (Sampler0.isNoteNumberMapped(i))
        {
            Engine.setKeyColour(i, Colours.withAlpha(Colours.red, 0.3));
        }
        else
        {
            Engine.setKeyColour(i, Colours.withAlpha(Colours.white, 0.0));
        }
    }
}

// 1. Trigger the map load when the combobox changes
inline function oncmbSampleMapControl(component, value)
{
    if (value > 0)
    {
        // This starts the background loading process
        Sampler0.loadSampleMap(sampleMaps[value - 1]); 
    }
}
cmbSampleMap.setControlCallback(oncmbSampleMapControl);


// 2. Define the loading callback function with a proper name
inline function onSampleLoad(isPreloading)
{
    // isPreloading becomes 'false' the exact moment the new samples finish loading
    if (!isPreloading)
    {
        updateKeyColors();
    }
}

// 3. Assign the named function to the panel's loading callback
pnlLoader.setLoadingCallback(onSampleLoad);

// timer shit
// thanks though
const var TIMER_VAR = Engine.createTimerObject();

TIMER_VAR.setTimerCallback(function()
{
    onSampleLoad(false);
    TIMER_VAR.stopTimer();
});

TIMER_VAR.startTimer(500);





/*
Legacy code too show that I'm too dumb to code atm

Content.makeFrontInterface(800, 400);


// My Sample Map on Combobox
const var sampleMaps = Sampler.getSampleMapList(); // get a Sample Map List
const var cmbSampleMap = Content.getComponent("cmbSampleMap"); //combo box
const var Sampler0 = Synth.getChildSynth("sampler0"); // Sampler Reference

// populate combo box with sample maps
cmbSampleMap.set("items", sampleMaps.join("\n"));

inline function oncmbSampleMapControl(component, value)
{
	//Console.print(value);
	Sampler0.asSampler().loadSampleMap(sampleMaps[value-1]);
	for (i = 0; i < 127; i++)
	
	
	 if (Sampler0.asSampler().isNoteNumberMapped(i))
	    Engine.setKeyColour(i, Colours.withAlpha(Colours.red, 0.3));
	    else
	   Engine.setKeyColour(i, Colours.withAlpha(Colours.white, 0.0));
	
};

Content.getComponent("cmbSampleMap").setControlCallback(oncmbSampleMapControl);


*/




function onNoteOn()
{
	
}
 function onNoteOff()
{
	
}
 function onController()
{
	
}
 function onTimer()
{
	
}
 function onControl(number, value)
{
	
}
 