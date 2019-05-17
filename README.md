# AkkarApp
The name of the application is "Akkar"; Akkar is a district exists in North of Lebanon
The app will use flicker API to download images for some villages in Akkar district located in North of Lebanon. 

# Implementation
The main view controller will give some historical data about Akkar.
In the next collection view controller, all villages will be downloaded from flicker and each village will be shown with its name.
The user can press the refersh button in order to get update if any.
Once the user clicks on any image then all images related to this village will be shown. 
The user can press on location button then will be directed to apple maps with the village location

# How to Build
In order to download the images from flicker for specific areas in Akkar, I have created Album for each village in my flicker account.
Once the user click on "Click Here to discover Akkar", the application will send a request to flicker using "flickr.photosets.getList" which will download all albums from my account; from this method I will get the name of the villages.
"flickr.photosets.getPhotos" will be used to downlad one image and put it as background for each album in my application.
Image Data and album title will be saved in Database in order to have the application persistent.
Once the user will click on any image, then "flickr.photosets.getPhotos" again will be used to dowload the remaining images for each village; also here the the images data for each village will be saved in database.
"flickr.photos.geo.getLocation" this method will be used to get the location for each village; also the data here is persisted.

# License
MIT License

Copyright (c) [2018] [Mahmoud Zakaria]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
# Requirements
XCode 9.2 Swift 4.0
