/**
 * 連想配列のソート（降順）用の比較関数
 * @param key
 */
const asc = (key: string): ((item1: { [key: string]: any }, item2: { [key: string]: any }) => number) => {
  return (item1, item2) => {
    if (item1[key] < item2[key]) {
      return -1
    }
    if (item1[key] > item2[key]) {
      return 1
    }
    return 0
  }
}

/**
 * 連想配列のソート（降順）用の比較関数
 * @param key
 */
const desc = (key: string): ((item1: { [key: string]: any }, item2: { [key: string]: any }) => number) => {
  return (item1, item2) => {
    if (item1[key] > item2[key]) {
      return -1
    }
    if (item1[key] < item2[key]) {
      return 1
    }
    return 0
  }
}

/**
 * ソート用の比較関数
 */
export const order = {
  asc,
  desc,
}

/**
 * 重複排除
 */
export const distinct = <T>(values?: T[]) => {
  if (!values || !values.length) {
    return []
  }
  const set = new Set(values)
  return [...set]
}

export const replaceArray = <T>(array: T[], targetId: number, sourceId: number): T[] => {
  const cloneArray: T[] = [...array]
  ;[cloneArray[targetId], cloneArray[sourceId]] = [array[sourceId], array[targetId]]
  return cloneArray
}
