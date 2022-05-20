import padStart from 'lodash/padStart'

// タブの除去
export const removeTab = (str: string): string => {
  if (!str) {
    return ''
  }
  return str.replace(/\t/g, '')
}

// 改行コードの除去
export const nl2String = (str: string, val: string): string => {
  if (!str) {
    return ''
  }
  return str.replace(/\r?\n/g, val)
}

// 改行コードの除去
export const removeLine = (str: string): string => {
  return nl2String(str, '')
}

export const splitWhiteSpace = (str: string): string[] => {
  if (!str || str.length <= 0) {
    return []
  }
  return str.trim().split(/[\u{20}\u{3000}]/u)
}

// サロゲートペアに対応した配列化
export const stringToArray = (str: string) => {
  return str.match(/[\uD800-\uDBFF][\uDC00-\uDFFF]|[^\uD800-\uDFFF]/g) || []
}

// 全角文字列を半角文字列に変換
export const zenkakuToHankaku = (str: string) => {
  return str.replace(/[Ａ-Ｚａ-ｚ０-９]/g, (s) => {
    return String.fromCharCode(s.charCodeAt(0) - 0xfee0)
  })
}

// ３点リーダー(CSSのellipsisだと隠れるが、見えないところに長文が存在して重くなるのを避ける場合に使う)
export const ellipsis = (value: string, length: number): string => {
  if (value.length <= length) {
    return value
  }
  return `${value.slice(0, value.length > length ? length : value.length - 1)}${value.length > length && '...'}`
}

export const zeroPadding = (value: string | number, length: number): string => {
  return padStart(value.toString(), length, '0')
}

export const convertSecondToTimeString = (value: number): string => {
  const hour = Math.floor(value / 3600)
  const minute = Math.floor((value - hour * 3600) / 60)
  const second = Math.floor(value - hour * 3600 - minute * 60)
  return `${hour > 0 ? `${hour}:` : ''}${zeroPadding(minute, 2)}:${zeroPadding(second, 2)}`
}
