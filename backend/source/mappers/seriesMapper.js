import { imageLink } from '../utils/util.js';

export function showsMapper(data) {
  return {
    ...data,
    results: data.results.map(m => ({
      id: m.id,
      title: m.name,
      release: m.first_air_date,
      percent: `${Math.round(m.vote_average * 10)}%`,
      raw: Math.round(m.vote_average * 10),
      image: imageLink(m.poster_path),
      cover: imageLink(m.backdrop_path),
    }))
  }
}

export function showMapper(data, providers) {
  return {
    id: data.id,
    title: data.name,
    release: data.first_air_date,
    percent: `${Math.round(data.vote_average * 10)}%`,
    raw: Math.round(m.vote_average * 10),
    image: imageLink(data.poster_path),
    cover: imageLink(data.backdrop_path),
    description: data.overview,
    genres: data.genres.map(g => g.name),
    seasons: data.seasons.map(s => ({
      id: s.id,
      title: s.name,
      release: s.air_date,
      episodes: s.episode_count,
      image: imageLink(s.poster_path),
    })),
    providers: providers,
  }
}