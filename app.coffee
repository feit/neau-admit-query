express = require 'express'
bodyParser = require 'body-parser'
admissionQuery = require './lib/admissionQuery'
fetchGrade = require './lib/fetch'
module.exports = app = express()

# view engin
app.set('view engine', 'html')
app.engine('html', require('ejs').renderFile)

app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()

app.get '/', (req, res) ->
  admissionQuery.getTip (err, tip) ->
    if err
      res.render 'query', {errcode: 2, errmsg: '请稍后再试', tip: ''}
    
    res.render 'query', {errcode: 0, tip: tip}

app.post '/query', (req, res) ->
  name = req.body.name
  number = req.body.number

  admissionQuery name, number, (err, result) ->

    if err or not result
      result =
        errcode: 1
        errmsg: '考生号或姓名错误'
        tip: ''
      res.render 'query', result
      return

    res.render 'result', result

globalYears = null
app.get '/years', (req, res) ->
  if globalYears
    return res.json filterYears(globalYears)

  fetchGrade.getGradeYears (err, years) ->
    if err
      res.json {errcode: 1, errmsg: err.message}
      return

    globalYears = years

    res.json filterYears(years)

app.get '/batches', (req, res) ->
  {year} = req.query

  url = getYearsUrl year

  fetchGrade.getBatch url, (err, batches) ->
    if err
      res.json {errcode: 1, errmsg: err.message}
      return

    res.json batches

app.get '/detail', (req, res) ->
  {url} = req.query

  fetchGrade.getDetail url, (err, table) ->
    if err
      res.json {errcode: 1, errmsg: err.message}
      return

    res.end "<table>#{table}</table>"

province = require './attachment/json/province.json'
province = JSON.stringify province
app.get '/province', (req, res) ->
  res.send province

app.get '/province/detail', (req, res) ->
  provincePY = req.query.province

  unless provincePY
    return res.json({errcode: 1})

  provinceDetail = require "./attachment/json/#{provincePY}.json"

  unless provinceDetail
    return res.json({errcode: 2})

  res.json(provinceDetail)

collegeInfos = null
app.get '/college/info/all', (req, res) ->
  if collegeInfos
    return res.json(collegeInfos)
  
  fetchGrade.getMajorInfo (err, info) ->
    collegeInfos = info
    res.json(collegeInfos)

app.get '/college/major/info', (req, res) ->
  url = req.query.url

  unless url
    return res.json {errcode: 1}

  fetchGrade.getMajorInfoDetail url, (err, detail) ->
    if err
      return res.json {errcode: 2}

    res.send detail

app.use express.static(require('path').join(__dirname, 'public'))

port = process.env.PORT or 80
app.listen port, ->
  console.log "server booted, listening #{port}"

filterYears = (years) ->
  years.map (item) -> item.year

getYearsUrl = (year) ->
  for currentYear, i in globalYears
    if currentYear.year is year
      return currentYear.url
