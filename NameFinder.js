var selfieText;
var casper = require('casper').create();

function getoutputText() {
    var outputText = document.querySelector('#ires');
    return outputText.textContent;
}

var name = casper.cli.get(0);

if (!name) {
    casper.echo('please provide a word').exit(1);
}

casper.start('www.google.com/?hl=en', function() {
    // search for entered name in google form
    this.fill('form[action="/search"]', { q: name }, true);
});

casper.then(function() {
    // aggregate results for the 'phantomjs' search
    selfieText = this.evaluate(getoutputText);
});

casper.run(function() {
    var myfile = "newfile.txt"
    var fs = require('fs');
    fs.write(myfile, selfieText, 'w');
    this.exit();
});
