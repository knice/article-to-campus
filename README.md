# AC (in development)

AC connotes delivery of electricity, but in this case is short for article-to-campus.

## How it works

You provide a URL to a news article on [news.ucsc.edu][1], and AC

1. Fetches the HTML from the URL
2. Sanitizes the HTML (remove unnecessary tags and attributes, make links fully-qualified)
3. Pulls author and audience information out of the HTML
4. Modifies the HTML (removes images, sharing links, and author information)
5. Compiles a new template for the email and inserts the HTML
6. Inlines a new CSS stylesheet so the message works with email clients like Gmail
7. Uses the URL slug (filename on the website) to save the file in `./build/`

## Requirements

- Node and NPM installed
- Command line experience

## Setup

1. Clone this repo
2. `cd` into the project directory
3. Run `npm install`

## Use

Run the following command to fetch a page:

`node app.js [URL-to-fetch]`

Example:

`node app.js https://news.ucsc.edu/2019/07/frank-honduras-book.html`

Prepares and saves the HTML content in `./build/frank-honduras-book.html`

## Roadmap

- Modularize the individual parts of the script.
- Make this into a full app that can send email too.
- [x] Remove the requirement that the file be saved before inlining.

## References

- [Using Google Groups to send campus broadcasts](http://replay.uci.edu/clients/uccsc/SC03.html) (UCCSC, 2013).

[1]: https://news.ucsc.edu
