import { imageLink } from '../utils/util.js';

export function moviesMapper(data) {
  return {
    ...data,
    results: data.results.map(m => ({
      id: m.id,
      title: m.title,
      release: m.release_date,
      percent: `${Math.round(m.vote_average * 10)}%`,
      image: imageLink(m.poster_path),
      cover: imageLink(m.backdrop_path),
    }))
  }
}

export function movieMapper(data, providers) {
  return {
    id: data.id,
    title: data.title,
    release: data.release_date,
    percent: `${Math.round(data.vote_average * 10)}%`,
    image: imageLink(data.poster_path),
    cover: imageLink(data.backdrop_path),
    description: data.overview,
    genres: data.genres.map(g => g.name),
    collection: {
      id: data.belongs_to_collection.id,
      title: data.belongs_to_collection.name,
      image: imageLink(data.belongs_to_collection.poster_path),
      cover: imageLink(data.belongs_to_collection.backdrop_path)
    },
    providers: providers,
  }
}

export function providerMapper(data, region) {
  const _region = region || 'HU';

  const rent = data.results[_region]?.rent?.map(r => ({
    id: r.provider_id,
    image: imageLink(r.logo_path),
    title: r.provider_name,
    priority: r.provider_priority,
  }));

  const buy = data.results[_region]?.buy?.map(r => ({
    id: r.provider_id,
    image: imageLink(r.logo_path),
    title: r.provider_name,
    priority: r.provider_priority,
  }));

  const streaming = data.results[_region]?.flatrate?.map(r => ({
    id: r.provider_id,
    image: imageLink(r.logo_path),
    title: r.provider_name,
    priority: r.provider_priority,
  }));

  if (rent && rent.length || buy && buy.length || streaming && streaming.length) { 
    return {
      rent: rent,
      buy: buy,
      streaming: streaming,
    };
  }
  return {
    msg: 'Egyik szolgáltatón sem érhető el a film!',
  };
}

export function castMapper(data) {
  return {
    ...data,
    cast: data.cast.map(c => ({
      id: c.id,
      name: c.original_name,
      character: c.character,
      image: imageLink(c.profile_path),
    }))
  }
}