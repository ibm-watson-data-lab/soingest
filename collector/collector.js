var request = require('request');

// Parameters
//   apikey - StackOverflow API key
//   tags - list of tags e.g. "cloudant;redis"
function main(message) {
  return new Promise(function(resolve, reject) {
    
     // create API request
     var now = new Date();
     var r = {
       method: 'get',
       url: 'https://api.stackexchange.com/2.2/search',
       qs: {
         key: message.apikey,
         site: 'stackoverflow',
         fromdate: Math.floor((now.getTime()/1000)-(1*24*60*60)),
         order: 'asc',
         sort: 'activity',
         tagged: message.tags,
         filter: 'default'
       },
       json: true,
       gzip: true
     };

     // do the API request
     request(r, function(err, response, body) {
       if (err) {
         return reject(err);
       }
       console.log("tags: " + JSON.stringify(message.tags));
       console.log("status: " + response.statusCode);
       console.log(body.items.length + " questions fetched");

       if (response.statusCode != 200) {
         throw(new Error('status code not OK (got a ' + response.statusCode + ')'));
       }
       if (!body.items) {
         throw(new Error('missing items in response'));
       }
       resolve({ items: body.items });
     }); 
  });
}

module.exports = main;
