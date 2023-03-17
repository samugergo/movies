import axios from '../plugins/axios.js';

export async function getPopularCommon(type, {lang = 'hu-HU', page = 1, region = 'HU'}) {
  return await axios.get(
    `/${type}/popular?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` + 
    `page=${page}&` + 
    `region=${region}`
  ).then(res => res.data);
}

export async function getTopRatedCommon(type, {lang = 'hu-HU', page = 1, region = 'HU'}) {
  return await axios.get(
    `/${type}/top_rated?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` +
    `page=${page}&` +
    `region=${region}`
  ).then(res => res.data);
}

export async function getDetailsCommon(type, {id, lang = 'hu-HU'}) {
  return await axios.get(
    `/${type}/${id}?` + 
    `api_key=${process.env.API_KEY}&` + 
    `language=${lang}`
  ).then(res => res.data);
}

export async function getProvidersCommon(type, {id, region = 'HU'}) {
  return await axios.get(
    `/${type}/${id}/watch/providers?` + 
    `api_key=${process.env.API_KEY}&` +
    `region=${region}`
  ).then(res => res.data);
}

export async function getRecomendationsCommon(type, {id, lang = 'hu-HU', page = 1}) {
  return await axios.get(
    `/${type}/${id}/recommendations?` + 
    `api_key=${process.env.API_KEY}&` +
    `language=${lang}&` +
    `page=${page}&`
  ).then(res => res.data); 
}

export async function getCastCommon(type, {id, lang = 'hu-HU'}) {
  return await axios.get(
    `/${type}/${id}/credits?` + 
    `api_key=${process.env.API_KEY}&` + 
    `language=${lang}`
  ).then(res => res.data);
}

export async function searchCommon(type, {query, lang = 'hu-HU', page = 1}) {
  if (query) {
    return await axios.get(
      `/search/${type}?` +
      `api_key=${process.env.API_KEY}&` +
      `page=${page}&` +
      `language=${lang}&` +
      `query=${query}`
    ).then(res => res.data);
  }
  return {
    msg: `Add meg a keresett ${type === 'tv' ? 'sorozat' : 'film' } címét!`
  };
}