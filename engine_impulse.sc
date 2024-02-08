Engine_Impulse : CroneEngine {
  var <bufsize, <irL, <irR, <convolution, <fftsize, <irBufL, <irBufR;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    fftsize = 2048; // Set FFT size
    
    // Initialize irBufL and irBufR with default buffers
    irBufL = Buffer.alloc(context.server, fftsize, 1);
    irBufR = Buffer.alloc(context.server, fftsize, 1);

    // Add SynthDefs
    SynthDef(\Impulse, { |dry=0, wet=0|
      var sigL = SoundIn.ar(0);
      var sigR = SoundIn.ar(1);

      var verbL = PartConv.ar(sigL, fftsize, irBufL.bufnum);
      var verbR = PartConv.ar(sigR, fftsize, irBufR.bufnum);

      var outL = Mix([sigL * dry, verbL * wet * 0.2]);
      var outR = Mix([sigR * dry, verbR * wet * 0.2]);

      Out.ar(0, [outL, outR]);
    }).add;

    // Create convolution synth
    convolution = Synth.new(\Impulse, [\dry, 0, \wet, 0], target: context.xg);

    // Add commands that Lua layer can control
    this.addCommand("dry", "f", { |msg| convolution.set(\dry, msg[1]) });
    this.addCommand("wet", "f", { |msg| convolution.set(\wet, msg[1]) });
  }

  loadIR { |file, callback|
    irL = Buffer.readChannel(context.server, file, channels: [0]);
    irR = Buffer.readChannel(context.server, file, channels: [1]);
    context.server.sync;   

    // Determine and set buffer size
    bufsize = PartConv.calcBufSize(fftsize, irL);

    // Free the original buffers
    irBufL.free;
    irBufR.free;

    // Allocate new buffers
    irBufL = Buffer.alloc(context.server, bufsize, 1);
    irBufL.preparePartConv(irL, fftsize);

    irBufR = Buffer.alloc(context.server, bufsize, 1);
    irBufR.preparePartConv(irR, fftsize);

    // Free the original synth
    convolution.free;

    // Create a new synth that uses the loaded IR
    convolution = Synth.new(\Impulse, [\dry, 0, \wet, 0], target: context.xg);

    // Call the callback function
    callback.value;

    context.server.sync;
    
    // Clear time domain data, keep spectral version
    irL.free;
    irR.free;
  }
   
  free {
    convolution.free;
    irBufR.free;
    irBufL.free;
  }
}