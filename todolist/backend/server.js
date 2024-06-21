const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'flutter_todoo'
});

db.connect(err => {
  if (err) {
    throw err;
  }
  console.log('MySQL connected...');
});

app.get('/tasks', (req, res) => {
  let sql = 'SELECT * FROM tasks';
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.send(results);
  });
});

app.post('/tasks', (req, res) => {
  let task = req.body;
  let sql = 'INSERT INTO tasks SET ?';
  db.query(sql, task, (err, result) => {
    if (err) {
      console.error('Failed to add task:', err);
      res.status(500).send('Failed to add task');
    } else {
      res.status(200).json({ id: result.insertId, ...task });
    }
  });
});

app.delete('/tasks/:id', (req, res) => {
  let sql = `DELETE FROM tasks WHERE id = ${req.params.id}`;
  db.query(sql, (err, result) => {
    if (err) throw err;
    res.send('Task deleted...');
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
