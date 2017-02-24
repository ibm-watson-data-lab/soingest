function main(data) {
  return new Promise(function(resolve, reject) {
    var request = require('request');

    if(data.status == 'new') {
      var message = "New question: <" + data.question.link + "|" + data.question.title + "> (tagged: " + data.question.tags + ")";
      console.log(message);

      var options = {
          "text": message,
          "icon_emoji": ":stackoverflow:"
      };

      request({
        url: data.slackURL,
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(options)
      }, function (err, response, body) {
        if(err) {
          console.log(err);
          reject ({payload: "Failed"});
        } else {
          console.log("Status: " + response.statusCode);
          console.log("Response Body: " + body);
          resolve( {payload: "Notified"} );
        }
      });

    } else {
      resolve( {payload: "Complete"} );
    }
  });
}
