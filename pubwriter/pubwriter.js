var MessageHub = require('message-hub-rest');

function main(args) {
   
  if (!args.items) {
    throw(new Error('missing items array'));
  }

  return new Promise(function(resolve, reject) {

    // construct CF-style VCAP services JSON
    var vcap_services = {
      "messagehub": [{
        "credentials": {
          "kafka_rest_url": args.kafka_rest_url,
          "api_key": args.kafka_api_key
        }
      }]
    };
    var kafka = new MessageHub(vcap_services);

    // turn array of objects into array of strings
    var strings = args.items.map(function(i) {
      return JSON.stringify(i);
    });
   
    kafka.produce('test', strings)
    .then(function () {
      resolve({items: args.items});
    });
 });
}

exports.main = main;
