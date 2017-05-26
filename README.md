# nanopi_neo_synth_buildroot
Patches and build procedure for generating a bootable linux image with puredata, xauth, usb sound card, and ethernet support. 

## Prerequisites
To use buildroot on a debian system you'll need:

  `sudo apt-get -y install build-essential gcc g++ binutils make`
## Building
In the git directory: 

`./create_img.sh`

This will download buildroot, unpack it, patch it, and create the packages/kernel/image. 

Then move post-post-build.sh to the images/ directory and run it as root. Some config settings don't get properly set. 

## Installing
Unzip the img with

`unzip nanopi_buildroot.zip`


If built, the image will be at images/sdcard.img. You can copy this over using either dd or etcher. 

` dd if=images/sdcard.img of=/dev/sdX bs=1M`

Etcher can be found [here](https://etcher.io/). 

#### You will need to manually copy over the sun8i-h3-nanopi-neo.dtb to the 10Mb partition on the sd card. I have not patched that part of the build process. 

## Using
The default login is root/root. You can change this with make menuconfig, under 

`System Configuration --->
  () Root Password
`

Login with the -X flag for ssh and you can start puredata (pd). It helps to run pd with the -rt flag.

In boot.cmd the isolcpus line is for high priority interrupts and hopefully the main pd patch. You can use taskset and chrt to shift those irqs and scripts to their own dedicated core. The entire endeavor may be overkill. 

## Benefits
Buildroot uses only what is needed, and nothing more. 
* Boots in roughly 4 seconds (less with uboot delay at 0). 
* Uses 8Mb of ram running puredata over X11 forwarding
* Absolute package control


## Why?
I wanted a lightweight image running only the bare essentials for audio. The nanopi neo is a cheap computer with either 256 or 512 Mb of RAM, runs at about 3-4 watts, and has a quad core H3 chip. 

I understand the H3 is not well supported in mainline, so this does not currently support the integrated audio codec. The board has line out audio and a mic input, but I'd rather use a USB soundcard. A $2 CM108 was the used for initial testing, and a PCM2906 based sound card worked well. The PCM2906 is a usb codec on a chip, with only a few passives and an oscillator to function.

## Improvements
Support for USB gadget devices are available in the kernel, but I haven't tested it. I can see use cases for MIDI, mass storage, and ethernet. 
If a realtime patch ever comes out for 4.11.x it would be interesting to see if it improves IO performance. 

