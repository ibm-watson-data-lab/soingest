var request = require('request');

// Parameters
//   apikey - StackOverflow API key
//   tags - list of tags e.g. "cloudant;redis"
//   search_type - either "and" or "or" (default = "or")
function main(message) {
  return new Promise(function(resolve, reject) {
    
     // create API request
     var now = new Date();
     var tagged = '';
     if(Array.isArray(message.tags)) {
       tagged = message.tags.join(';');
     } else {
       tagged = message.tags;
     }

     // keep the original default search type of OR
     var url = 'https://api.stackexchange.com/2.2/search';
     if(message.search_type && message.search_type.toLowerCase() == "and") {
         url = 'https://api.stackexchange.com/2.2/questions';
         console.log("Search type is AND");
     }

     var r = {
       method: 'get',
       url: url,
       qs: {
         key: message.apikey,
         site: 'stackoverflow',
         fromdate: Math.floor((now.getTime()/1000)-(1*24*60*60)),
         order: 'asc',
         sort: 'activity',
         tagged: tagged,
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

       if (response.statusCode != 200) {
         console.log(body);
         throw(new Error('status code not OK (got a ' + response.statusCode + ')'));
       }
       if (!body.items) {
         throw(new Error('missing items in response'));
       }
       console.log(body.items.length + " questions fetched");
       resolve({ items: body.items });
     }); 
  });
}

module.exports = main;
