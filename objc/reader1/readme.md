# Instructions

Write a program for iOS 7 to read from an RSS feed and show it as a tableview. Update the table as required (i.e. when new entries are added to the feed). Use the title, description and date fields to create each item and sort them based on the date. The most recent item should be at the top of the table.

* URL: http://feeds.feedburner.com/TechCrunch/social
* Update Interval: 10 minutes

# Notes

* The UI should never block while fetching the data (proper threading).
* The user should be able to close the App before the feed is completely loaded for the first time and put it in the background. The App should continue to fetch the data in the background so that if the user reopens the App, the tableview is updated without having to re-fetch the data (iOS 7 background fetch).

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
