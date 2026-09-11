import app from "./app.js";
import cluster from "node:cluster";
import os from "node:os";
import {logger} from "./logging.js";

const port = process.env.PORT || 8080;

// Use the Node.js cluster API to fire up one Node.js process per CPU core
if (cluster.isPrimary) {
  const numWorkers = os.availableParallelism();
  logger.info(`Starting ${numWorkers} workers`);
  for (let i = 0; i < numWorkers; i++) {
    cluster.fork();
  }
  cluster.on('exit', (worker, code, signal) => {
    logger.info(`Worker ${worker.process.pid} exited with code '${code}' and signal '${signal}'`);
    if (!worker.exitedAfterDisconnect) {
      logger.warn('Restarting worker ${worker.process.pid}, as it looks like its exit was unintentional');
      cluster.fork();
    }
  });
} else {
  app.listen(port, () => {
    logger.info(`Worker ${process.pid} listening on port ${port}`);
  });
}