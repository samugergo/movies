import { showMapper, showsMapper } from '../mappers/seriesMapper.js';
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

const type = process.env.SERIES_TYPE;

export async function getPopular(params) {
  const popular = await getPopularCommon(type, params);
  return showsMapper(popular);
}

export async function getTopRated(params) {
  const topRated = await getTopRatedCommon(type, params);
  return showsMapper(topRated);
}

export async function getDetails(params) {
  const details = await getDetailsCommon(type, params);
  const providers = await getProvidersCommon(type, params);

  const mappedProviders = providerMapper(providers);

  return showMapper(details, mappedProviders);
}

export async function getRecomendations(params) {
  const recommendations = await getRecomendationsCommon(type, params);
  return showsMapper(recommendations);
}

export async function getCast(params) {
  const cast = await getCastCommon(type, params);
  return castMapper(cast);
}

export async function searchSeries(params) {
  const search = await searchCommon(type, params);
  return search.msg ? search : showsMapper(search);
}