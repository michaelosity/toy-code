# Instructions

Write an iOS app that displays the international space station location on a map using the [REST API](http://open-notify.org/Open-Notify-API/ISS-Location-Now/).

## Implementation Notes

When rushing through the implementation I noticed a few things I would probably do differently.

1. I'd use a serial queue instead of a concurrent dispatch queue. Instead of using dispatch_get_global_queue() I'd create a serial queue so that each request is dispatched in order.
2. I might also keep track of the timestamp from the retrieved location and ensure that we never update the UI with an earlier time (which could happen as written).

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
