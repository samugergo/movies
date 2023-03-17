import express from 'express';
import cors from 'cors';
import axios from 'axios';
import { getPopular, getTopRated, getDetails, getRecomendations, getCast } from './services/movieService.js';

const app = express();

app.use(cors());

app.get('/popular', async (req, res) => {
  const popular = await getPopular(req.query);
  res.send(popular);
});

app.get('/top-rated', async (req, res) => {
  const topRated = await getTopRated(req.query);
  res.send(topRated);
});

app.get('/details/:id', async (req, res) => {
  const details = await getDetails({id: req.params.id, ...req.query});
  res.send(details);
});

app.get('/recommendations/:id', async (req, res) => {
  const recomends = await getRecomendations({id: req.params.id, ...req.query});
  res.send(recomends);
});

app.get('/cast/:id', async (req, res) => {
  const cast = await getCast({id: req.params.id,...req.query});
  res.send(cast);
});

app.get('/search/:query', async (req, res) => {
  const search = await searchMovie(req.params.query);
  res.send(search);
});

app.listen(8081, () => {
  console.log('Server running on http://localhost:8081');
});