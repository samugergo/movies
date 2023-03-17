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