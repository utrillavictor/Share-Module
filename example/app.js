// This module will allow you to send and attach files
// using the UIActivityViewController. To test out
// the module just asign a file to the displayOptions
// method and enjoy!

// TODO: write your module tests here
var share = require('com.vcord.share');
Ti.API.info("module is => " + share);

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);

var file = 'data.log';
var attachmentFile;

attachmentFile = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory, file);
attachmentFile.write('hello');

label.addEventListener('click', function(){
	share.displayOptions({
		title: 'Hello buddy',
		message: 'Hey, this is some cool message!',
		files: [attachmentFile]
	});
});

win.open();
