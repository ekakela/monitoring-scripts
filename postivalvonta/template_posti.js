var webPage = require('webpage');
var page = webPage.create();

page.open('http://www.posti.fi/henkiloasiakkaat/seuranta/#/lahetys/ABC', function (status) {
  console.log('Stripped down page text:\n' + page.plainText);
  phantom.exit();
});
