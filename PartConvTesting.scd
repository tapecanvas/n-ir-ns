

// preparation; essentially, allocate an impulse response buffer, then
// follow a special buffer preparation step to set up the data the plugin needs.
// Different options are provided commented out for loading impulse responses from soundfiles.
(
​
 // also 4096 works on my machine; 1024 too often and amortisation too pushed, 8192 more high load FFT
~fftsize = 4096;
​
s.waitForBoot {
​
    {
        var ir, irbuffer, bufsize;
​
        // // MONO ONLY
        // pre-existing impulse response sound files
        // (could also use any general soundfile too for cross-synthesis effects)

        irbuffer = Buffer.read(s, "/Users/tape/Documents/SuperCollider/IR/bottledungeon_omni.wav");

	//irbuffer = Buffer.read(s, "/Users/tape/Documents/SuperCollider/IR/circularoutput.wav");

	//	irbuffer = Buffer.read(s, "/Users/tape/Documents/SuperCollider/IR/SM57.wav");
​
​

​
        s.sync;
​
        bufsize = PartConv.calcBufSize(~fftsize, irbuffer);
​
        // ~numpartitions= PartConv.calcNumPartitions(~fftsize, irbuffer);
​
        ~irspectrum = Buffer.alloc(s, bufsize, 1);
        ~irspectrum.preparePartConv(irbuffer, ~fftsize);
​
        s.sync;
​
        irbuffer.free; // don't need time domain data anymore, just needed spectral version
    }.fork;
​
}
)

​
~target = Buffer.read(s, Platform.resourceDir +/+ "IR/bottledungeon_omni.wav");
//~target = Buffer.read(s, Platform.resourceDir +/+ "IR/circularoutput.wav");
//~target = Buffer.read(s, Platform.resourceDir +/+ "IR/SM57.wav");
​
(
{
    var input = PlayBuf.ar(1, ~target, loop:1);
    PartConv.ar(input, ~fftsize, ~irspectrum.bufnum, 0.5)
}.play
)
​
​
// convolve with live input
(
{
    var input = SoundIn.ar(0,0.05);
    PartConv.ar(input, ~fftsize, ~irspectrum.bufnum)
}.play
)
​
​
// should get back original impulse response (once every four seconds)
(
{
    var input = Impulse.ar(0.25);
    PartConv.ar(input, ~fftsize, ~irspectrum.bufnum)
}.play
)
​
​
// only free buffers once you're finished with examples
// if you free whilst PartConv is still running, the server won't crash, but PartConv output will go to zero abruptly
(
~irspectrum.free;
~target.free;
currentEnvironment.clear;
)



// first, run the first section to load the IR
// then the live input bit and listen and make sound



