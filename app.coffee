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
  res.render 'query'

app.post '/query', (req, res) ->
  name = req.body.name
  number = req.body.number

  admissionQuery name, number, (err, result) ->

    if err or not result
      res.render 'query'
      return

    res.render 'result', result

app.use express.static(require('path').join(__dirname, 'public'))

app.listen 80
