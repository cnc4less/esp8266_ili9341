﻿\mainpage index page
\section README

@par Documentation
 * Please use this link for Documentation and this README
   @see https://rawgit.com/magore/esp8266_ili9341/master/doxygen/html/index.html
@par Copyright
 * See [COPYRIGHT.md](COPYRIGHT.md) for a full copyright notice for the project
@par Description
 * ESP8266 support libraries
   * All of the code in this project, except where noted is written by me
   * Analog Devices ADF4351 Wideband Synthesizer driver and test code
     * Control is via serial terminal that works while the other demos run
     * adf4351 123456000 10000
       * Frequency, and channel spacing used in calculations
     * adf4351_scan 144e6 145e6 10000
       * start frequency, end frequency, channel spacing
   * ILI9341 display driver 
     * Multiple custom size windows
     * Custom fonts
     * Window scrolling 
     * readPixel() function supported
     * The specific display this was tested on is a TM022HDH26 display I got from eBay.
     * Not limited by ILI9341 hardware scroll restrictions.
   * xpt2046 touch controller 
     * filtered read of XY 
     * debounced key press read of queued events
   * BDF FONT compiler tools and fonts sets 
     * Tools to creates C code used in the display drivers
   * Wireframe Viewer 
     * Code generator for Earth coastline data
     * I created two wireframe demos 
       * Cube wireframe dataset
       * Earth coastline dataset - wireframe view still needs hidden line removal option
   * CORDIC C code generator and 3D transformation code support functions use by wireframe viewer code
   * Small PRINTF with full floating point support - much smaller then GNU full version along 
   * Additional number IO functions, ATOF etc
   * WEB server using SD CARD with CGI processing - files and CGI results can be ANY SIZE!
     * Example web site for testing
     * WEB server can update TFT display
       * Simple door sign status update using web page - see html/msg.cgi and web/web.c for code
   * Network server client example for display updates
   * Uart network server client for serial uart to Network Bridge.
   * Generic queue handling code
   * ESP8266 support for FatFS by ChaN 2016 
     * SD card and microSD support
   * POSIX wrappers for FatFS - provides UNIX/LINUX file I/O operations
   * POSIX time functions and RTC set with NTP
   * Multiple timers used by RTC and time functions
   * HSPI code that can handle multiple devices each with varying clock frequencies

@par Credits
  * Project compiles using ESP Open SDK - or esp8266-devkit by CHERTS
    @see https://github.com/pfalcon/esp-open-sdk
    @see https://github.com/CHERTS/esp8266-devkit
  * Display drivers from third parties
    A few of the display driver functions are from the Adafruit GFX Library
      @see https://github.com/adafruit/Adafruit-GFX-Library
    Optimized Line drawing function and Makefile from CHERTS 
      @see https://github.com/CHERTS/esp8266-devkit/tree/master/Espressif/examples/esp8266_ili9341
  * Font sources:
    @see https://www.gnu.org/software/freefont/
    @see https://www.rockbox.org
    @see http://www.cl.cam.ac.uk/~mgk25/ucs-fonts.html
    @see http://en.wikipedia.org/wiki/Glyph_Bitmap_Distribution_Format
    @see https://partners.adobe.com/public/developer/en/font/5005.BDF_Spec.pdf
  * FatFS code is by ChaN:
    @see http://elm-chan.org/fsw/ff/00index_e.html
  * Yield Code extracted from ESP8266 Arduino Project
	@see https://github.com/esp8266/Arduino
___

