pimatic-prowl
=======================

A plugin for sending [prowl](http://www.prowlapp.com/) notifications in pimatic.


Configuration
-------------
You can load the backend by editing your `config.json` to include:

    {
      "plugin": "prowl",
      "apikey": "xxxxxxxxxxxxxxxxxxxxxxxxxx",
    }

in the `plugins` section. For all configuration options see 
[prowl-config-schema](prowl-config-schema.coffee)

Currently you can send prowl notifications via action handler within rules.

Example:
--------

    if it is 08:00 prowl event:"Good morning!" description:"Good morning Dave!" priority:1

in general: if X then prowl title:

    "title of the push notification" description:"message for the notification" [priority:-1 - 1]

Find more about parameters here [prowl](http://www.prowlapp.com/api.php#add).