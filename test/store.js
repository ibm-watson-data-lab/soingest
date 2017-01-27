require('dotenv').config();
var main = require('../store.js');
var assert = require('assert');

describe('store error handling', function() {

  it('should be a function', function(done) {
    assert(typeof main, 'function');
    done();
  });

  it('should detect missing CloudantURL', function(done) {
    var obj = {
      dbname: process.env.DBNAME,
      question: {
        question_id: 1,
        other: 'hello'
      }
    };
    var r = main(obj);
    assert(typeof r.err, 'string');
    done();
  });

  it('should detect missing dbname', function(done) {
    var obj = {
      cloudantURL: process.env.CLOUDANTURL,
      question: {
        question_id: 1,
        other: 'hello'
      }
    };
    var r = main(obj);
    assert(typeof r.err, 'string');
    done();
  });

  it('should detect missing question', function(done) {
    var obj = {
      cloudantURL: process.env.CLOUDANTURL,
      dbname: process.env.DBNAME
    };
    var r =  main(obj);
    assert(typeof r.err, 'string');
    done();
  });

  it('should detect invalid question_id' , function(done) {
    var obj = {
      cloudantURL: process.env.CLOUDANTURL,
      dbname: process.env.DBNAME,
      question: {
        question_id: "oops",
        other: 'hello'
      }
    };
    var r = main(obj);
    assert(typeof r.err, 'string');
    done();
  });

});

describe('store action', function() {
  var cloudant = null;
  var db = null;

  before(function(done) {
    cloudant = require('cloudant')(process.env.CLOUDANTURL);
    db = cloudant.db.use(process.env.DBNAME);
    cloudant.db.create(process.env.DBNAME, done);
  });

  it('should write to Cloudant' , function(done) {
    var obj = {
      cloudantURL: process.env.CLOUDANTURL,
      dbname: process.env.DBNAME,
      question: {
        question_id: 1,
        other: 'hello'
      }
    };
    var p = main(obj).then(function(data) {
      assert.equal(data._id, obj.question.question_id.toString());
      db.get(data._id, function(err, data) {
        assert.equal(err, null);
        assert.equal(data.status, 'new');
        assert.equal(data.owner, null);
        assert.deepEqual(data.question, obj.question);
        done();
      });
    });
    assert(p instanceof Promise);
  });

  it('should update Cloudant' , function(done) {
    var obj = {
      cloudantURL: process.env.CLOUDANTURL,
      dbname: process.env.DBNAME,
      question: {
        question_id: 1,
        other: 'hello again'
      }
    };
    var p = main(obj).then(function(data) {
      assert.equal(data._id, obj.question.question_id.toString());
      db.get(data._id, function(err, data) {
        assert.equal(err, null);
        assert.equal(data.status, 'new');
        assert.equal(data.owner, null);
        assert.deepEqual(data.question, obj.question);
        done();
      });
    });
    assert(p instanceof Promise);
  });

  after(function(done) {
    cloudant.db.destroy(process.env.DBNAME, done);
  });

});
