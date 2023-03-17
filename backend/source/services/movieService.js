import axios from '../plugins/axios.js';
import dotenv from 'dotenv';
import { castMapper, movieMapper, moviesMapper, providerMapper } from '../mappers/movieMapper.js';

dotenv.config();

export async function getPopular({lang = 'hu-HU', page = 1, region = 'HU'}) {
  const popular = await axios.get(
    `/movie/popular?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` + 
    `page=${page}&` + 
    `region=${region}`
  );
  return moviesMapper(popular.data);
}

export async function getTopRated({lang = 'hu-HU', page = 1, region = 'HU'}) {
const popular = await axios.get(
    `/movie/top_rated?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` +
    `page=${page}&` +
    `region=${region}`
  );
  return moviesMapper(popular.data);
}

export async function getDetails({id, lang = 'hu-HU'}) {
const details = await axios.get(
    `/movie/${id}?` + 
    `api_key=${process.env.API_KEY}&` + 
    `language=${lang}`
  );

  const providers = await getProviders(id);

  return movieMapper(details.data, providers);
}

async function getProviders(id, region) {
  const providers = await axios.get(
    `/movie/${id}/watch/providers?` + 
    `api_key=${process.env.API_KEY}`
  );
  return providerMapper(providers.data, region);
}

export async function getRecomendations({id, lang = 'hu-HU', page = 1}) {
const popular = await axios.get(
    `/movie/${id}/recommendations?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` +
    `page=${page}&`
  );
  return moviesMapper(popular.data);
}

export async function getCast({id, lang}) {
  const _lang = lang || 'hu-HU';

  const cast = await axios.get(
    `/movie/${id}/credits?` + 
    `api_key=${process.env.API_KEY}&` + 
    `language=${_lang}`
  );
  return castMapper(cast.data);
}

export async function searchMovie({query, lang = 'hu-HU', page = 1}) {
  if (query) {
    const search = await axios.get(
      `/search/movie?` +
      `api_key=${process.env.API_KEY}&` +
      `page=${page}&` +
      `lang=${lang}&` +
      `query=${query}`
    );
    return moviesMapper(search.data);
  }
  return {
    msg: 'Add meg a keresett film nevét!'
  };
}