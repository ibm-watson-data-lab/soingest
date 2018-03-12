function main(data) {

  if(data._id) {
    console.log("An issue was assigned to " + data.assigned_to_name);
    return new Promise(function (resolve, reject) {
      var request = require('request');
      var bot_url = data.botURL + "/stackoverflow/event";
      var event = {
        type: data.type,
        data: {
            assigned_to: data.assigned_to,
            assigned_to_name: data.assigned_to_name,
            assigned_by: data.assigned_by,
            assigned_by_name: data.assigned_by_name,
            question_id: data.question_id,
            title: data.title
        }
      };

      request({
        url: bot_url,
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

    });
  } else {
    console.log("No document received");
  }
}
