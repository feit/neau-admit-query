var fs = require('fs');
var path = require('path');
var XLSX = require('xlsx');
var pinyin = require("node-pinyin");

var attachmentPath = path.join(__dirname, '..', 'attachment');
var xlsFilesPath = path.join(attachmentPath, 'xls');
var jsonFilesPath = path.join(attachmentPath, 'json');

var xlsFiles = fs.readdirSync(xlsFilesPath);

var xlsTojson = function (xlsFiles) {
  xlsFiles.forEach(function (file) {
    var fileName = file.substring(0, file.indexOf('.'));
    var fileNamePYArr = pinyin(fileName, {style: 'normal'});
    var fileNamePY = parsePinYinArr(fileNamePYArr);
    var filePath = path.join(xlsFilesPath, file);
    var workbook = XLSX.readFile(filePath);
    var firstSheetName = workbook.SheetNames[0];
    var worksheet = workbook.Sheets[firstSheetName];
    var plan = XLSX.utils.sheet_to_json(worksheet);
    var jsonFileName = fileNamePY + '.json';
    var jsonFileAbsName = path.join(jsonFilesPath, jsonFileName);
    fs.writeFileSync(jsonFileAbsName, JSON.stringify(plan));
  });
}

var fileNamesToJson = function (xlsFiles) {
  var provinceNames = [];
  xlsFiles.forEach(function (file) {
    var fileName = file.substring(0, file.indexOf('.'));
    var fileNamePYArr = pinyin(fileName, {style: 'normal'});
    var fileNamePY = parsePinYinArr(fileNamePYArr);
    provinceNames.push({'chinese': fileName, 'pinyin': fileNamePY});
  });

  var jsonFileAbsName = path.join(jsonFilesPath, 'province.json');
  fs.writeFileSync(jsonFileAbsName, JSON.stringify(provinceNames));
}

function parsePinYinArr (pyarr) {
  var result = '';
  pyarr.forEach(function (item) {
    result += item[0];
  });
  return result;
}

fileNamesToJson(xlsFiles);
