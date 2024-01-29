# brain dump:
- IR file doesn't have to be a true IR
- include a few preloaded IRs (deep listening cistern?)

# questions:
- can I make it stereo?
	- according to PartConv details: `Mono impulse response only! If inputting multiple channels, you'll need independent PartConvs, one for each channel.`
- what would making the IR file loop do?
	- what about granularizing it?
- what are the size limits? (make it run okay on pi3b+)
	- `impulse response can be as large as you like (CPU load increases with IR size. Various tradeoffs based on fftsize choice, due to rarer but larger FFTs. This plug-in uses amortisation to spread processing and avoid spikes).`

# resources:
- [PartConv | SuperCollider](https://doc.sccode.org/Classes/PartConv.html)
- [convolution_reverb.scd -  schollz/supercollisions · GitHub](https://github.com/schollz/supercollisions/blob/main/convolution_reverb.scd)
- [here are](https://www.openair.hosted.york.ac.uk/?page_id=36) some impulse response files
- [GitHub - hankyates/norns-convolution-reverb](https://github.com/hankyates/norns-convolution-reverb) - existing partconv project. Termendously helpful in getting me started. Thank you 

# pieces:
- SC partconv 
- Norns file select / load
	- load (IR) file
		- normalize / compress option to boost tail effects
		- choose start and end points
		- Maybe add a bit about length or file size
		- Be able to trim file to fit requirements?
- Audio input (might need a input volume control pre conv. - first test in sc was a lil blown out and needed 0.05 mul value on headset mic) 
- waveform display
- mix control (dry / IR wet)
- later - page to record (IR) - tape call? + save

# details:
- [PartConv.ar](https://doc.sccode.org/Classes/PartConv.html)(in, fftsize, irbufnum, mul: 1.0, add: 0.0)
	- in - processing target.
	- fftsize - spectral convolution partition size (twice partition size). You must ensure that the blocksize divides the partition size and there are at least two blocks per partition (to allow for amortization).
	- irbufnum - prepared buffer of spectra for each partition of the impulse response.
- Undocumented class methods
	- PartConv.[calcBufSize](https://doc.sccode.org/Overviews/Methods.html#calcBufSize)(fftsize, irbuffer)
	- PartConv.[calcNumPartitions](https://doc.sccode.org/Overviews/Methods.html#calcNumPartitions)(fftsize, irbuffer)

 # to do:
 - [x] working supercollider example
 - [x] build most basic version for norns 
 - [x] add basic controls (wet, dry)
 - [ ] put bundled IR files in /lib and update paths (easier for beta testing)
 - [ ] file select and load to ir buffer/convert to spectrum (48khz files only!)
	- if you load a new IR, you will need to dump previous buffer
		- [ ] figure out how to clear buffers / spectrums / etc
- [ ] waveform display + related features
 - [ ] tweak and add features
 - [ ] feedback

# bugs: 
- have to load script twice for synthdef / ir's to load. 
	-  I think this has to do with the ir file/spectrums not being generated as soon as script loads
