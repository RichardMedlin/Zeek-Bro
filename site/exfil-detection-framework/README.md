Exfil Framework
=====
The Exfil Framework is a suite of Bro scripts that detect file uploads in TCP connections. The Exfil Framework can detect file uploads in 
most TCP sessions including sessions that have encrypted payloads (SCP,SFTP,HTTPS). 

Summary
---------
The Exfil framework detects file uploads by watching connections for 'bursts' in upstream traffic. A 'burst' is an event where the upstream byte rate of a connection surpasses a particular threshold (2000 bytes/sec by default). If the burst is sustained for more than a particular number of bytes (~65K by default), a Exfil::File_Transfer Notice will be issued.

### Upstream TCP byte rate in session with file transfer
```               
          |       * byte_count_threshold (*)
          |       *      
          |       *
          |    ___*______
byte rate |   /   *      |
          |xxxxxxx*xxxxxxxxxxxx byte_rate_threshold (x)
          |_/     *      |____
          |_______*____________
                  time
```
### Upstream TCP byte rate in session without file transfer
```
          |       * byte_count_threshold (*)
          |       *
          |       *
byte rate |       *  
          |xxxxxxx*xxxxxxxxxxxxx byte_rate_threshold (x)
          |_/\____*__/\________
          |_______*____________
                  time
```
### Implementation
The Exfil Framework contains four Bro scripts:

1. **main.bro** - The script that drives the Exfil Framework. You probably do not want to edit this file.
2. **app-exfil-conn.bro** - The script that attaches the Exfil Framework to connections. You will want to edit the redefs exported by this script to choose which connections get monitored for file uploads. **Note:** Start small. If this script is attached to a lot of connections, it may negatively impact the amount of traffic your Bro sensor can process.
3. **app-exfil-after-hours.bro** - A policy script that issues a Notice if a file upload is detected after the business hours of your organization. You will want to edit the redefs exported by this file to define the appropriate business hours of your organization.
4. **__load__.bro** - A wrapper that enables all Exfil Framework scripts with one line of configuration. You will not need to edit this file.

Quick Start
------------
These instructions will guide you through the installation of the Exfil Framework on your Bro sensor.

* Clone this repository to the "site" folder of your Bro instance
```
git clone https://github.com/reservoirlabs/bro-scripts.git
```
* Enable the Exfil framework by adding the following line to your local.bro:
```
@load bro-scripts/exfil-detection-framework
```
* Redefine networks monitored for exfil in your local.bro:
```
redef Exfil::watched_subnets_conn = [x.x.x.x/x, y.y.y.y/y]; 
```
* Redefine the business hours of your network in your local.bro (start_time and end_time must be specified on 24 hour clock):
```
redef Exfil::hours = [ $start_time=x, $end_time=y ];
```
