Intro
=====

The instructions herein are valid for the FriendlyARM NanoPi NEO,
both the 256MiB and 512MiB versions. They should also work for the
NanoPi NEO Air, but this is untested so far.

The FriendlyARM Nanopi NEO is a 4x4cm² board with an Allwiner H3 SoC:
  - quad-core Cortex-A7 @1.2GHz
  - 256 or 512MiB of DDR
  - uSDCard as only storage option
  - 3x USB 2.0 host (one socket, two on expansion pin-holes)
  - 1x USB 2.0 OTG (also used as power source)
  - 10/100 ethernet MAC
  - GPIOs, SPI, I2c...

Support for the Nanopi NEO in U-Boot and Linux is very recent, so only
core, basic features are available.

Unfortunately, support for the USB OTG is not
yet upstream, but is being actively worked on.

Two cores have been reserved for running high priority tasks using isolcpus=2,3 in boot.cmd.

How to build
============

    $ make nanopi_neo_synth_buildroot_defconfig
    $ make

Note: you will need access to the internet to download the required
sources.

You will then obtain an image ready to be written to your micro SDcard:

    $ dd if=output/images/sdcard.img of=/dev/sdX bs=1M
    
    You can also use Etcher: https://etcher.io/

Notes:
  - replace 'sdX' with the actual device with your micro SDcard,
  - you may need to be root to do that (use 'sudo').

Insert the micro SDcard in your NanoPi NEO and power it up. The console
is on the serial line, 115200 8N1.
