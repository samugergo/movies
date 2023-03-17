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

export async function getPopular(params) {
  const popular = await getPopularCommon('movie', params);
  return moviesMapper(popular);
}

export async function getTopRated(params) {
  const topRated = await getTopRatedCommon('movie', params);
  return moviesMapper(topRated);
}

export async function getDetails(params) {
  const details = await getDetailsCommon('movie', params);
  const providers = await getProvidersCommon('movie', params);

  const mappedProviders = providerMapper(providers);

  return movieMapper(details, mappedProviders);
}

export async function getRecomendations(params) {
  const recommendations = await getRecomendationsCommon('movie', params);
  return moviesMapper(recommendations);
}

export async function getCast(params) {
  const cast = await getCastCommon('movie', params);
  return castMapper(cast);
}

export async function searchMovie(params) {
  const search = await searchCommon('movie', params);
  return search.msg ? search : moviesMapper(search);
}