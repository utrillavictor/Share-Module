Appcelerator Titanium :: Share
===========================================

An Appcelerator Titanium module that creates an UIActivityViewController to choose which
application will send an email with an attachment.

![](https://www.dropbox.com/s/4ve5fzebhmuzjjq/image.png?dl=0)

<h2>Setup</h2>

Include the module in your tiapp.xml:

<pre><code>
com.vcord.share

</code></pre>

<h2>Usage</h2>

Currently the options you have are limited to images or files, can be used like...

<pre><code>
var module = require('com.vcord.share');

var yourFileName = 'your_file.pdf'; // You could also use an image 
var yourAttachmentFile = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory, yourFileName);

module.displayOptions({
    title : 'Email title',
    message : 'Your email body',
    files : [yourAttachmentFile]
}];

</code></pre>

* You can attach as many files you want. Just use a ',' inside the files property. 

<h2>Install this module</h2>

Mac OS X
--------
Copy the distribution zip file into the `~/Library/Application Support/Titanium` folder

Linux
-----
Copy the distribution zip file into the `~/.titanium` folder

Windows
-------
Copy the distribution zip file into the `C:\ProgramData\Titanium` folder
