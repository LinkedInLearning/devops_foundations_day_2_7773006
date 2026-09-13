import app from "./app.js";
import cluster from "node:cluster";
import os from "node:os";

const port = process.env.PORT || 8080;

// Use the Node.js cluster API to fire up one Node.js process per CPU core
if (cluster.isPrimary) {
  const numWorkers = os.availableParallelism();
  console.log(`Starting ${numWorkers} workers`);
  for (let i = 0; i < numWorkers; i++) {
    cluster.fork();
  }
  cluster.on('exit', (worker, code, signal) => {
    console.log(`Worker ${worker.process.pid} exited with code '${code}' and signal '${signal}'`);
    if (!worker.exitedAfterDisconnect) {
      console.log('Restarting worker ${worker.process.pid}, as it looks like its exit was unintentional');
      cluster.fork();
    }
  });
} else {
  app.listen(port, () => {
    console.log(`Worker ${process.pid} listening on port ${port}`);
  });
}