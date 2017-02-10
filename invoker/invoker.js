function main(args) {

  return new Promise(function(resolve, reject) {

    var openwhisk = require('openwhisk');
    var ow = openwhisk();

    var actions = args.items.map(function (item) {
      console.log(item.question_id + ": " + item.title);
      return ow.actions.invoke({actionName: "stackoverflow/qhandler", params: {question: item}});
    });

    return Promise.all(actions).then(function (results) {
	  return resolve({payload: "All OK: " + results.length + " qhandler activations"});
    });
  });
}
 
