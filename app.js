const express = require("express");
const app = express();
const cors = require("cors");
const createRequest = require("./adapter.js").createRequest; 
const bodyparser = require("body-parser");

app.use(cors());
app.use(bodyparser.json());

app.post("/", (req, res) => {
  createRequest(req.body, (status, result) => {
    res.status(status).json(result);
  });
});

module.exports = app;
