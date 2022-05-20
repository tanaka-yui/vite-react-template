export const sleep = (milliSeconds: number) => {
  return new Promise((resolve) => {
    setTimeout(() => resolve(undefined), milliSeconds)
  })
}
