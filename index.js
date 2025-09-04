const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  console.log(`[${new Date().toISOString()}] Received request for: ${req.url}`);
  console.log(
    `[${new Date().toISOString()}] User-Agent: ${req.headers['user-agent']}`,
  );

  res.statusCode = 200;
  const msg = 'Hello Node!\n';
  res.end(msg);

  console.log(`[${new Date().toISOString()}] Response sent successfully`);
});

server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
  console.log(
    `[${new Date().toISOString()}] Application started with New Relic monitoring`,
  );
});
