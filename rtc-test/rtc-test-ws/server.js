const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 3000 });

wss.on('connection', function connection(ws) {
  console.log('New client connected');

  ws.on('message', function incoming(message) {
    console.log('Received message: %s', message);

    wss.clients.forEach(function each(client) {
      if (client !== ws && client.readyState === WebSocket.OPEN) {
        client.send(message);
        console.log('Message sent to a client');
      }
    });
  });

  ws.on('close', function close() {
    console.log('A client disconnected');
  });

  ws.on('error', function error(err) {
    console.error('WebSocket error observed: ', err);
  });
});

console.log('WebSocket server started on port 3000');

