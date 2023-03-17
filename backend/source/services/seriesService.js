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

export async function getPopular(params) {
  const popular = await getPopularCommon('tv', params);
  return showsMapper(popular);
}

export async function getTopRated(params) {
  const topRated = await getTopRatedCommon('tv', params);
  return showsMapper(topRated);
}

export async function getDetails(params) {
  const details = await getDetailsCommon('tv', params);
  const providers = await getProvidersCommon('tv', params);

  const mappedProviders = providerMapper(providers);

  return showMapper(details, mappedProviders);
}

export async function getRecomendations(params) {
  const recommendations = await getRecomendationsCommon('tv', params);
  return showsMapper(recommendations);
}

export async function getCast(params) {
  const cast = await getCastCommon('tv', params);
  return castMapper(cast);
}

export async function searchSeries(params) {
  const search = await searchCommon('tv', params);
  return search.msg ? search : showsMapper(search);
}