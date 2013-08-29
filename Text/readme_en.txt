LinX - a simple GUI for Intel® Linpack Benchmark.

The main point of Linpack is to solve systems of linear equations of the given size (Problem Size). It is designed as a benchark to test the performance of a system in GFlops - billions of floating point operation per second. But being highly optimized it is also the most stressful CPU testing program to date and is a great tool in determining stability/instability of a CPU, outperforming other CPU testing software at least time-wise. One and the same system of equations is solved repeatedly; if all results match each other - the CPU is stable, otherwise the instability is obvious, since the same equations system cannot produce different solutions.

A brief overview of LinX' functionality and interface:

«File -> Save Screenshot» menu item. Saves main window's screenshot into program folder in a PNG format.

«File -> Save Text Log» menu item. During or after testing saves a text log with testing results into program folder.

«File —> Exit» menu item. Exits the program. (Who'd had thought?)

«Settings» menu item. Opens a window with Linpack's and LinX's additional settings.

«Settings» window:
  Main Linpack Settings:
    -testing mode (32-bit/64-bit). By default is set to OS type;
    -Linpack rocess priority. Setting this value higher than «Normal» is not recommended;
    -number of threads Linpack creates. By default is set to the number of logical processors (including HyperThreading-cores);
    -data alignment. 4 KiB by default, equal to the page size in Windows OS;
    -optimal Leading Dimensions. The Leading Dimensions value will be set to the nearest odd multiple of 8 higher than or equal to the Problem Size value (supposed to produce better performance)
    
  Advanced settings. These are to be changed only if you have problems getting Linpack to work.
    -maximum Problem Size for 32-bit Linpack. Lower if on higher Problem Size/memory values Linpack reports not enough memory
    -amound of RAM that will be left for OS when using the All memory option. Can be increased to increase OS «responsiveness».

  LinX settings:
    -auto-stop testing when an error is detected
    -auto-save log file during testing (as in Linpack, lowers performance a bit)
    -enable sounds upon success/fail
    -tray icon and the ability to minimize LinX to tray area to save some taskbar space
    -add current date/time or date/time of testing start to screenshot and log files respectively
    -disable context hints

  External Applications Import:
    -monitoring data source (None, Everest, Speedfan):

Allows LinX to receive some data like core temperatures, CPU voltage, frequency, CPU fan RPM and +12 V voltage from either Everest or Speedfan. The temperature of the hottest core as well as CPU voltage and frequency (when importing data from Everest) are displayed in status bar during testing, other values are used to create graphs. To import data from Everest go in Everest to «File -> Preferences... -> External Applicatons» and check the «Enable shared memory checkbox». For Speedfan you need to first fill in the values in the "Speedfan.ini" file in LinX directory. These values are numbers of temperatures/voltages/fan speeds as they are displayed in Speedfan, from top to bottom starting with 1. For example, if core0 temperature in Speedfan is listed 5th from top set in the INI file CPU_core0_num=5 and so on.
Note that Everest or Speedfan should be running with LinX for all this to work.

    -stop the testing once the desired temperature is reached. If LinX is getting data from Everest or Speedfan testing will stop when the temperature reaches this threshold to prevent CPU from overheating.

«Graphs -> Create» menu item. Allows you to choose which graphs to create during testing: you can choose from CPU temperature, CPU fan speed, CPU vcore and +12V voltage values. To display the graphs use the «Graphs -> Display» menu item. Graph windows can be resized in real-time, graphs can be saved by double-clicking on them in the corresponding window.

« ? » menu item. Opens a window with some info about the program and a very short version of this file.

«Problem Size» & «Memory to use» fields. The first one is the amount of equations to solve, the second - the corresponding amount of memory that will be allocated by Linpack for this Problem size. You can either set the Problem size and the amount of memory to be used will be calculated automatically or vice versa. There is also an «All [memory]» button available to use all free physical memory. The effectiveness of finding errors as well as the amount of stress to the processor increase with increased memory usage/Problem size.
1 MiB = 1024 KiB = 1024^2 bytes

«Times to run». This is how many times the test will be run. Once again, the more the better. To consider a CPU fully stable you should set this to at least 50-100, for quick testing lower values are acceptable.

«Start» & «Stop» buttons. Used to start and stop the testing process respectively.

Status field/progressbar. Displays the amount of available memory before testing, the elapsed/remaining/finish time during testing (these can be switched by clicking on the field or even turned completely off by double-clicking if you need another 100th of GFlops) and the result (success or fail) with the time spent on testing after testing.

Bottom status bar. Displays some useful information like the current test # and the total number of tests, maximum performance in GFlops so far, testing mode (32-bit or 64-bit), current number of threads, and with Everest or Speedfan data - CPU temp, voltage and frequency. There's also table(default LinX view)/log(Linpack) toggle button available after the testing has finished.

Double-clicking the main window will make it stay on top.
List of available command-line keys: LinX.exe /?

If you made it this far you're very patient. I hope you enjoyed reading this ReadMe as much as I did writing it. Thanks for reading!