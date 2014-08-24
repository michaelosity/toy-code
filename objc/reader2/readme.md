# Instructions

The coding challenge is to build a simple Instagram popular photo browser.  The requirements are:

* Build a simple table view using the Instagram popular API. 
* Each table cell should contain the popular image as well as the user's name and image.
* Please don’t use any third party libraries.  And please do not use interface builder.
* Please use Auto Layout to lay out your views.

Here are some ideas of things you can add to this coding sample to really show us what you can do:

* Caching data using core data and files
* Well thought out class interaction between views, data sources, network, etc.
* Attractive / advanced UI implementation
* Very performant - (60fps scrolling, fast image loading, etc.)
* Additional functionality (refresh, image detail view, photo map, sharing, etc)
* Unit tests

## Implementation Notes

* I'm using a fixed row height for the table view. I think that is appropriate for this exercise, but it would be reasonable to implement the methods on UITableViewDelegate for estimating the row height and adjusting to the photo height.
* It might be a good idea to cache (or use Etags at least) for the feed or the images. I've found, however, that the feed changes so frequently that the Etags on the feed itself is almost always useless so I've left that out. Since we cache the images we get back the Etag is mostly useless too. I'm making an assumption here that once posted the images do not really change.
* I'm reusing some code I've written is MLYRestClient/MLYRestResponse that is a bit overkill for this app. I've found this code useful for connections to a RESTful web service with a common base url (http://address.com/api/v2/) and certain specific paths (users/<guid>/) and verbs (get vs. put vs. delete). I've also used the progress handlers to update UI progress bars soI thought I'd include it here.

# MIT LICENSE

The MIT License (MIT)

Copyright (c) 2014 Michael Wells

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

