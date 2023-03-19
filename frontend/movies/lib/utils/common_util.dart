chunkList(list) {
  var chunks = [];
  int chunkSize = 2;
  for (var i = 0; i < list.length; i += chunkSize) {
    chunks.add(list.sublist(i, i+chunkSize > list.length ? list.length : i + chunkSize)); 
  }
  return chunks;
}