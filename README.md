# nanopi_neo_synth_buildroot
Patches and build procedure for generating a bootable linux image with puredata, xauth, usb sound card, and ethernet support.

## Prerequisites
To use buildroot on a debian system you'll need:

  `sudo apt-get -y install build-essential gcc g++ binutils make screen libncurses5-dev`
  
To build the realtime legacy image you should use xenial 16.04 (a virtual machine is fine). It is based on the Armbian team's [dedicated work](https://docs.armbian.com/Developer-Guide_Build-Preparation/). Support them if you use this image, I couldn't have assembled it without them. 

Extra dependencies for the legacy image are python2.7 and screen. 

## Building
In the git directory: 

`./create_img.sh`

This will download buildroot, unpack it, patch it, and create the packages/kernel/image. 

Then move post-post-build.sh to the images/ directory and run it as root. Some config settings don't get properly set. 

To build legacy:

`./create_3.4.112-rt_img.sh`

This will download buildroot, a linaro toolchain, an old commit from Armbian's linux branch when the realtime patch was working, compile the image, run some fixes on the image post-build, and exit. 

## Installing
If you don't want to try building, unzip the img with

`unzip nanopi_buildroot.zip`

Github wont allow files over 25mb, so the legacy kernel image can be found at [this google drive link](https://drive.google.com/file/d/0B42tAZ6A-UbDVnQ3TzctVERzcjg/view?usp=sharing)

If built, the image will be at images/sdcard.img. You can copy this over using either dd or etcher. 

` dd if=images/sdcard.img of=/dev/sdX bs=1M`

Etcher can be found [here](https://etcher.io/). 

## Using
The default login is root/root. You can change this with make menuconfig, under 

`System Configuration --->
  () Root Password
`

Login with the -X flag for ssh and you can start puredata (pd). It helps to run pd with the -rt flag.

If you'd like more control over your cpus, you can add "isolcpus=x,y" in the boot.cmd and compile with:

`mkimage -C none -A arm -T script -d boot.cmd boot.scr`

This isolates whichever CPUs you want (don't isolate 0, your first cpu). No tasks will run on them unless explicity told to using taskset. This would be used for audio interrupts and the puredata patches. Another useful command is chrt. I admit that this might be wishful thinking/overkill. 

## Benefits
Buildroot uses only what is needed, and nothing more. 
* Boots in roughly 4 seconds (less with uboot delay at 0). 
* Uses 8Mb of ram running puredata over X11 forwarding in mainline kernel (20mb in legacy)
* Absolute package control


## Why?
I wanted a lightweight image running only the bare essentials for audio. The nanopi neo is a cheap computer with either 256 or 512 Mb of RAM, runs at about 3-4 watts, and has a quad core H3 chip. 

I understand the H3 is not well supported in mainline, so this does not currently support the integrated audio codec. The board has line out audio and a mic input, but I'd rather use a USB soundcard. A $2 CM108 was the used for initial testing, and a PCM2906 based sound card worked well. The PCM2906 is a usb codec on a chip, with only a few passives and an oscillator to function.

## Improvements
Support for USB gadget devices are available in the kernel, but I haven't tested it. I can see use cases for MIDI, mass storage, and ethernet. 
If a realtime patch ever comes out for 4.11.x it would be interesting to see if it improves IO performance. 

I have added the legacy image, but it is rather large, as Armbian's community builds debian images to handle anything a user might throw at it. Stripping away unnecessary modules will be a time consuming process but ultimately worth it. 

Turning off subsystem not in use will save some thermal overhead. This would be done using fex files in legacy. 

