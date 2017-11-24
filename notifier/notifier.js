function main(data) {
  return new Promise(function(resolve, reject) {
    var request = require('request');

    // primitive feature toggles to transition between notification types
    var send_to_slack = true;
    var send_to_hubot = false;

    if(data.status == 'new') {
      if(send_to_slack) {
        var message = "New question: <" + data.question.link + "|" + data.question.title + "> (tagged: " + data.question.tags + ")";
        console.log(message);

        var options = {
          "text": message,
          "icon_emoji": ":postit:"
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

      }

      if(send_to_hubot) {
        var hubot_url = data.hubotURL + "/hubot/stackoverflow/incoming";
        var event = {
          type: "new-question",
          data: data,
          a: 22
        };

        request({
          url: hubot_url,
          method: "POST",
          headers: {"Content-Type": "application/json"},
          body: JSON.stringify(event)
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
      }
    } else {
      resolve( {payload: "Complete"} );
    }
  });
}
