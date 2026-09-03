import express from "express";

const app = express();
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.render("hello", {metrics: {synergy: "95.4%", powerpoint: "3 min", maturity: "Bronze+"}});
});

export default app;