const express = require('express');
const app = express();
const { version } = require('process');

const PORT = 3021;

app.get('/', (req, res) => {
  res.send(`Node.js Version: ${version} successfully installed`);
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
