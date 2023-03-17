import axios from '../plugins/axios.js';
import dotenv from 'dotenv';
import { showMapper, showsMapper } from '../mappers/seriesMapper.js';
import { castMapper, providerMapper } from '../mappers/commonMapper.js';

dotenv.config();

export async function getPopular({lang = 'hu-HU', page = 1, region = 'HU'}) {
  const popular = await axios.get(
    `/tv/popular?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` + 
    `page=${page}&` + 
    `region=${region}`
  );
  return showsMapper(popular.data);
}

export async function getTopRated({lang = 'hu-HU', page = 1, region = 'HU'}) {
const popular = await axios.get(
    `/tv/top_rated?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` +
    `page=${page}&` +
    `region=${region}`
  );
  return showsMapper(popular.data);
}

export async function getDetails({id, lang = 'hu-HU'}) {
const details = await axios.get(
    `/tv/${id}?` + 
    `api_key=${process.env.API_KEY}&` + 
    `language=${lang}`
  );

  const providers = await getProviders(id);

  return showMapper(details.data, providers);
}

async function getProviders(id, region) {
  const providers = await axios.get(
    `/tv/${id}/watch/providers?` + 
    `api_key=${process.env.API_KEY}`
  );
  return providerMapper(providers.data, region);
}

export async function getRecomendations({id, lang = 'hu-HU', page = 1}) {
  const popular = await axios.get(
    `/tv/${id}/recommendations?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` +
    `page=${page}&`
  );
  return showsMapper(popular.data);
}

export async function getCast({id, lang}) {
  const _lang = lang || 'hu-HU';

  const cast = await axios.get(
    `/tv/${id}/credits?` + 
    `api_key=${process.env.API_KEY}&` + 
    `language=${_lang}`
  );
  return castMapper(cast.data);
}

export async function searchSeries({query, lang = 'hu-HU', page = 1}) {
  if (query) {
    const search = await axios.get(
      `/search/tv?` +
      `api_key=${process.env.API_KEY}&` +
      `page=${page}&` +
      `language=${lang}&` +
      `query=${query}`
    );
    return showsMapper(search.data);
  }
  return {
    msg: 'Add meg a keresett sorozat nevét!'
  };
}