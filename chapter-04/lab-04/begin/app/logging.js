import winston from "winston";
import finalhandler from "finalhandler";
import expressWinston from "express-winston";

// Configure a logger
export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  defaultMeta: {
    service: "vervium-cloud-ai",
    pid: process.pid,
  },
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()],
});

// Custom Express access logging middleware
export const accessLogger = expressWinston.logger({winstonInstance: logger});

// Custom Express error handler that logs all errors
export const errorLogger = (err, req, res, next) => {
  // finalhandler is the exact library Express uses to handle errors. The only difference is that Express logs those
  // errors via console.error, whereas here, I use the winston logger.
  finalhandler(req, res, {
    onerror: (err) => {
      logger.error(err);
    },
  })(err);
};
