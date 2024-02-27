# N(IR)NS
- a convolution reverb / cross-synthesis sound mixer
- traditional reverb effects but also sonic play-doh

# resources:
- [PartConv | SuperCollider](https://doc.sccode.org/Classes/PartConv.html)
- [convolution_reverb.scd -  schollz/supercollisions · GitHub](https://github.com/schollz/supercollisions/blob/main/convolution_reverb.scd)
- [here are](https://www.openair.hosted.york.ac.uk/?page_id=36) some impulse response files (make sure to convert to 48khz before using - [this makes quick work of the task](https://onlineaudioconverter.com/)) 
- [GitHub - hankyates/norns-convolution-reverb](https://github.com/hankyates/norns-convolution-reverb) - existing partconv project. Termendously helpful in getting me started. Thank you 

# pieces:
- SC partconv 
- Norns file select / load
	- load (IR) file
- Audio input
- mix control (dry / IR wet)
- later - page to record (IR) - tape call? + save - waveform display

# details:
- [PartConv.ar](https://doc.sccode.org/Classes/PartConv.html)(in, fftsize, irbufnum, mul: 1.0, add: 0.0)
	- in - processing target.
	- fftsize - spectral convolution partition size (twice partition size). You must ensure that the blocksize divides the partition size and there are at least two blocks per partition (to allow for amortization).
	- irbufnum - prepared buffer of spectra for each partition of the impulse response.
- Undocumented class methods
	- PartConv.[calcBufSize](https://doc.sccode.org/Overviews/Methods.html#calcBufSize)(fftsize, irbuffer)
	- PartConv.[calcNumPartitions](https://doc.sccode.org/Overviews/Methods.html#calcNumPartitions)(fftsize, irbuffer)

# to do:
- [ ] determine file size limits (24s - way too big, but what is a sensible cutoff?)
	- `impulse response can be as large as you like (CPU load increases with IR size. Various tradeoffs based on fftsize choice, due to rarer but larger FFTs. This plug-in uses amortisation to spread processing and avoid spikes).`
	- how can i help optimize performance?
- [ ] _bug_ have to adjust wet and dry controls after IR file load to hear effect.
- [ ] fix volume issue (some IR files are way louder than others)
	- (might need a input volume control pre conv and an output control)
 - [ ] add more IR files (check out [creative convolution thread](https://llllllll.co/t/creative-convolution-share-your-impulse-responses/33495))
- [ ] whats the best way to bundle audio files with scripts??
- [ ] buffer number in debug increases every time a new IR is loaded - is that to be expected or a bug?
- [ ] ir file pre load processing (normalize, start/end, trim to size - might need to add fade(tail), preview, etc)
- [ ] waveform display + related features

## archive:
- [x] file select and load to ir buffer/convert to spectrum (48khz files only!)
	- if you load a new IR, you will need to dump previous buffer
- [x] figure out how to clear buffers / spectrums / etc
- [x] -bug- have to load script twice for synthdef / ir's to load. I think this has to do with the ir file/spectrums not being generated as soon as script loads
- [x] working supercollider example
- [x] build most basic version for norns 
- [x] add basic controls (wet, dry)