@par Directories
  * Files
    * COPYRIGHT.md - Project Copyright file
    * Doxyfile - Doxygen configuration file
    * display.jpg - image of the ili9341 display while the software is running
    * doit - bash script that compiles and uploads firmware then starts miniterm
    * doxyfile.inc - automatically created file lists directories to search for documentation
    * header - common include header that can be used by user C files
    * get_esp-open-sdk - shell script to download / compile and install the current version of ESP OPEN SDK 
      * This project is now using versions 2.0.0 of the SDK
      * Tested on Ubuntu 16.04.1 and Ubuntu 14.04.5
      * Installs under /opt/Expressif/esp-open-sdk
    * get_esptool - downloads the latest version of esptool - required for this project
    * header - example C headers required for C programs in this project
    * Makefile from CHERTS modified for the project
      * Features are all controlled by variables in Makefile
      * Note the Makefile downloads the latest esptool automatically so it is no longer includd here
    * meminfo.sh - displays current RAM usage for the project
      * Example: ./meminfo.sh build/demo.elf
    * miniterm - shell script to launch terminal to 115200 baud
       Defaults to /dev/ttyUSB0 115200
    * README.md - Project readme file
      * Tested with ESP8266_NONOS_SDK_V2.0.0_16_08_10, 1 Nov 2016
    * send.c
      * Send message to network server 
      * Example: ./send -i 192.168.200.116 -m '\fscrolling\ntext\n1\n2\n3\n4'
        * These escape characters are processed on the display: \n, \t, \f
    * setpath - set the current environment for the SDK and tools
      * Example: . setpath
    * testflash.c
      * Create and read a test pattern filled file for flash testing
    * video.mp4
      * Video of ili9341 display with web server CGI updating the display

  * Eclipse Project files and Directories
    * Change .settings/language.settings.xml
    * .cproject
    * .project
    * .settings
       * .settings/language.settings.xml
         * Contains path to cross compiler for indexing - matches assumptions in SDK installer script: get_esp-open-sdk

  * Directories
    * adf4351 - Analog Devices ADF4351 Wideband Synthesizer with Integrated VCO driver
        * adf4351.c
        * adf4351.h
          * Main ADF4351 interface code
        * adf4351_cmd.c
        * adf4351_cmd.h
          * User interface and frequency scanning task
        * adf4351_hal.c
        * adf4351_hal.h
          * Hardware Abstraction layer

    * bridge  - Serial bridge code - send and receive serial data via network
        * bridge.c
        * bridge.h
          * Opens a port on port 23 so you can use telnet to test
            * Note: at the moment no telnet command processing is done.

     * cordic - CORDIC function - a very fast method to do 2D/3D trig conversions
         * cordic.c        
         * cordic.h        
           * My 3D transformation functions are based on CORDIC and gradians/100
           * 1 = 90degrees so the integer part reflects the quadrant
         * cordic2c_inc.h  
           * CORDIC lookup tables generated with my program cordic2c
           * 1 = 90degrees so the integer part reflects the quadrant
         * make_cordic
           * cordic2c.c
             * My customized CORDIC code, CORDIC table generating tools
             * Creates fixed point tables where 1 = 90degrees 
               * The integer part reflects the quadrant
             * Based on work by P. Knoppers, 13-Apr-1992.
           * Makefile
             * Make and test CORDIC tables
     
     * display - My mostly rewritten ili9341 display driver with multiple window support and scrolling
       * Depends on a few modified Adafruit functions under directory driver
         * font.c        
         * font.h        
           * My Fixed and proportional font display code 
         * fonts.h        
           * Font data structures created via the BDF converter - see fonts directory
         * ili9341.c           
         * ili9341.h           
           * multiple window support 
           * readPixel() works on most all 4 wire displays now
           * scrolling window support
           * Optimized line drawing function is from CHERTS
             * Non optimized version is also supplied that I wrote in 1984
         * ili9341_hal.c           
         * ili9341_hal.h           
             * Display hardware abstraction layer
     	 * tft_printf.c
     	 * tft_printf.h
    	   * Printf interface to display library tft_printf()

    * docs - ili9431 and esp8266 related documents
  
    * driver - third party code
        * cal_dex.c       
          * Debug exception support by cal (20150421, cal)
        * ili9341_adafruit.c  
        * ili9341_adafruit.h
          * Adafruit display - just those remaining functions that I have not rewritten
    
     * earth  - Earth coast line data and display code
       * Still need to add hidden vector removal
         * 00README.txt
           * Article on coordinate transforms from stackoverflow by Daphna Shezaf
         * earth2wireframe.c
           * Create C structure wire-frame coastline data
           * This code could be easily adapted for any kind of wire-frame
         * Makefile
           * earth_data.h from Coastline LAT/LONG pairs
         * data - Coastline data at various resolutions
           * world.dat      
           * world_10m.txt  
           * world_110m.txt 
           * world_50m.txt

     * esp8266 - ESP8266 specific code
         * bits’
         * couch
         * Debugging printf wrapper
           * debug’s
           * debug’s
         * Flash read, Bittest functions, For systems requiring specific memory alignment access methods
           * flash.c
           * flash.h
         * My rewritten HPSI code that avoids unaligned read and writes (based on code ideas from CHERTS and Sem)
           * hspi.c
           * hspi.h
         * Chip select, addressing code and spi abstraction layer for all devices
           * hal.c
           * hal.h
         * RTC DS1307 code in progress
           * rtc.c
           * rtc.h
         * POSIX malloc, calloc, free wrappers and reset functions
           * system.c
           * system.h
         * Serial I/O Interrupt driven receive and transmit code
           * uart.c
           * uart.h
           * uart_register.h
    
     * fatfs  - R0.12b FatFS code from (C)ChaN, 2016 
       * with minimal changes for ESP8266
         * 00history.txt
         * 00readme.txt
         * ff.c
         * ff.h
         * ffconf.h
         * integer.h
         * option
           * cc932.c
           * cc936.c
           * cc949.c
           * cc950.c
           * ccsbcs.c
           * syscall.c
           * unicode.c

     * fatfs.hal - My updated FatFS hardware abstraction layer code for ESP8266 
         * Device layer
           * diskio.c
           * diskio.h
         * MMC Code for SD cards
           * mmc.c
           * mmc.h
         * MMC Hardware abstraction layer
           * mmc_hal.c
           * mmc_hal.h

     * fatfs.sup - My POSIX wrappers for FatFS and user interface code
         * fatfs.h
           * Master include file for all FatFS headers
         * FatFS support functions
           * fatfs_sup.c
           * fatfs_sup.h
         * User tests and commands
           * fatfs_utils.c
           * fatfs_utils.h
         * My POSIX wrappers for fatfs
           * posix.c - provides a POSIX interface for FatFS - Linux file I/O wrappers 
           * posix.h

     * fonts - BDF Font conversion code
         * bdffont2c.c  
           * Convert BDF fonts to C structures main program
         * bdffontutil.c  
         * bdffontutil.h  
           * BDF fonts to C support code
         * bdfview.c  
           * ASCII previewer to test BDF display code 
         * font.h  
           * Font data structure definitions
         * fonts.h  
           * Converted fonts as C structures
         * Makefile
           * Make file to build selected fonts into a C structure
         * docs           
           * BDF font specs
         * fixed          
           * ucs-fonts.tar.gz
           * Unicode versions of the X11 "misc-fixed-*" fonts
           * Markus Kuhn, etc
         * fonts
           * Rockbox Font Collection - www.rockbox.org
           * Reorganized into three directories
             * C - constant size fonts
             * P - Proportional size fonts
             * O - Other
         * freefont
           * Freefont fonts  www.gnu.org/software/freefont
  
     * html - A working web site with files that can be put on an SD card
         * Used for testing web.c

     * include 
         * user_config.h
           * Master include and config header
         * spi_register.h 
           * From Expressif
         * uart_register.h
           * From Expressif

     * ld - Linker scripts

     * lib - time, RTC and timer functions
         * Matrix functions
           - used for N point least squares screen calibration functions
           * matrix.c
           * matrix.h
         * POSIX time functions
           * time.h
           * time.c 
         * Simple timers and tasks
           * timer.h
           * timer.c 
         * timer hardware abstraction layer
           * timer_hal.h
           * timer_hal.c - timer hardware abstraction layer
         * implementation of some POSIX ctype and string functions
           * string.c
           * string.h
         * Generic ring buffer support code
           * queue.c
           * queue.h
  
     * network - Simple network server 
       * displays message sent by send.c 
         * network.c
         * network.h
  
     * printf  My small printf with floating support, misc I/O functions
       * Build and test printf
         * Makefile
       * Number I/O function
         * mathio.c
         * mathio.h
       * printf function with user defined output function - for strings, files or devices
         * printf.c
       * Simple scanf
         * sscanf.c
       * Test functions for printf.c that can be run under Linux to verify results
         * test_printf.c

     * server - Receive network message and display on ili9341 display
       * server.c
       * server.h

     * user - Main user demo task
       * Initializes ESP8266 and sets up demo with 4 active windows with independent attributes
         * user_main.c
  
     * web - Web server with FAT file system SD CARD support 
       * Features
         * web.c
         * web.h
  	   * Served files can be ANY SIZE!
         * CGI files can have an extension of: html,htm,text,txt,cgi
  	     * CGI results can be ANY SIZE
  	   * Only tokens of the form @_ token _@ are replaced by the rewrite function
         * @see rewrite_cgi_token() in web.c
  	   * Uses yield function to continue background tasks while serving requests
       * Applications
         * I created a door sign status display that can be updated via a web page web page running on the esp8266
         * Copy the file html/msg.cgi to the root folder of a fat32 SD card and modify to suit your needs.
         * Use: open a web browser to the web server running on the esp8266
           * See the Video
           * For example: http://192.168.200.116/msg.cgi
           * You can update status and return time information on the TFT display by entering information on the page.

     * wire - Wireframe viewer code - uses CORDIC
       * Wireframe viewer
         * wire.c
         * wire.h
       * Cube data
         * cube_data.h    
       * Wireframe EARTH data
         * earth_data.h

     * xpt2046 - touch screen code 
         - Serial command: calibrate 1   
           - runs calibration demo then alows user to set 10 calibrated points
           - uses matrix.c code 
         - code is work in progress 
         * xpt2046.c 
         * xpt2046.h 
     * yield - Yield code from Arduino yield code
       * README.txt     
       * Context switch code
         * cont.S         
         * cont.h         
         * cont_util.c    
         * ets_sys.h
       * Main user_init and task replacement with yield support
         * user_task.c    
         * user_task.h

