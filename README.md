# RegionInsider

iOS application that detects if the device is located inside of a geofence area.

Geofence area is defined as a combination of some geographic point, radius, and specific Wifi network name.
A device is considered to be inside of the geofence area if the device is connected to the specified WiFi network or remains geographically inside the defined circle.

Note: if device coordinates are reported outside of the zone, but the device still connected to the specific Wifi network, then the device is treated as being inside the geofence area.

>
**NOTICE!**
There is no Wi-Fi SSID check in code! Obtaibing it can only be accomplished with _Wi-Fi Info Access_ entitlement and _Wireless Accessory Configuration_ capability enabled for both project and AppID which assumes apple developer program enrollment which is not my case unfornutaly =(
You can take a look anyway
