var request = require('request');
var cheerio = require('cheerio');

var gradeYearsUrl = 'http://zsb.neau.edu.cn/Information.aspx?Msg_Type=0DA68D35141C8331902099858D3E232C'
var majorInfoURL = 'http://zsb.neau.edu.cn/EnrolStudent.aspx';
module.exports = {
  getGradeYears: function (callback) {
    request(gradeYearsUrl, function (err, res, html) {
      if (err) {
        console.log('get years error');
        callback(err);
        return;
      }

      if (res.statusCode !== 200) {
        var errmsg = 'get years status code error';
        console.log(errmsg);
        callback(new Error(errmsg));
        return;
      }

      var result = [];
      var $ = cheerio.load(html);
      $('.list').children().find('a').each(function () {
        var ele = $(this);
        if (/20\d{2}年分省分专业录取分数一览表/.test(ele.text())) {

          var item = {
            year: ele.text().substring(0, 4),
            url: ele.attr('href')
          };
          
          result.push(item);
        }
      });

      callback(null, result);
    });
  },

  getBatch: function (url, callback) {
    request(url, function (err, res, html) {
      if (err) {
        console.log('get batch error');
        callback(err);
        return;
      }

      if (res.statusCode !== 200) {
        var errmsg = 'get batch status code error';
        console.log(errmsg);
        callback(new Error(errmsg));
        return;
      }

      var result = [];
      var $ = cheerio.load(html);
      $('td').each(function () {
        var ele = $(this);
        var item = {
          name: ele.text().trim(),
          url: ele.find('a').attr('href')
        }

        result.push(item);
      });

      callback(null, result);
    });
  },

  getDetail: function (url, callback) {
    request(url, function (err, res, html) {
      if (err) {
        console.log('get detail error');
        callback(err);
        return;
      }

      if (res.statusCode !== 200) {
        var errmsg = 'get detail status code error';
        console.log(errmsg);
        callback(new Error(errmsg));
        return;
      }

      var $ = cheerio.load(html);
      var table = $('table');
      callback(null, table.html());
    });
  },

  getMajorInfo: function (callback) {
     request(majorInfoURL, function (err, res, html) {
        if (err) {
        console.log('getMajorInfo error');
        callback(err);
        return;
      }

        if (res.statusCode !== 200) {
        var errmsg = 'getMajorInfo status code error';
        console.log(errmsg);
        callback(new Error(errmsg));
        return;
      }

      var $ = cheerio.load(html);
      var result = [];
      $('.td1').each(function () {
        $(this).find('a').each(function (i) {
          var name = $(this).text().trim();
          var url = $(this).attr('href');
          if (i === 0) {
            result.push({
              collegeName: name,
              collegeInfoUrl: url,
              majors: []
            });
            return;
          }
          
          result[result.length-1].majors.push({
            majorName: name,
            majorInfoUrl: url
          });
        });
      });

      callback(null, result);
    });
  },

  getMajorInfoDetail: function (url, callback) {
    request('http://zsb.neau.edu.cn/' + url, function (err, res, html) {
      if (err) {
        console.log('getMajorInfo error');
        callback(err);
        return;
      }

        if (res.statusCode !== 200) {
        var errmsg = 'getMajorInfo status code error';
        console.log(errmsg);
        callback(new Error(errmsg));
        return;
      }

      var $ = cheerio.load(html);

      callback(null, $('.yxContent').html());
    });
  }
}