@par Connections

	* ESP8266           
	  * MISO/GPIO12 
	  * MOSI/GPIO13
	  * CLK/GPIO14
      * CHIP_EN ---1K--- VCC3.3V
      * CH_PD   ---1K--- VCC3.3V
      * REST    ---1K--- VCC3.3V   Ground REST to reset ESP8266 and ILI9341
      * GPIO  2 ---1K--- VCC3.3V
      * GPIO  0 ---1K--- VCC3.3V   Ground GPIO 0 to to enable flashing
      * GPIO 15 ---1K--- GND       Need pull down for boot
      * GPIO 14 ---1K--- GND       Keeps floating pins from generating false clocks on attached devices
      * GND ------------ GND
      * T_OUT ------ +            T_OUT is connected to varaible VR100K 
                     | 
        VCC--330K--VR100K-- GND   Variable VR100K is connected to 330K then VCC
                                  Max voltage to T_OUT pin is VCC * 100K / (330K+100K)

    * FTDI232 USB/TTL      ESP8266 
      * TXD ----1K--------  RXD
      * RXD --------------  TXD
      * RTS ---|<--------- REST    Optional - Diode with Cathode to RTS, Anode to ESP8266 Reset
      * DTR ---|<----1K--- GPIO 00 Optional - Diode with cathode to DTR, Anode to 1K to ESP8266 GPIO00 for flashing
      * GND --------------  GND
      * Note: if you use the optional DTR,RTS conneections you have to use miniterm script provided
        recommend using jumpers to anable this feature if you do not wish to have the ESP8266 reset automatically

    * xpt2046        ESP8266
      * MOSI   MOSI  GPIO 13
      * MISO   MISO  GPIO 12
      * SCK    CLK   GPIO 14 
      * CS           GPIO 02

    * ILI9341        ESP8266
      * Data/Command GPIO 05 (see io.c and SWAP45 in Makefile - my pin lables are backwards!)
      * CS           GPIO 15 (see io.c)
      * SDI    MOSI  GPIO 13
      * SDO    MISO  GPIO 12
      * SCK    CLK   GPIO 14 
      * RST    REST  RESET
      * VCC          VCC3.3V
      * GND          GND

    * MMC/SD reader  ESP8266
      * D3/CS        GPIO 04 (see io.c and SWAP45 in Makefile - my pin lables are backwards!)
      * CMD/DI MOSI  GPIO 13
      * D0     MISO  GPIO 12
      * CLK    CLK   GPIO 14
      * VCC          VCC3.3V
      * GND          GND

    * ADF4351        ESP8266
      * LE           GPIO 00 (see io.c)
      * DATA   MOSI  GPIO 13
      * CLK     CLK  GPIO 14
      * MUXOUT            NC
      * CE                NC
      * VCC          VCC3.3V
      * GND          GND

@par Demo Video
  * See web.c for details.
    * I created a door status display that can be updated via a web page web page 
    * I did a status update while recording the video
    * Result: https://github.com/magore/esp8266_ili9341/blob/master/video.mp4?raw=true

@par Demo Images
  * Running demo and sending a message to the network window
  * "./send -i 192.168.200.116 -m 'testing\nTest3\nscrolling\ntext\n1\n2'"
    * Diagnostics from send
     ip:192.168.200.116, port:31415, message:
     testing
     Test3
     scrolling
     text
     1
     2
     Host name: 192.168.200.116
     * Result: ![](https://github.com/magore/esp8266_ili9341/blob/master/display.jpg)
