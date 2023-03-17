import { movieMapper, moviesMapper } from '../mappers/movieMapper.js';
import { castMapper, providerMapper } from '../mappers/commonMapper.js';
import { 
  getPopularCommon,
  getTopRatedCommon,
  getDetailsCommon,
  getProvidersCommon,
  getRecomendationsCommon,
  getCastCommon,
  searchCommon,
} from '../services/commonService.js'; 

const type = process.env.MOVIES_TYPE;

console.log(type);

export async function getPopular(params) {
  const popular = await getPopularCommon(type, params);
  return moviesMapper(popular);
}

export async function getTopRated(params) {
  const topRated = await getTopRatedCommon(type, params);
  return moviesMapper(topRated);
}

export async function getDetails(params) {
  const details = await getDetailsCommon(type, params);
  const providers = await getProvidersCommon(type, params);

  const mappedProviders = providerMapper(providers);

  return movieMapper(details, mappedProviders);
}

export async function getRecomendations(params) {
  const recommendations = await getRecomendationsCommon(type, params);
  return moviesMapper(recommendations);
}

export async function getCast(params) {
  const cast = await getCastCommon(type, params);
  return castMapper(cast);
}

export async function searchMovie(params) {
  const search = await searchCommon(type, params);
  return search.msg ? search : moviesMapper(search);
}