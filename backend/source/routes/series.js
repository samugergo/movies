import Router from 'express-promise-router';
import { 
  getPopular, 
  getTopRated, 
  getDetails, 
  getRecomendations, 
  getCast, 
  searchSeries 
} from '../services/seriesService.js';

const router = Router();

router.get('/popular', async (req, res) => {
  const popular = await getPopular(req.query);
  res.send(popular);
});

router.get('/top-rated', async (req, res) => {
  const topRated = await getTopRated(req.query);
  res.send(topRated);
});

router.get('/details/:id', async (req, res) => {
  const details = await getDetails({id: req.params.id, ...req.query});
  res.send(details);
});

router.get('/recommendations/:id', async (req, res) => {
  const recomends = await getRecomendations({id: req.params.id, ...req.query});
  res.send(recomends);
});

router.get('/cast/:id', async (req, res) => {
  const cast = await getCast({id: req.params.id,...req.query});
  res.send(cast);
});

router.get('/search', async (req, res) => {
  const search = await searchSeries(req.query);
  res.send(search);
});

export default router;