The FriendlyARM Nanopi NEO is a 4x4cm² board with an Allwiner H3 SoC:
  - quad-core Cortex-A7 @1.2GHz
  - 256 or 512MiB of DDR
  - uSDCard as only storage option
  - 3x USB 2.0 host (one socket, two on expansion pin-holes)
  - 1x USB 2.0 OTG (also used as power source)
  - 10/100 ethernet MAC
  - GPIOs, SPI, I2c...

Confirmed working are USB OTG (legacy and configfs), ethernet (100M), GPIO functions (via sysfs), and SPI (using FBTFT library).

Two cores have been reserved for running high priority tasks using isolcpus=2,3 in boot.cmd.

Uboot's Bootdelay has been reduced to zero for faster boot times.

With S40network disabled in /etc/init.d, it boots in roughly 4 seconds. 

These config files create a working 4.13 PREEMPT RT kernel for the Nanopi Neo.



Improvements/TODO:

Test I2C
Stress test USB OTG
