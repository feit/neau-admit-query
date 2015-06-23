request = require 'request'
cheerio = require 'cheerio'

module.exports = (name, number, callback) ->
  form =
    '__VIEWSTATE': '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'
    '__EVENTVALIDATION': '/wEWIQKE/d7gAgKUgI3/AwKE76eRDwKf56rsDgKho4SDDALuqurjAwLk4LvKAgLy87SKAwLSnszhBQLzuKqvBQK9++KkAQLKoe3vDALO3q7wAgKbot3YCgLPmeeWAgLc68G1BAKg1KfcAwLq1sOCCwLYzpmxBQLPnf/SCQLf8tW8BQLhkaytCQLBte3bBgLo4vK9BwLq+PTEBgKZtKL4DALpoPGdBALrwaHFBgLqwaHFBgKt+fa3BQK3z5qmDwKJnfm2CgKo9rXsBVVqRZYYbPQfUU7EpELKYY9B6Y6j'

    'ctl00$ContentPlaceHolder1$ddlType': '1'
    'ctl00$ContentPlaceHolder1$textfieldnumber': number
    'ctl00$ContentPlaceHolder1$textfieldname': name
    'ctl00$ContentPlaceHolder1$BtnQueren.x': '22'
    'ctl00$ContentPlaceHolder1$BtnQueren.y': '13'

  opts =
    url: 'http://zsb.neau.edu.cn/Query.aspx'
    method: 'POST'
    form: form

  request opts, (err ,res, data) ->
    return callback err if err

    if res?.statusCode isnt 302
      return callback new Error 'step 1 statusCode error'

    resultUrl = res.headers.location

    request resultUrl, (err, res, data) ->
      return callback err if err

      if res?.statusCode isnt 200
        return callback new Error 'step 2 statusCode error'

      $ = cheerio.load data

      resultStr = $('#jiguotongzhi').text().trim()
      result =
        province: /来自(.{1,9})的/.exec(resultStr)[1]
        name: /的(.{1,6})同学/.exec(resultStr)[1]
        number: /准考证号：(.{1,20})）/.exec(resultStr)[1]
        major: /我校(.{1,20})专业/.exec(resultStr)[1]

      callback null, result

module.exports.getTip = (callback) ->
  request 'http://zsb.neau.edu.cn/Query.aspx', (err, res, data) ->
    return callback err if err

    if res?.statusCode isnt 200
      return callback new Error 'statusCode error'

    $ = cheerio.load data
    tip = $('.zhujie').text()

    callback null, tip
