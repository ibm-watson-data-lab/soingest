/*

INPUT:
  {
    cloudantURL: 'http://admin:admin:localhost:5984',
    dbname: 'mydatabase',
    question: {
      question_id: 245,
      blah: true
    }
  }

OUTPUT:

  {
    _id: "245"
    owner: null, // lorna 
    status: "assigned", // "new", "assigned", "dismissed", "done"
    question: {
      question_id: 245,
      blah: true
    }
  }
*/

function main(message) {
  // check for required parameters
  var requiredParams = ['dbname', 'cloudantURL', 'question'];
  var errs = [];
  requiredParams.forEach(function(p) {
    if (!message[p]) {
      errs.push(p + ' is a required parameter of this OpenWhisk action');
    }
  });
  if (errs.length > 0) {
    return { err: errs };
  }

  // the question must have a numeric question_id
  if (typeof message.question.question_id !== 'number') {
    return { err: 'question.question_id must be a number'};
  }

  // setup Cloudant
  var cloudant = require('cloudant')({url: message.cloudantURL, plugin:'promises'});
  var db = cloudant.db.use(message.dbname);
  var id = message.question.question_id.toString();
 
  // see if there is pre-existing Cloudant document
  return db.get(id).then(function(data) {
    // if so, update the question
    data.question = message.question;
    data.status = 'updated';

    // and write it back
    return db.insert(data).then(function(reply) {
      console.log("Question " + id + " successfully updated");
      return data;
    });
  }).catch(function(err) {

    // otherwise, create new question object
    var obj = {
      _id: id,
      owner: null,
      status: 'new',
      question: message.question
    };
   
    // write it to the database
    return db.insert(obj).then(function(data) {

      // pass on the new object to the next action
      console.log("Question " + id + " created");
      return obj;
    });
  });
}
