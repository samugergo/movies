import { imageLink } from '../utils/util.js';

export function moviesMapper(data) {
  return {
    ...data,
    results: data.results.map(m => ({
      id: m.id,
      title: m.title,
      release: m.release_date,
      percent: `${Math.round(m.vote_average * 10)}%`,
      raw: m.vote_average,
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
    raw: m.vote_average,
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