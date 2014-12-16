"use strict";

var request     = require('request');
var cheerio     = require('cheerio');
var juice       = require('juice');
var url         = require('url');
var fs          = require('fs');

var savePath     = "./issues/";
var location    = process.argv[2];
var issue       = process.argv[3];

var address     = url.parse(location);
var path        = address.pathname.split('/');
var filename    = issue;
var site        = "http://" + address.host;

// Let us know you've started
console.log('Fetching: ' + location);

request(location, function(error, response, body) {
  
    // Report errors
    if (error) throw error;

    // Load the response into the parser
    var $ = cheerio.load(body);
    
    // Iterate over <link> tags to look for relative 'href' paths 
    $('link').map(function(i, el) {
      // Get the 'src' attr for the image
      var linksrc = $(this).attr('href');
      // Crudely see if the path is relative or absolute
      if (linksrc.indexOf('http') == -1) {
        // Prepend the site path to the 'src' attr
        $(this).attr('href', site + linksrc);
      };
    });    
    
    // Iterate over <img> tags to look for relative 'src' paths 
    $('img').map(function(i, el) {
      // Get the 'src' attr for the image
      var imgsrc = $(this).attr('src');
      // Crudely see if the path is relative or absolute
      if (imgsrc.indexOf('http') == -1) {
        // Prepend the site path to the 'src' attr
        $(this).attr('src', site + imgsrc);
      };
    });

    // Iterate over <a> tags to look for relative 'href' paths 
    $('a').map(function(i, el) {
      // Get the 'href' attr for the image
      var asrc = $(this).attr('href');
      // Crudely see if the path is relative or absolute
      if (asrc.indexOf('http') == -1) {
        // Prepend the site path to the 'src' attr
        $(this).attr('href', site + asrc);
      };
    });

    var html = $.html();
    var fileOutput = savePath + filename + ".html";

    // Write the local file
    fs.writeFile(fileOutput, html, function (err) {
      if (err) throw err;
      console.log(location + ' saved as => ' + filename + '.html');
    });

    // Juice the file and write it out
    juice(fileOutput, function(err, outp) {

      fs.writeFile(fileOutput, outp, function (err) {
        if (err) throw err;
        console.log(location + ' inlined and saved into => issues/' + filename + '.html');
      });      

    });

});
