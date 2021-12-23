"use strict";

/** Required packages */
var request = require("request");
var cheerio = require("cheerio");
var juice = require("juice");
var hbs = require("handlebars");
var sanitizeHtml = require("sanitize-html");

/** Node libraries */
var fs = require("fs");
const { exitCode } = require("process");

/** Variables */
var savePath = "./build/";
var location = process.argv[2];
var address = new URL(location);
var pagePath = address.pathname;
var issue = pagePath.split("/");
var filename = issue[issue.length - 1];
var site = "https://" + address.host;

/** Options for the CSS inliner */
const juiceOptions = {
  extraCss: "",
  applyStyleTags: true,
  removeStyleTags: true,
  preserveMediaQueries: true,
  preserveFontFaces: true,
  preserveKeyFrames: true,
  insertPreservedExtraCss: true,
  applyWidthAttributes: true,
  applyHeightAttributes: true,
  applyAttributesTableElements: true,
  inlinePseudoElements: true,
  xmlMode: true,
  preserveImportant: true,
};

if (address.host !== "news.ucsc.edu") {
  console.error(`Stopping... AC cannot fetch content from ${address.host}`);
  process.exit(1);
}

/** Mention that you've started the script */
console.log("Fetching: " + location);

request(location, function (error, response, body) {
  // Report errors
  if (error) throw error;

  var sanitized = sanitizeHtml(body, {
    allowedAttributes: {
      "*": ["href", "class", "alt", "src", "title"],
    },
    transformTags: {
      h3: "h2",
    },
  });

  // Load the response into the parser
  var $ = cheerio.load(sanitized);

  // Iterate over <link> tags to look for relative 'href' paths
  $("link").map(function (i, el) {
    // Get the 'src' attr for the image
    var linksrc = $(this).attr("href");
    // Crudely see if the path is relative or absolute
    if (linksrc.indexOf("http") == -1) {
      // Prepend the site path to the 'src' attr
      $(this).attr("href", site + linksrc);
    }
  });

  // Iterate over <img> tags to look for relative 'src' paths
  $("img").map(function (i, el) {
    // Get the 'src' attr for the image
    var imgsrc = $(this).attr("src");
    // Crudely see if the path is relative or absolute
    if (imgsrc.indexOf("http") == -1) {
      // Prepend the site path to the 'src' attr
      $(this).attr("src", pagePath + "/" + imgsrc);
    }
  });

  // Iterate over <a> tags to look for relative 'href' paths
  $("a").map(function (i, el) {
    // Get the 'href' attr for the image
    var asrc = $(this).attr("href");
    // Crudely see if the path is relative or absolute
    if (asrc.indexOf("http") == -1) {
      // Prepend the site path to the 'src' attr
      $(this).attr("href", site + asrc);
    }
  });

  var sentTo = $(".message-to").text();
  var sentFrom = $(".message-from").text();

  function friendlyTo(to) {
    return to ? "<p>Dear " + to + ",</p>" : "<p>Dear Campus Community,</p>";
  }

  function friendlyFrom(from) {
    from = from.split(";").join("<br>");
    return from ? "<p>Sincerely,<br>" + from + "</p>" : null;
  }

  $("figure").remove();
  $(".article-body *").removeAttr("style");
  $(".article-body").prepend(friendlyTo(sentTo));
  $(".article-body").append(friendlyFrom(sentFrom));

  var html = $(".article-body").html();

  // Use Handlebars to convert the list of sample pages
  // to an index file for the local test server
  fs.readFile("templates/email.hbs", async function (err, templateFile) {
    hbs.registerHelper("fetched", function () {
      var date = new Date().toLocaleDateString("en-us", {
        year: "numeric",
        month: "long",
        day: "numeric",
      });
      return date;
    });

    var template = hbs.compile(templateFile.toString());
    var htmlCompiled = template({ body: html, title: "Campus Message" });

    fs.readFile("templates/message.css", function (err, templateStyles) {
      var inlinedHtml = juice.inlineContent(
        htmlCompiled,
        templateStyles.toString(),
        juiceOptions
      );

      if (!fs.existsSync(savePath)) {
        fs.mkdirSync(savePath);
      }

      var fileOutput = savePath + filename;

      // Write the local file
      fs.writeFile(fileOutput, inlinedHtml, function (err) {
        if (err) throw err;
        console.log(location + " saved as => " + filename);
      });
    });
  });
});
