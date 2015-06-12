express = require 'express'
bodyParser = require 'body-parser'
admissionQuery = require './lib/admissionQuery'

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

app.use express.static(require('path').join(__dirname, 'public'))

port = process.env.PORT or 3000
app.listen port, ->
  console.log "server booted, listening #{port}"
