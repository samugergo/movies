import express from 'express';
import cors from 'cors';
import movies from './routes/movies.js';
import series from './routes/series.js';

const app = express();

app.use(cors());

app.use('/series', series);
app.use('/movies', movies);

app.listen(8081, () => {
  console.log('Server running on http://localhost:8081');
});