export function imageLink(image) {
  if (image) {
    return process.env.IMAGE_URL + image;
  }
  return null;
}