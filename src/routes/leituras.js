var express = require("express");
var router = express.Router();

var leituraController = require("../controllers/leituraController");

// GET /leituras/ultimas/:idSensor?limite=20
router.get("/ultimas/:idSensor", function (req, res) {
    leituraController.buscarUltimasLeituras(req, res);
});

module.exports = router;
