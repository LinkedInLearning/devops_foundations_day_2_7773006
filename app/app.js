import express from "express";
import {accessLogger, errorLogger} from "./logging.js";

const app = express();
app.set("view engine", "ejs");

// Add access logging. Must go before all the app routes.
app.use(accessLogger);

app.get("/", (req, res) => {
  res.render("hello", {metrics: {synergy: "95.6%", powerpoint: "3 min", maturity: "Gold+"}});
});

app.get("/error", (req, res) => {
  throw new Error("This is an intentional error to check error handling");
});

// Add error logging. Must go after all the app routes.
app.use(errorLogger);

export default app;