// heavily borrowing from Engine_Convolution by Hank Yates -> https://github.com/hankyates/norns-convolution-reverb
// thank you!

Engine_Nirns : CroneEngine {
  var bufsize, irL, irR, convolution;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

// allocate memory to the following

  alloc {

// set fft size

//~fftsize = 4096;
~fftsize = 2048;
//  ~fftsize = 1024;

// load the impule response files for both channels
  
    irL = Buffer.readChannel(context.server, "/home/we/dust/audio/ir/circularoutput.wav", channels: [0]);
    irR = Buffer.readChannel(context.server, "/home/we/dust/audio/ir/circularoutput.wav", channels: [1]);

//    irL = Buffer.readChannel(context.server, "/home/we/dust/audio/ir/bottledungeon.wav", channels: [0]);
//    irR = Buffer.readChannel(context.server, "/home/we/dust/audio/ir/bottledungeon.wav", channels: [1]);
    
//    irL = Buffer.readChannel(context.server, "/home/we/dust/audio/tehn/mancini1.wav", channels: [0]);
//    irR = Buffer.readChannel(context.server, "/home/we/dust/audio/tehn/mancini1.wav", channels: [1]);

    context.server.sync;
    
// determine and set buffer size

    bufsize = PartConv.calcBufSize(~fftsize, irL);

    ~irBufL = Buffer.alloc(context.server, bufsize, 1);
    ~irBufL.preparePartConv(irL, ~fftsize);

    ~irBufR = Buffer.alloc(context.server, bufsize, 1);
    ~irBufR.preparePartConv(irR, ~fftsize);

    context.server.sync;

// clear time domain data, keep spectral version

    irL.free;
    irR.free;
    
// add SynthDefs

    SynthDef(\Nirns, {
      arg dry, wet;

      var sigL = SoundIn.ar(0);
      var sigR = SoundIn.ar(1);

      var verbL = PartConv.ar(sigL, ~fftsize, ~irBufL.bufnum);
      var verbR = PartConv.ar(sigR, ~fftsize, ~irBufR.bufnum);

      var outL = Mix([sigL * dry, verbL * wet * 0.2]);
      var outR = Mix([sigR * dry, verbR * wet * 0.2]);

      Out.ar(0, [outL, outR]);

    }).add;
    
    
// 

    convolution = Synth.new(\Nirns, [
      \dry, 0,
      \wet, 0
    ], target: context.xg);
    
// add commands that lua layer can control
    
    this.addCommand("dry", "f", { arg msg;
      convolution.set(\dry, msg[1]);
    });

    this.addCommand("wet", "f", { arg msg;
      convolution.set(\wet, msg[1]);
    });
    
    
    
        
// not working:    
// JackDriver: exception in real time: alloc failed, increase server's memory allocation (e.g. via ServerOptions)
// PartConv Error: Spectral data buffer not allocated 
// testing spectrum clear - run when exiting script or loading new IR  
//    this.addCommand("spectrum_clear", { arg msg;
//      ~irBufR.free; 
//      ~irBufL.free;
//    });
    


   } 
   
    free {
    convolution.free;
    ~irBufR.free;
    ~irBufL.free;
  }

}