A little tool to fetch web pages and prepare them to send via email.

## Requirements

- Node.js installed.
- Some command line experience.

## Setup

1. Clone this repo.
2. `cd` into the project directory.
3. Run `npm install`.

## Use

Run the following command to fetch a page:

`node app.js` [URL-to-fetch] [name-of-saved-file]

Example:
`node app.js http://news.ucsc.edu/tuesday-newsday/2014/december-16/index.html 2014-12-16`

## What it does

1. The page is fetched.
2. All URLs in the HTML (images, stylesheets, etc) are made absolute.
3. The file is saved with the name you provided.
4. The CSS in the file is inlined and saved again.

It's not **nearly** as elegant as I would like it to be. But it does the job for now.

## Roadmap

- DRY up the part of the script that makes URLs absolute.
- Remove the requirement that the file be saved before inlining.
- Make this into a full app that can send email too.
